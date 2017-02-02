ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IdleBlurBeta
IdleBlurBeta_FILES = Tweak.xm
IdleBlurBeta_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
