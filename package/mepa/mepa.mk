################################################################################
#
# mepa
#
################################################################################

MEPA_VERSION = 2025.12
MEPA_SITE = $(call github,microchip-ung,sw-mepa,v$(MEPA_VERSION))
MEPA_LICENSE = MIT
MEPA_LICENSE_FILES = LICENSE
MEPA_INSTALL_STAGING = YES
MEPA_SUPPORTS_IN_SOURCE_BUILD = NO

MEPA_MESA_VERSION = 2025.09
MEPA_MESA_ARCHIVE = mesa-$(MEPA_MESA_VERSION).tar.gz
MEPA_MESA_SITE = $(call github,microchip-ung,mesa,v$(MEPA_MESA_VERSION)/$(MEPA_MESA_ARCHIVE))

MEPA_EXTRA_DOWNLOADS = \
	$(MEPA_MESA_SITE)

MEPA_CONF_OPTS = -DMESA_OPSYS_LINUX:BOOL=ON \
				    -DBUILD_mepa:BOOL=ON \
					-DBUILD_mepa_drv_aqr:BOOL=$(if $(BR2_PACKAGE_MEPA_AQR),ON,OFF) \
					-DBUILD_mepa_drv_intel:BOOL=$(if $(BR2_PACKAGE_MEPA_INTEL),ON,OFF) \
					-DBUILD_mepa_drv_ksz9031:BOOL=$(if $(BR2_PACKAGE_MEPA_KSZ9031),ON,OFF) \
					-DBUILD_mepa_drv_lan80xx_ts_msec:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN80XX_TS_MSEC),ON,OFF) \
					-DBUILD_mepa_drv_lan8770:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN8770),ON,OFF) \
					-DBUILD_mepa_drv_lan8814:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN8814),ON,OFF) \
					-DBUILD_mepa_drv_lan8814_light:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN8814_LIGHT),ON,OFF) \
					-DBUILD_mepa_drv_lan884x:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN884x),ON,OFF) \
					-Dvsc7558:BOOL=$(if $(BR2_PACKAGE_MEPA_VSC7558),ON,OFF) \
					-Dlan966x:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN966x),ON,OFF) \
					-DBUILD_MEBA_edsx:BOOl=$(if $(BR2_PACKAGE_MEPA_EDSX),ON,OFF) \
					-DBUILD_MEBA_eds2:BOOl=$(if $(BR2_PACKAGE_MEPA_EDS2),ON,OFF)

ifeq ($(BR2_PACKAGE_MEPA_LAN80XX_TS),y)
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan80xx_ts:BOOL=ON \
					 -DMEPA_lan80xx_DFU_PROFILING:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN80XX_DFU_PROFILING),ON,OFF)
endif

ifeq ($(BR2_PACKAGE_MEPA_LAN867X),y)
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan867x:BOOL=ON \
					 -DMEPA_LAN867X_PHY_MAX:STRING=$(BR2_PACKAGE_MEPA_LAN867X_PHY_MAX) \
					 -DMEPA_LAN867X_STATIC_MEM:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN867X_STATIC_MEM),ON,OFF)
else
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan867x:BOOL=OFF
endif

ifeq ($(BR2_PACKAGE_MEPA_VTSS),y)
MEPA_CONF_OPTS += -DBUILD_mepa_drv_vtss_custom:BOOL=ON \
					 -DMEPA_vtss_opt_10g:BOOL=$(if $(BR2_PACKAGE_MEPA_VTSS_10G),ON,OFF) \
					 -DMEPA_vtss_opt_1g:BOOL=$(if $(BR2_PACKAGE_MEPA_VTSS_1G),ON,OFF) \
					 -DMEPA_vtss_opt_macsec:BOOL=$(if $(BR2_PACKAGE_MEPA_VTSS_MACSEC),ON,OFF) \
					 -DMEPA_vtss_opt_ts:BOOL=$(if $(BR2_PACKAGE_MEPA_VTSS_TS),ON,OFF) \
					 -DMEPA_vtss_opt_cnt:STRING=$(BR2_PACKAGE_MEPA_VTSS_CNT)
