############################################################################
# external/zblue/Makefile
#
#   Copyright (C) 2020 Xiaomi Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name NuttX nor the names of its contributors may be
#    used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
############################################################################

-include $(APPDIR)/Make.defs

CXXEXT = .cc

CXXSRCS += audio_a2dp_hw/src/audio_a2dp_hw_utils.cc
CXXSRCS += audio_hearing_aid_hw/src/audio_hearing_aid_hw_utils.cc
CXXSRCS += $(wildcard bta/ag/*.cc)
CXXSRCS += $(wildcard bta/ar/*.cc)
CXXSRCS += $(wildcard bta/av/*.cc)
CXXSRCS += $(wildcard bta/dm/*.cc)
CXXSRCS += $(wildcard bta/gatt/*.cc)
CXXSRCS += $(wildcard bta/hd/*.cc)
CXXSRCS += $(wildcard bta/hf_client/*.cc)
CXXSRCS += $(wildcard bta/hh/*.cc)
CXXSRCS += $(wildcard bta/jv/*.cc)
CXXSRCS += $(wildcard bta/pan/*.cc)
CXXSRCS += $(wildcard bta/sdp/*.cc)
CXXSRCS += $(wildcard bta/sys/*.cc)
CXXSRCS += bta/hearing_aid/hearing_aid.cc
CXXSRCS += $(wildcard btcore/src/*.cc)
CXXSRCS += $(wildcard btif/avrcp/*.cc)
CXXSRCS += $(wildcard btif/co/*.cc)
CXXSRCS += $(wildcard btif/src/*.cc)
CXXSRCS += common/address_obfuscator.cc
CXXSRCS += common/metric_id_allocator.cc
CXXSRCS += common/metrics_linux.cc
CXXSRCS += common/once_timer.cc
CXXSRCS += common/repeating_timer.cc
CXXSRCS += common/time_util.cc
CXXSRCS += $(wildcard device/src/*.cc)
CXXSRCS += $(wildcard embdrv/g722/*.cc)
CXXSRCS += $(wildcard hci/src/*.cc)
CXXSRCS += $(wildcard main/*.cc)
CXXSRCS += osi/src/alarm.cc
CXXSRCS += osi/src/allocation_tracker.cc
CXXSRCS += osi/src/config.cc
CXXSRCS += osi/src/fixed_queue.cc
CXXSRCS += osi/src/future.cc
CXXSRCS += osi/src/list.cc
CXXSRCS += osi/src/mutex.cc
CXXSRCS += osi/src/osi.cc
CXXSRCS += osi/src/properties.cc
CXXSRCS += osi/src/reactor.cc
CXXSRCS += osi/src/ringbuffer.cc
CXXSRCS += osi/src/semaphore.cc
CXXSRCS += osi/src/thread.cc
CXXSRCS += osi/src/wakelock.cc
CXXSRCS += $(wildcard packet/avrcp/*.cc)
CXXSRCS += $(wildcard packet/base/*.cc)
CXXSRCS += $(wildcard profile/avrcp/*.cc)
CXXSRCS += $(wildcard service/*.cc)
CXXSRCS += $(wildcard service/common/bluetooth/*.cc)
CXXSRCS += $(wildcard service/common/bluetooth/util*.cc)
CXXSRCS += $(wildcard service/hal/*.cc)
CXXSRCS += stack/a2dp/a2dp_api.cc
CXXSRCS += stack/a2dp/a2dp_codec_config.cc
CXXSRCS += stack/a2dp/a2dp_sbc.cc
CXXSRCS += stack/a2dp/a2dp_sbc_decoder.cc
CXXSRCS += stack/a2dp/a2dp_sbc_encoder.cc
CXXSRCS += stack/a2dp/a2dp_sbc_up_sample.cc
CXXSRCS += stack/a2dp/a2dp_vendor.cc
CXXSRCS += $(wildcard stack/acl/*.cc)
CXXSRCS += $(wildcard stack/avct/*.cc)
CXXSRCS += $(wildcard stack/avdt/*.cc)
CXXSRCS += $(wildcard stack/avrc/*.cc)
CXXSRCS += $(wildcard stack/bnep/*.cc)
CXXSRCS += $(wildcard stack/btm/*.cc)
CXXSRCS += $(wildcard stack/btu/*.cc)
CXXSRCS += $(wildcard stack/crypto_toolbox/*.cc)
CXXSRCS += $(wildcard stack/eatt/*.cc)
CXXSRCS += $(wildcard stack/gap/*.cc)
CXXSRCS += $(wildcard stack/gatt/*.cc)
CXXSRCS += $(wildcard stack/hcic/*.cc)
CXXSRCS += $(wildcard stack/hid/*.cc)
CXXSRCS += $(wildcard stack/l2cap/*.cc)
CXXSRCS += $(wildcard stack/pan/*.cc)
CXXSRCS += $(wildcard stack/rfcomm/*.cc)
CXXSRCS += $(wildcard stack/sdp/*.cc)
CXXSRCS += $(wildcard stack/smp/*.cc)
CXXSRCS += $(wildcard stack/srvc/*.cc)
CXXSRCS += types/bluetooth/uuid.cc
CXXSRCS += types/raw_address.cc
CXXSRCS += utils/src/bt_utils.cc

PORTCXXSRCS += port/audio_hal_interface/a2dp_encoding.cc
PORTCXXSRCS += port/bta/hearing_aid/hearing_aid_audio_source.cc
PORTCXXSRCS += port/btcore/src/module.cc
PORTCXXSRCS += port/common/metrics.cc
PORTCXXSRCS += port/common/message_loop_thread.cc
PORTCXXSRCS += port/gd/common/init_flags.cc
PORTCXXSRCS += port/hci/src/btsnoop_net.cc
PORTCXXSRCS += port/osi/src/allocator.cc
PORTCXXSRCS += port/udrv/ulinux/uipc.cc
PORTCXXSRCS += port/btif/co/bta_hh_co.cc
PORTCXXSRCS += port/btif/src/btif_bqr.cc
PORTCXXSRCS += port/btif/src/btif_debug_btsnoop.cc
PORTCXXSRCS += port/btif/src/btif_keystore.cc
PORTCXXSRCS += port/btif/src/btif_pan.cc
PORTCXXSRCS += port/btif/src/btif_sock.cc
PORTCXXSRCS += port/btif/src/btif_sock_rfc.cc
PORTCXXSRCS += $(wildcard port/main/shim/*.cc)

ifeq ($(CONFIG_FLUORIDE_HCI_H4),y)
  PORTCXXSRCS += port/hci/src/hci_layer_h4.cc
endif

ifeq ($(CONFIG_FLUORIDE_HCI_USB),y)
  PORTCXXSRCS += port/hci/src/hci_layer_libusb.cc
endif

ifeq ($(CONFIG_AUDIO),y)
  PORTCXXSRCS += port/btif/src/btif_avrcp_audio_track_nuttx.cc
endif

CXXSRCS += $(PORTCXXSRCS)

ifeq ($(CONFIG_AUDIO),y)
  PORTCXXSRCS += btif/src/btif_avrcp_audio_track_linux.cc
endif
PORTCXXSRCS += btif/src/btif_avrcp_audio_track.cc
PORTCXXSRCS += btif/src/btif_a2dp_audio_interface.cc
PORTCXXSRCS += btif/src/btif_sock_util.cc
PORTCXXSRCS += btif/src/btif_sock_sco.cc
PORTCXXSRCS += btif/src/btif_sock_thread.cc
PORTCXXSRCS += btif/src/btif_sock_l2cap.cc
PORTCXXSRCS += hci/src/hci_layer_android.cc
PORTCXXSRCS += hci/src/hci_layer_linux.cc

CXXSRCS := $(filter-out $(subst port/,,$(PORTCXXSRCS)), $(CXXSRCS))

ifneq ($(CONFIG_LIB_ZLIB),)
  CXXSRCS := $(filter-out port/btif/src/btif_debug_btsnoop.cc, $(CXXSRCS))
  CXXSRCS += btif/src/btif_debug_btsnoop.cc
endif

FLRDFLAGS += "-DEXPORT_SYMBOL=__attribute__((visibility(\"default\")))" -DOS_POSIX -D_POSIX_MONOTONIC_CLOCK=1 -DNDEBUG
FLRDFLAGS += -Wno-undef -Wno-shadow -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-value
FLRDFLAGS += -D_GNU_SOURCE -DFALLTHROUGH_INTENDED -DOS_GENERIC -fno-exceptions -DHAS_BDROID_BUILDCFG

ifeq ($(CONFIG_ARCH_SIM),y)
  FLRDFLAGS += -O2 -fno-strict-aliasing
  FLRDFLAGS += -ffunction-sections -fdata-sections
endif

FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" port}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" port/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" .}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" bta/sys}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" utils/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" internal_include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" types}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" service}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" service/common}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" btif/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" bta/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" hci/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" linux_include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" btcore/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" btif/avrcp}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/btm}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" bta}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" bta/gatt}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" bta/hh}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" bta/dm}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" udrv/include}

FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/avct}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/eatt}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/l2cap}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/gatt}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" stack/sdp}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" vnd/ble}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" gd}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" gd/dumpsys}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" audio_a2dp_hw/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" audio_hearing_aid_hw/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" profile/avrcp}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" packet/avrcp}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" vnd/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" audio_hal_interface}

FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" android}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" android/frameworks/base/core/proto}

FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" embdrv/sbc/decoder/include}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" embdrv/sbc/encoder/include}

FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/libchrome}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/libchrome/port}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/tinyxml2}
FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/modp_b64}

ifeq ($(CONFIG_ARCH_SIM),)
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" port/deprecated}
endif

# CONFIG_CODEC_SBC

CSRCS += $(wildcard embdrv/sbc/*/srce/*.c)

ifneq ($(CONFIG_CODEC_FDKAAC),)
  CXXSRCS += stack/a2dp/a2dp_aac.cc
  CXXSRCS += stack/a2dp/a2dp_aac_decoder.cc
  CXXSRCS += stack/a2dp/a2dp_aac_encoder.cc
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libAACdec/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libAACenc/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libFDK/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libSYS/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libSBRdec/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libMpegTPDec/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libPCMutils/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libArithCoding/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libDRCdec/include}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/aac/libSACdec/include}
endif

ifneq ($(CONFIG_CODEC_LDAC),)
  CXXSRCS += stack/a2dp/a2dp_vendor_ldac.cc

  CXXSRCS += port/stack/a2dp/a2dp_vendor_ldac_decoder.cc
  CXXSRCS += port/stack/a2dp/a2dp_vendor_ldac_encoder.cc
  CXXSRCS += port/stack/a2dp/a2dp_vendor_ldac_abr.cc

  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/libldac/inc}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/libldac/src}
  FLRDFLAGS += ${shell $(INCDIR) $(INCDIROPT) "$(CC)" $(APPDIR)/external/libldac/abr/inc}
endif

ifneq ($(CONFIG_CODEC_APTX),)
  CXXSRCS += stack/a2dp/a2dp_vendor_aptx.cc
  CXXSRCS += stack/a2dp/a2dp_vendor_aptx_encoder.cc
  CXXSRCS += stack/a2dp/a2dp_vendor_aptx_hd.cc
  CXXSRCS += stack/a2dp/a2dp_vendor_aptx_hd_encoder.cc
endif

CXXFLAGS += $(FLRDFLAGS) -fpermissive
CFLAGS   += $(FLRDFLAGS)

ifneq ($(CONFIG_FLUORIDE_EXAMPLES),)

  PRIORITY  = SCHED_PRIORITY_DEFAULT
  STACKSIZE = $(CONFIG_DEFAULT_TASK_STACKSIZE)
  MODULE    = $(CONFIG_FLUORIDE_EXAMPLES)

  ifneq ($(CONFIG_FLUORIDE_EXAMPLES_A2DP_SINK),)
    PROGNAME  += a2dp_sink
    MAINSRC   += port/examples/a2dp_sink.cc
  endif

endif

include $(APPDIR)/Application.mk
