FINAL_PACKAGE=1
DEBUG=0

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += ASSWatchdog Prefs Music Spotify SpringboardLS SpringboardLSBackground

include $(THEOS_MAKE_PATH)/aggregate.mk