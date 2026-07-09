################################################################################
#
# lan80xx_apps
#
################################################################################

LAN80XX_APPS_VERSION = 1d676d12927b1e92c95e6a9c42fd4e616e5b49f9
LAN80XX_APPS_SITE = https://gitlab.com/v_cz/lan80xx_apps.git
LAN80XX_APPS_SITE_METHOD = git
LAN80XX_APPS_LICENSE = Proprietary
LAN80XX_APPS_DEPENDENCIES = mepa mepa_toolkit json-c
LAN80XX_APPS_INSTALL_STAGING = NO
LAN80XX_APPS_SUPPORTS_IN_SOURCE_BUILD = NO

LAN80XX_APPS_CONF_OPTS = \
	-DENABLE_TESTS:BOOL=OFF \
	-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc

# lan80xx-init.service is installed to /etc/systemd/system/ by the CMake
# install; enable it in multi-user.target so phy_init runs at boot.
define LAN80XX_APPS_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../lan80xx-init.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/lan80xx-init.service
endef

$(eval $(cmake-package))
