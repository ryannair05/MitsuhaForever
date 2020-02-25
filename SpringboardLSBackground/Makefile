ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaForeverSpringboardLSBackground
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS += QuartzCore
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += QuartzCore MediaRemote
$(TWEAK_NAME)_LIBRARIES += mitsuhaforever

include $(THEOS_MAKE_PATH)/tweak.mk