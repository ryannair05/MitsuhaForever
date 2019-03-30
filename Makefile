export ARCHS = arm64
export TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += ASSWatchdog libmitsuhainfinity Prefs Music Spotify SpringboardLS

include $(THEOS_MAKE_PATH)/aggregate.mk