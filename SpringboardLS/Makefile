ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:11.2
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaForeverSpringboardLS
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS += QuartzCore
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += MediaRemote
$(TWEAK_NAME)_LIBRARIES += mitsuhaforever

include $(THEOS_MAKE_PATH)/tweak.mk