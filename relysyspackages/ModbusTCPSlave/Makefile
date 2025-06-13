include $(TOPDIR)/rules.mk

PKG_NAME:=ModbusTCPSlave
PKG_RELEASE:=1.02

include $(INCLUDE_DIR)/package.mk

#LDFLAGS = -llibc -lconfig -lmosquitto -lssl -lresolv -lpthread  -lcrypto

define Package/ModbusTCPSlave
    SECTION:=utils
    CATEGORY:=RelySys Packages
    DEPENDS:=+libconfig +libmosquitto +libmodbus +libsqlite3 +libcurl
    TITLE:=InterfaceManager scripts
endef

define Package/ModbusTCPSlave/description
Silbo_TCP_Slave
endef

define Build/Compile
endef

define Package/ModbusTCPSlave/install
$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,ModbusTCPSlave,+libopenssl))
