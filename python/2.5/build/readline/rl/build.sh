#! /bin/bash

# Uncomment these for a 4-way universal binary built on the 10.5 Leopard SDK
export CFLAGS='-isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc -arch x86_64 -arch ppc64'
export LDFLAGS='-isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch ppc -arch x86_64 -arch ppc64'

tar xzvf readline-5.2.tar.gz
mv readline-5.2 readline-lib
cd readline-lib
patch -p0 < ../readline52-001
patch -p0 < ../readline52-002
patch -p0 < ../readline52-003
patch -p0 < ../readline52-004
patch -p0 < ../readline52-005
patch -p0 < ../readline52-006
patch -p0 < ../readline52-007
patch -p0 < ../readline52-008
patch -p0 < ../readline52-009
patch -p0 < ../readline52-010
patch -p0 < ../readline52-011
patch -p0 < ../readline52-012
./configure CPPFLAGS='-DNEED_EXTERN_PC'
make
