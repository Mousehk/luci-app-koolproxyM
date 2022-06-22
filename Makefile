include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-koolproxyM
PKG_VERSION:=3.8.5
PKG_RELEASE:=20210427

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-koolproxyM
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI support for KoolproxyM
	DEPENDS:=+openssl-util +ipset +dnsmasq-full +@BUSYBOX_CONFIG_DIFF +iptables-mod-nat-extra +wget
	MAINTAINER:=panda-mute <wxuzju@gmail.com>
endef

define Build/Compile
endef

define Package/luci-app-koolproxyM/conffiles
	/etc/config/koolproxy
	/usr/share/koolproxy/data/rules/
endef

define Package/luci-app-koolproxyM/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/luci-koolproxy ) && rm -f /etc/uci-defaults/luci-koolproxy
	rm -f /tmp/luci-indexcache
fi
exit 0
endef

define Package/luci-app-koolproxyM/install
	$(INSTALL_DIR) $(1)/usr/
	cp -pR ./usr/* $(1)/usr/
	$(INSTALL_DIR) $(1)/lib/
	cp -pR ./lib/* $(1)/lib/
	$(INSTALL_DIR) $(1)/etc/
	cp -pR ./etc/* $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	po2lmo ./i18n/koolproxy.po $(1)/usr/lib/lua/luci/i18n/koolproxy.zh-cn.lmo

ifeq ($(ARCH),mipsel)
	$(INSTALL_BIN) ./bin/mipsel $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),mips)
	$(INSTALL_BIN) ./bin/mips $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),x86)
	$(INSTALL_BIN) ./bin/x86 $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),x86_64)
	$(INSTALL_BIN) ./bin/x86_64 $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./bin/arm $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),aarch64)
	$(INSTALL_BIN) ./bin/aarch64 $(1)/usr/share/koolproxy/koolproxy
endif
endef

$(eval $(call BuildPackage,luci-app-koolproxyM))