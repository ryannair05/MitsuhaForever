ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaInfinitySpringboardLS
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS += QuartzCore
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += MediaRemote
$(TWEAK_NAME)_LIBRARIES += mitsuha mitsuhainfinity
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk