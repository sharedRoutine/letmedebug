include theos/makefiles/common.mk

TWEAK_NAME = letmedebug
letmedebug_FILES = Tweak.xm
letmedebug_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
