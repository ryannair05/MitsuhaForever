FINALPACKAGE = 1

PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

export ADDITIONAL_CFLAGS = -DTHEOS_LEAN_AND_MEAN -fobjc-arc -O3
export TARGET = iphone:13.5:12.0

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += ASSWatchdog Homescreen Music Prefs Spotify SpringboardLS SpringboardLSBackground 

after-install::
	install.exec "killall -9 SpringBoard"
	
include $(THEOS_MAKE_PATH)/aggregate.mk