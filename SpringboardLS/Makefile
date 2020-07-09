ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaForeverSpringboardLS
$(TWEAK_NAME)_FILES = SBTweak.xm
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += MediaRemote
$(TWEAK_NAME)_LIBRARIES += mitsuhaforever

include $(THEOS_MAKE_PATH)/tweak.mk