else
MEPA_CONF_OPTS += -DBUILD_mepa_drv_vtss_custom:BOOL=OFF
endif

ifeq ($(BR2_PACKAGE_MEPA_LAN887X),y)
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan887x:BOOL=ON \
					 -DMEPA_lan887x_phy_max:STRING=$(BR2_PACKAGE_MEPA_LAN887X_PHY_MAX) \
					 -DMEPA_lan887x_static_mem:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN887X_STATIC_MEM),ON,OFF)
else
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan887x:BOOL=OFF
endif

ifeq ($(BR2_PACKAGE_MEPA_LAN8X8X),y)
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan8x8x:BOOL=ON \
					 -DMEPA_lan8x8x_phy_max:STRING=$(BR2_PACKAGE_MEPA_LAN8X8X_PHY_MAX) \
					 -DMEPA_lan8x8x_static_mem:BOOL=$(if $(BR2_PACKAGE_MEPA_LAN8X8X_STATIC_MEM),ON,OFF)
else
MEPA_CONF_OPTS += -DBUILD_mepa_drv_lan8x8x:BOOL=OFF
endif

MEPA_RUBY_DEPS = parslet
define MEPA_RUBY_DEPS_INSALL
	$(foreach dep,$(MEPA_RUBY_DEPS), \
		$(HOST_DIR)/bin/gem install $(dep)
	)
endef
MEPA_PRE_CONFIGURE_HOOKS += MEPA_RUBY_DEPS_INSALL

define MEPA_EXTRACT_MESA
	mkdir -p $(@D)/sw-mesa
	$(call suitable-extractor,$(MEPA_MESA_ARCHIVE)) $(MEPA_DL_DIR)/$(MEPA_MESA_ARCHIVE) | \
	$(TAR) --strip-components=1 -C $(@D)/sw-mesa $(TAR_OPTIONS) -
endef
MEPA_POST_EXTRACT_HOOKS += MEPA_EXTRACT_MESA

MEPA_DEPENDENCIES += host-ruby

# There is no installation rule in MEPA CMake scripts.
# Only shared library build is supported at the moment.
define MEPA_INSTALL_STATIC_LIBS
	for lib in $$(find $($(PKG)_BUILDDIR) -type f -name "lib*.a" -printf "%P\n"); do \
		_d=$$(dirname "$(1)/usr/lib/$${lib}"); \
		mkdir -p $${_d}; \
		$(INSTALL) -D -m 0644 $($(PKG)_BUILDDIR)/$${lib} $(1)/usr/lib/$${lib} ; \
	done;
endef

MEPA_SHARED_LIBS = liblan966x.so \
	libvsc7558.so \
	board-configs/libmeba_edsx.so \
	board-configs/libmeba_eds2.so

define MEPA_INSTALL_SHARED_LIBS
	$(foreach lib,$(MEPA_SHARED_LIBS),
		$(INSTALL) -D -m 0755 $($(PKG)_BUILDDIR)/$(lib) \
			$(1)/usr/lib/mepa/$(lib); \
	)
endef

define MEPA_INSTALL_INCLUDES
	pushd "$($(PKG)_BUILDDIR)/include_common" >/dev/null; \
	for d in $$(find . -type d); do \
		mkdir -p $(1)/usr/include/mepa/$${d}; \
		find $${d} -maxdepth 1 -type f -name "*.h" \
			-exec $(INSTALL) -D -m 0644 {} $(1)/usr/include/mepa/$${d} \; ; \
	done; \
	popd >/dev/null
endef

define MEPA_INSTALL_STAGING_CMDS
	$(call MEPA_INSTALL_INCLUDES, $(STAGING_DIR))
	$(call MEPA_INSTALL_STATIC_LIBS, $(STAGING_DIR))
	$(call MEPA_INSTALL_SHARED_LIBS, $(STAGING_DIR))
endef

define MEPA_INSTALL_TARGET_CMDS
	$(call MEPA_INSTALL_SHARED_LIBS, $(TARGET_DIR))
endef

$(eval $(cmake-package))
