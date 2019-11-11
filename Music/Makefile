ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:11.2
VERSION=0.1.8
FINAL_PACKAGE=1
DEBUG=0

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = MitsuhaInfinityMusic
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_LIBRARIES += mitsuha mitsuhainfinity
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk