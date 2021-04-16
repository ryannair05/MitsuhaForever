ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaForeverSpringboard
$(TWEAK_NAME)_FILES = SBTweak.xm HomescreenTweak.xm ControlCenterTweak.xm
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += MediaRemote
$(TWEAK_NAME)_LIBRARIES += mitsuhaforever

include $(THEOS_MAKE_PATH)/tweak.mk