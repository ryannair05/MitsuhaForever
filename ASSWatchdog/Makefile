ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/common.mk

TWEAK_NAME = ASSWatchdog
$(TWEAK_NAME)_FILES = Tweak.c
$(TWEAK_NAME)_WEAK_LIBRARIES = $(THEOS_LIBRARY_PATH)/libhooker.dylib

include $(THEOS_MAKE_PATH)/tweak.mk