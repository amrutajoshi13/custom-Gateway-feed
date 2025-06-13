include $(TOPDIR)/rules.mk

PKG_NAME:=Silbo_Gateway_Software
PKG_RELEASE:=1.15

include $(INCLUDE_DIR)/package.mk

#LDFLAGS = -llibc -lconfig -lmosquitto -lssl -lresolv -lpthread  -lcrypto

define Package/Silbo_Gateway_Software
    SECTION:=utils
    CATEGORY:=RelySys Packages
    DEPENDS:=+busybox +libconfig +libmosquitto +libopenssl +libmodbus +libcurl +libsqlite3 +libuuid
    TITLE:=InterfaceManager scripts
endef

define Package/Silbo_Gateway_Software/description
InterfaceManager scripts for interface monitoring
endef

define Build/Compile
endef

define Package/Silbo_Gateway_Software/install
$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,Silbo_Gateway_Software,+libopenssl))
