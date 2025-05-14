include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
 

 PKG_NAME:=mt7628-wifi
 PKG_SOURCE:=MT7628_LinuxAP_V4.1.1.0_DPA_20190925.tar.bz2
 PKG_SOURCE_URL:=http://vonger.cn/misc/vocore2/
 PKG_MD5SUM:=20db265032718ccde1c9e12f89939c0e
 PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)
 

 include $(INCLUDE_DIR)/package.mk
 
 PKG_CONFIG_DEPENDS:=\
     CONFIG_MT7628_AP_SUPPORT=m \
     CONFIG_SUPPORT_OPENWRT=y \
     CONFIG_RALINK_MT7628=y \
     CONFIG_MT7628_NEW_RATE_ADAPT_SUPPORT=y \
     CONFIG_MT7628_UAPSD=y \
     CONFIG_MT7628_MAC=y \
     CONFIG_MT7628_WSC_INCLUDED=y \
     CONFIG_MT7628_WSC_V2_SUPPORT=y \
     CONFIG_MT7628_DOT11W_PMF_SUPPORT=y \
     CONFIG_MT7628_MBSS_SUPPORT=y \
     CONFIG_MT7628_OWE_SUPPORT=y \
     CONFIG_MT7628_APCLI_SUPPORT=y \
     CONFIG_MT7628_SECURITY_IMPROVEMENT_SUPPORT=y \
     CONFIG_MT7628_CON_WPS_SUPPORT=y \
     CONFIG_MT7628_WPA3_SUPPORT=y 


     
 include $(INCLUDE_DIR)/package.mk
 

 TAR_CMD=$(HOST_TAR) -C $(1)/ $(TAR_OPTIONS)
 

 define KernelPackage/mt7628-wifi
   TITLE:=MTK MT7628 WiFi Driver
   FILES:=$(PKG_BUILD_DIR)/mt7628_wifi_ap/mt7628.ko
   SECTION:=vocore2
   CATEGORY:=VoCore2
   AUTOLOAD:=$(call AutoLoad,98,mt7628)
 endef
 

 define Build/Compile
     $(MAKE) -C "$(LINUX_DIR)" \
     CROSS_COMPILE="$(TARGET_CROSS)" \
     ARCH="$(LINUX_KARCH)" \
     SUBDIRS="$(PKG_BUILD_DIR)/mt7628_wifi_ap" \
     M="$(PKG_BUILD_DIR)/mt7628_wifi_ap" \
     $(PKG_CONFIG_DEPENDS) \
     modules
 endef
 
define KernelPackage/mt7628-wifi/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/ant1 $(1)/usr/bin
	$(INSTALL_BIN) ./files/ant2 $(1)/usr/bin
	$(INSTALL_DIR) $(1)/lib/netifd/wireless
	$(INSTALL_BIN) ./files/ralink.sh $(1)/lib/netifd/wireless/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/wireless/mt7628/
	$(INSTALL_BIN) ./files/mt7628.dat $(1)/etc/wireless/mt7628/
	echo p$(P4REV) > $(1)/etc/wireless/mt7628/version
endef

 $(eval $(call KernelPackage,mt7628-wifi))
