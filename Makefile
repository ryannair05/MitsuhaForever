FINAL_PACKAGE=1
DEBUG=0

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += ASSWatchdog libmitsuhainfinity Prefs Music Spotify SoundCloud SpringboardLS SpringboardLSBackground

include $(THEOS_MAKE_PATH)/aggregate.mk