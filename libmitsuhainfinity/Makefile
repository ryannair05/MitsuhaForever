ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS_MAKE_PATH)/common.mk

LIBRARY_NAME = libmitsuhainfinity
$(LIBRARY_NAME)_OBJC_FILES = $(wildcard *.m)
$(LIBRARY_NAME)_CFLAGS = -I./
$(LIBRARY_NAME)_FRAMEWORKS += QuartzCore
$(LIBRARY_NAME)_LIBRARIES += colorpicker nepeta mitsuha
$(LIBRARY_NAME)_EXTRA_FRAMEWORKS += Cephei
$(LIBRARY_NAME)_USE_MODULES = 0

ADDITIONAL_CFLAGS = -Ipublic -Ioverlayheaders -I.

include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/MitsuhaInfinity
	$(ECHO_NOTHING)rsync -a ./public/* $(THEOS_STAGING_DIR)/usr/include/MitsuhaInfinity $(FW_RSYNC_EXCLUDES)$(ECHO_END)