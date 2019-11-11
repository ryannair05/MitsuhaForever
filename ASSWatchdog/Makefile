ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:11.2


include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = ASSWatchdog
$(TWEAK_NAME)_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk