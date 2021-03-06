/******************************************************************************
 *
 *  Copyright 2015 Google Inc.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at:
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

#include <mutex>

#include <base/logging.h>
#include <zlib.h>

#include "btif/include/btif_debug.h"
#include "btif/include/btif_debug_btsnoop.h"
#include "hci/include/btsnoop_mem.h"
#include "internal_include/bt_target.h"
#include "osi/include/ringbuffer.h"

#define REDUCE_HCI_TYPE_TO_SIGNIFICANT_BITS(type) ((type) >> 8)

// Total btsnoop memory log buffer size
#ifndef BTSNOOP_MEM_BUFFER_SIZE
static const size_t BTSNOOP_MEM_BUFFER_SIZE = (256 * 1024);
#endif

// Block size for copying buffers (for compression/encoding etc.)
static const size_t BLOCK_SIZE = 16384;

// Maximum line length in bugreport (should be multiple of 4 for base64 output)
static const uint8_t MAX_LINE_LENGTH = 128;

static std::mutex buffer_mutex;
static ringbuffer_t* buffer = NULL;
static uint64_t last_timestamp_ms = 0;

static size_t btsnoop_calculate_packet_length(uint16_t type,
                                              const uint8_t* data,
                                              size_t length);

static void btsnoop_cb(const uint16_t type, const uint8_t* data,
                       const size_t length, const uint64_t timestamp_us) {
  btsnooz_header_t header;

  size_t included_length = btsnoop_calculate_packet_length(type, data, length);
  if (included_length == 0) return;

  std::lock_guard<std::mutex> lock(buffer_mutex);

  // Make room in the ring buffer

  while (ringbuffer_available(buffer) <
         (included_length + sizeof(btsnooz_header_t))) {
    ringbuffer_pop(buffer, (uint8_t*)&header, sizeof(btsnooz_header_t));
    ringbuffer_delete(buffer, header.length - 1);
  }

  // Insert data
  header.type = REDUCE_HCI_TYPE_TO_SIGNIFICANT_BITS(type);
  header.length = included_length + 1;  // +1 for type byte
  header.packet_length = length + 1;    // +1 for type byte.
  header.delta_time_ms =
      last_timestamp_ms ? timestamp_us - last_timestamp_ms : 0;
  last_timestamp_ms = timestamp_us;

  ringbuffer_insert(buffer, (uint8_t*)&header, sizeof(btsnooz_header_t));
  ringbuffer_insert(buffer, data, included_length);
}

static size_t btsnoop_calculate_packet_length(uint16_t type,
                                              const uint8_t* data,
                                              size_t length) {
  static const size_t HCI_ACL_HEADER_SIZE = 4;
  static const size_t L2CAP_HEADER_SIZE = 4;
  static const size_t L2CAP_CID_OFFSET = (HCI_ACL_HEADER_SIZE + 2);
  static const uint16_t L2CAP_SIGNALING_CID = 0x0001;

  // Maximum amount of ACL data to log.
  // Enough for an RFCOMM frame up to the frame check;
  // not enough for a HID report or audio data.
  static const size_t MAX_HCI_ACL_LEN = 14;

  // Calculate packet length to be included

  switch (type) {
    case BT_EVT_TO_LM_HCI_CMD:
      return length;

    case BT_EVT_TO_BTU_HCI_EVT:
      return length;

    case BT_EVT_TO_LM_HCI_ACL:
    case BT_EVT_TO_BTU_HCI_ACL: {
      size_t len_hci_acl = HCI_ACL_HEADER_SIZE + L2CAP_HEADER_SIZE;
      // Check if we have enough data for an L2CAP header
      if (length > len_hci_acl) {
        uint16_t l2cap_cid =
            data[L2CAP_CID_OFFSET] | (data[L2CAP_CID_OFFSET + 1] << 8);
        if (l2cap_cid == L2CAP_SIGNALING_CID) {
          // For the signaling CID, take the full packet.
          // That way, the PSM setup is captured, allowing decoding of PSMs down
          // the road.
          return length;
        } else {
          // Otherwise, return as much as we reasonably can
          len_hci_acl = MAX_HCI_ACL_LEN;
        }
      }
      return len_hci_acl < length ? len_hci_acl : length;
    }

    case BT_EVT_TO_LM_HCI_SCO:
    case BT_EVT_TO_BTU_HCI_SCO:
      // We're not logging SCO packets at this time since they are not currently
      // used.
      FALLTHROUGH_INTENDED; /* FALLTHROUGH */
    default:
      return 0;
  }
}

