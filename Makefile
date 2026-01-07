ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
TARGET := iphone:clang:17.5:15.0
else
TARGET := iphone:clang:13.7:7.0
endif

INSTALL_TARGET_PROCESSES = Preferences SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LookinLoader2

LookinLoader2_FILES = Tweak.xm
LookinLoader2_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += LookinLoader2
include $(THEOS_MAKE_PATH)/aggregate.mk
