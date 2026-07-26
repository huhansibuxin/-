TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = WeChat
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = WCUnlock

WCUnlock_FILES = Tweak.xm
WCUnlock_CFLAGS = -fobjc-arc
WCUnlock_LDFLAGS = -dynamiclib

include $(THEOS_MAKE_PATH)/library.mk
