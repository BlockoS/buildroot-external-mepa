################################################################################
#
# mepa_toolkit
#
################################################################################

MEPA_TOOLKIT_VERSION = 728ec2a3b924ca82d8fdc858bb8bf970b487a10f
MEPA_TOOLKIT_SITE = https://gitlab.com/v_cz/mepa_toolkit.git
MEPA_TOOLKIT_SITE_METHOD = git
MEPA_TOOLKIT_LICENSE = Proprietary
MEPA_TOOLKIT_DEPENDENCIES = mepa
MEPA_TOOLKIT_INSTALL_STAGING = YES
MEPA_TOOLKIT_SUPPORTS_IN_SOURCE_BUILD = NO

# Sub-library / transport selection.
#   MCP2210 default is ON — turn OFF here, MCP2210 is a USB-HID debug transport
#     that drags hidapi. Wrong for the RISC-V target.
#   SPIDEV default is OFF — turn ON, this is the native transport for the
#     production board (LAN80xx on /dev/spidev0.0).
#   USE_JOURNALD OFF (default) — buildroot has BR2_PACKAGE_HAS_UDEV etc. but
#     we keep the mepa_toolkit log path to stderr / syslog for simplicity.
MEPA_TOOLKIT_CONF_OPTS = \
	-DBUILD_SHARED_LIBS:BOOL=ON \
	-DENABLE_TESTS:BOOL=OFF \
	-DENABLE_MCP2210:BOOL=OFF \
	-DENABLE_SPIDEV:BOOL=ON

$(eval $(cmake-package))
