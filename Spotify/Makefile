ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:11.2

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaForeverSpotify
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_LIBRARIES += mitsuhaforever

include $(THEOS_MAKE_PATH)/tweak.mk