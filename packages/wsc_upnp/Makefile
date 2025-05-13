#############################################################
# Makefile for WSC upnp module
#############################################################

ifndef ROOTDIR
ROOTDIR = ../..
export ROOTDIR
endif

#LIB_PATH = $(ROOTDIR)/lib/lib
LIB_PATH = /home/anusha/Anusha_workspace/Projects/openwrt/Silbo_RC44_openwrt/build_dir/target-mipsel_24kc_musl/libupnp-1.8.7/ipkg-install/usr/lib
# Compile build-in libupnp-1.3.1
#LIB_PATH = ./

CROSS_COMPILE = /opt/openwrt-toolchain-ramips-mt76x8_gcc-7.5.0_musl.Linux-x86_64/toolchain-mipsel_24kc_gcc-7.5.0_musl/bin/mipsel-openwrt-linux-
TARGET_HOST = mipsel-linux
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
STRIP = $(CROSS_COMPILE)strip
#WIRELESS_H_INCLUDE_PATH = $(ROOTDIR)/linux-2.4.x/include/
WIRELESS_H_INCLUDE_PATH = /home/anusha/Anusha_workspace/Projects/openwrt/Silbo_RC44_openwrt/staging_dir/toolchain-mipsel_24kc_gcc-7.5.0_musl/include

PWD = $(shell pwd)

#LIBUPNP_SRC_PATH = $(ROOTDIR)/lib/libupnp
LIBUPNP_SRC_PATH = /home/anusha/Anusha_workspace/Projects/openwrt/Silbo_RC44_openwrt/package/libs/libupnp
# Compile build-in libupnp-1.3.1
#LIBUPNP_SRC_PATH = ./libupnp-1.3.1

LIBUPNP_LIB_PATH = $(PWD)/$(LIBUPNP_SRC_PATH)

INCLUDE_PATH += -I. -I$(LIBUPNP_SRC_PATH) -I$(LIBUPNP_SRC_PATH)/upnp/inc -I$(LIBUPNP_SRC_PATH)/upnp/src/inc
INCLUDE_PATH += -I$(LIBUPNP_SRC_PATH)/ixml/inc -I$(LIBUPNP_SRC_PATH)/ixml/src/inc  -I$(LIBUPNP_SRC_PATH)/threadutil/inc
INCLUDE_PATH += -I$(WIRELESS_H_INCLUDE_PATH)

#INCLUDE_LIBS := -static -L$(LIBUPNP_LIB_PATH)/upnp/.libs/ -lupnp -L$(LIBUPNP_LIB_PATH)/ixml/.libs/ -lixml -L$(LIBUPNP_LIB_PATH)/threadutil/.libs -lthreadutil -lpthread

# YY
# wscd .a version
#INCLUDE_LIBS := -L$(PWD) -lupnp -lixml -lthreadutil -lpthread
# wscd .so version
#INCLUDE_LIBS := -static -L$(LIB_PATH) -lupnp -lixml -lthreadutil -lpthread
INCLUDE_LIBS := -L$(LIB_PATH) -lupnp -lixml -lpthread

OBJS = wsc_main.o wsc_common.o wsc_ioctl.o wsc_netlink.o wsc_upnp_device.o wsc_upnp_cp.o sample_util.o wsc_msg.o

EXEC = wscd

CFLAGS += -O2 -Wall -D_REENTRANT $(INCLUDE_PATH)
#CFLAGS += -DRT_DEBUG
CFLAGS += -DMULTIPLE_CARD_SUPPORT

all: $(EXEC)

# Compile build-in libupnp-1.3.1
#$(LIBUPNP_SRC_PATH)/Makefile:
#	make -C $(LIBUPNP_SRC_PATH) -f Makefile.src TARGET_HOST=$(TARGET_HOST)

$(EXEC):  $(OBJS)
# Compile build-in libupnp-1.3.1
#$(EXEC): libupnp $(OBJS)
#	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS)  $(INCLUDE_LIBS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)  $(INCLUDE_LIBS)
	$(STRIP) -s $(EXEC)

# Compile build-in libupnp-1.3.1
#libupnp: $(LIBUPNP_SRC_PATH)/Makefile 
#	make -C $(LIBUPNP_SRC_PATH)
#	cp $(LIBUPNP_LIB_PATH)/upnp/.libs/libupnp.a .
#	cp $(LIBUPNP_LIB_PATH)/ixml/.libs/libixml.a .
#	cp $(LIBUPNP_LIB_PATH)/threadutil/.libs/libthreadutil.a .
#	cp $(LIBUPNP_LIB_PATH)/upnp/.libs/libupnp.so .
#	cp $(LIBUPNP_LIB_PATH)/ixml/.libs/libixml.so .
#	cp $(LIBUPNP_LIB_PATH)/threadutil/.libs/libthreadutil.so .

.c.o:
	$(CC) $(CFLAGS) -c $<

clean:
	rm -rf *.o *~ *.bak $(EXEC)

cleanall: clean
	make -C $(LIBUPNP_SRC_PATH) clean
	rm -f *.a
	rm -f libupnp-1.3.1/Makefile

romfs:
	$(ROMFSINST) wscd /bin/wscd
	$(ROMFSINST) xml/WFADeviceDesc.xml /etc_ro/xml/WFADeviceDesc.xml
	$(ROMFSINST) xml/WFAWLANConfigSCPD.xml /etc_ro/xml/WFAWLANConfigSCPD.xml