static bool btsnoop_compress(ringbuffer_t* rb_dst, ringbuffer_t* rb_src) {
  CHECK(rb_dst != NULL);
  CHECK(rb_src != NULL);

  z_stream zs;
  zs.zalloc = Z_NULL;
  zs.zfree = Z_NULL;
  zs.opaque = Z_NULL;

  if (deflateInit(&zs, Z_DEFAULT_COMPRESSION) != Z_OK) return false;

  bool rc = true;
  uint8_t block_src[BLOCK_SIZE];
  uint8_t block_dst[BLOCK_SIZE];

  const size_t num_blocks =
      (ringbuffer_size(rb_src) + BLOCK_SIZE - 1) / BLOCK_SIZE;
  for (size_t i = 0; i < num_blocks; ++i) {
    zs.avail_in =
        ringbuffer_peek(rb_src, i * BLOCK_SIZE, block_src, BLOCK_SIZE);
    zs.next_in = block_src;

    do {
      zs.avail_out = BLOCK_SIZE;
      zs.next_out = block_dst;

      int err = deflate(&zs, (i == num_blocks - 1) ? Z_FINISH : Z_NO_FLUSH);
      if (err == Z_STREAM_ERROR) {
        rc = false;
        break;
      }

      const size_t length = BLOCK_SIZE - zs.avail_out;
      ringbuffer_insert(rb_dst, block_dst, length);
    } while (zs.avail_out == 0);
  }

  deflateEnd(&zs);
  return rc;
}

void btif_debug_btsnoop_init(void) {
  if (buffer == NULL) buffer = ringbuffer_init(BTSNOOP_MEM_BUFFER_SIZE);
  btsnoop_mem_set_callback(btsnoop_cb);
}

void btif_debug_btsnoop_dump(int fd) {
  ringbuffer_t* ringbuffer = ringbuffer_init(BTSNOOP_MEM_BUFFER_SIZE);
  if (ringbuffer == NULL) {
    dprintf(fd, "%s Unable to allocate memory for compression", __func__);
    return;
  }

  // Prepend preamble

  btsnooz_preamble_t preamble;
  preamble.version = BTSNOOZ_CURRENT_VERSION;
  preamble.last_timestamp_ms = last_timestamp_ms;
  ringbuffer_insert(ringbuffer, (uint8_t*)&preamble,
                    sizeof(btsnooz_preamble_t));

  // Compress data

  uint8_t b64_in[3] = {0};
  char b64_out[5] = {0};

  size_t line_length = 0;

  bool rc;
  {
    std::lock_guard<std::mutex> lock(buffer_mutex);
    dprintf(fd, "--- BEGIN:BTSNOOP_LOG_SUMMARY (%zu bytes in) ---\n",
            ringbuffer_size(buffer));
    rc = btsnoop_compress(ringbuffer, buffer);
  }

  if (!rc) {
    dprintf(fd, "%s Log compression failed", __func__);
    goto error;
  }

  // Base64 encode & output

  while (ringbuffer_size(ringbuffer) > 0) {
    size_t read = ringbuffer_pop(ringbuffer, b64_in, 3);
    if (line_length >= MAX_LINE_LENGTH) {
      dprintf(fd, "\n");
      line_length = 0;
    }
    extern int b64_ntop(unsigned char const *src, size_t srclength, char *target, size_t targsize);
    line_length += b64_ntop(b64_in, read, b64_out, 5);
    dprintf(fd, "%s", b64_out);
  }

  dprintf(fd, "\n--- END:BTSNOOP_LOG_SUMMARY ---\n");

error:
  ringbuffer_free(ringbuffer);
}

#if defined(__NuttX__)
static const char Base64[] =
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const char Pad64 = '=';

int b64_ntop(unsigned char const *src, size_t srclength, char *target, size_t targsize) {
  size_t datalength = 0;
  unsigned char input[3];
  unsigned char output[4];
  size_t i;

  input[0] = input[1] = input[2] = '\0';
  while (2 < srclength) {
    input[0] = *src++;
    input[1] = *src++;
    input[2] = *src++;
    srclength -= 3;

    output[0] = input[0] >> 2;
    output[1] = ((input[0] & 0x03) << 4) + (input[1] >> 4);
    output[2] = ((input[1] & 0x0f) << 2) + (input[2] >> 6);
    output[3] = input[2] & 0x3f;

    if (datalength + 4 > targsize)
      return (-1);
    target[datalength++] = Base64[output[0]];
    target[datalength++] = Base64[output[1]];
    target[datalength++] = Base64[output[2]];
    target[datalength++] = Base64[output[3]];
  }

  /* Now we worry about padding. */
  if (0 != srclength) {
    /* Get what's left. */
    input[0] = input[1] = input[2] = '\0';
    for (i = 0; i < srclength; i++)
      input[i] = *src++;

    output[0] = input[0] >> 2;
    output[1] = ((input[0] & 0x03) << 4) + (input[1] >> 4);
    output[2] = ((input[1] & 0x0f) << 2) + (input[2] >> 6);

    if (datalength + 4 > targsize)
      return (-1);
    target[datalength++] = Base64[output[0]];
    target[datalength++] = Base64[output[1]];
    if (srclength == 1)
      target[datalength++] = Pad64;
    else
      target[datalength++] = Base64[output[2]];
    target[datalength++] = Pad64;
  }
  if (datalength >= targsize)
    return (-1);
  target[datalength] = '\0';  /* Returned value doesn't count \0. */
  return ((int)datalength);
}
#endif
