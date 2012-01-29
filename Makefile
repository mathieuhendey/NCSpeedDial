include theos/makefiles/common.mk
include number.txt

BUNDLE_NAME = NCSpeedDial
NCSpeedDial_FILES = NCSpeedDialController.m
NCSpeedDial_INSTALL_PATH = /System/Library/WeeAppPlugins/
NCSpeedDial_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
