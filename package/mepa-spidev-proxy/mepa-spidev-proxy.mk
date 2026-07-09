################################################################################
#
# mepa-spidev-proxy
#
################################################################################

MEPA_SPIDEV_PROXY_VERSION = 4aecafd004b2895c00ba791bc8911ef37df3067a
MEPA_SPIDEV_PROXY_SITE = https://github.com/vjardin/mepa-spidev-proxy.git
MEPA_SPIDEV_PROXY_SITE_METHOD = git
MEPA_SPIDEV_PROXY_LICENSE = MIT
MEPA_SPIDEV_PROXY_INSTALL_STAGING = YES
MEPA_SPIDEV_PROXY_SUPPORTS_IN_SOURCE_BUILD = NO

# No dependencies beyond libc (README). Exports a CMake config package that
# sw-mepa optionally consumes via find_package(mepa_spidev_proxy), so it must
# be staged before mepa.
MEPA_SPIDEV_PROXY_CONF_OPTS = \
	-DSPIPROXY_STATIC:BOOL=OFF

define MEPA_SPIDEV_PROXY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 \
		$(MEPA_SPIDEV_PROXY_PKGDIR)/lan80xx-spid.service \
		$(TARGET_DIR)/usr/lib/systemd/system/lan80xx-spid.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf ../../../../usr/lib/systemd/system/lan80xx-spid.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/lan80xx-spid.service
endef

$(eval $(cmake-package))
