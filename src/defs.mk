CC?=cc
CXX?=c++
CFLAGS?=-Wall -Wextra -O3
CXXFLAGS?=$(CFLAGS)
CXXFLAGS+=-std=c++11 -pthread 
INSTALL=install
SBIN=/usr/sbin
SNOWCONFDIR=/etc/snow
SNOWVAR=/var/lib/snow
LIB=/lib/`arch`-linux-gnu
USRLIB=/usr/lib/`arch`-linux-gnu

SNOW_LDFLAGS=-lssl -lcrypto
ifdef NO_NATPMP
CXXFLAGS+=-DNO_NATPMP
else
SNOW_LDFLAGS+=-lnatpmp
endif
ifdef NO_UPNP
CXXFLAGS+=-DNO_UPNP
else
SNOW_LDFLAGS+=-lminiupnpc
endif

NSS_SNOW_SO?=libnss_snow.so
NSS_SNOW_BINARY?=$(NSS_SNOW_SO).2
NSS_SNOW_TEST?=snow_nss_test
NSS_SNOW_SRC?=nss_snow.c

ifeq ($(OS),Windows_NT)
    CXXFLAGS+=-DWINDOWS -DWINSOCK -DNOCRYPT -D_WINNT_WIN32=0x500
    SNOW_OBJS+=applink.o
    SNOW_LDFLAGS+=-lws2_32 -liphlpapi -L/c/msys/1.0/home/user/openssl-1.0.1e/dist/lib
    SNOW_BINARY=snowd.exe
else
    SNOW_LDFLAGS+=-lpthread
    SNOW_BINARY=snowd
endif

