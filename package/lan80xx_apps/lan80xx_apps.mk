################################################################################
#
# lan80xx_apps
#
################################################################################

LAN80XX_APPS_VERSION = ce2872f2a7eaecc8d1759f4a4a8c94edf0b1f1f4
LAN80XX_APPS_SITE = https://gitlab.com/v_cz/lan80xx_apps.git
LAN80XX_APPS_SITE_METHOD = git
LAN80XX_APPS_LICENSE = Proprietary
LAN80XX_APPS_DEPENDENCIES = mepa mepa_toolkit json-c
LAN80XX_APPS_INSTALL_STAGING = NO
LAN80XX_APPS_SUPPORTS_IN_SOURCE_BUILD = NO

#   MCP2210 default is ON — turn OFF here, MCP2210 is a USB-HID debug transport
#     that drags hidapi. Wrong for the RISC-V target. Also mepa_toolkit is
#     built with ENABLE_MCP2210=OFF, so its mepa_mcp2210.h is not staged.
#   MDIO   default is OFF — leave OFF, native MDIO is not the LAN80xx path.
#   SPIDEV default is OFF — turn ON, this matches mepa_toolkit's transport
#     for the production board (/dev/spidev0.0).
LAN80XX_APPS_CONF_OPTS = \
	-DENABLE_TESTS:BOOL=OFF \
	-DENABLE_MCP2210:BOOL=OFF \
	-DENABLE_MDIO:BOOL=OFF \
	-DENABLE_SPIDEV:BOOL=ON \
	-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc

# lan80xx-init.service is installed to /etc/systemd/system/ by the CMake
# install; enable it in multi-user.target so phy_init runs at boot.
define LAN80XX_APPS_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../lan80xx-init.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/lan80xx-init.service
endef

$(eval $(cmake-package))
