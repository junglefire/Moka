#!/bin/bash

export ROOT_DIR=`pwd`
INSTALL_DIR="$ROOT_DIR/pkg"
PKG_DIR="pkg/packages"
RM_DIR=0

if [ ! -d $PKG_DIR ]; then
	mkdir -p $PKG_DIR
fi

if [ $# -ne 1 ]; then
	echo "[usage]build_deps.sh <package_name>"
	echo "::list of packages:"
	echo "  - libuv"
	echo "  - libuv-biubiu"
	echo "  - zlog"
	echo "  - spdlog"
	echo "  - bdb"
	echo "  - pcap"
	echo "  - pcapplusplus"
	echo "  - msgpack"
	echo "  - json"
	echo "  - cxxopts"
	echo "  - zmq"
	echo "  - sqlite3"
	echo "  - sdl2"
	echo "  - sfml"
	echo "  - roaring"
	exit -1
fi

echo "build 3rd library ..."

if [ $1 == 'libuv' ]; then
	# build libuv
	#
	echo ">>>>>--------> build libuv ..."
	UV_VERSION="1.42.0"
	if [ ! -f $PKG_DIR/libuv-v$UV_VERSION.tar.gz ]; then 
		wget https://dist.libuv.org/dist/v$UV_VERSION/libuv-v$UV_VERSION.tar.gz --output-document=$PKG_DIR/libuv-v$UV_VERSION.tar.gz
	fi
	
	cd $PKG_DIR/
	tar -zxvf libuv-v$UV_VERSION.tar.gz

	cd libuv-v$UV_VERSION/

	echo "make..."
	sh autogen.sh
	./configure --prefix=$INSTALL_DIR
	make
	
	echo "install..."
	make install

	echo "clean..."
	cd ../
	if [ $RM_DIR == 1 ]; then
		rm -rf libuv-v$UV_VERSION/
	fi

elif [ $1 == 'libuv-biubiu' ]; then
	# build libuv-biubiu
	#
	echo ">>>>>--------> build libuv-biubiu ..."
	UV_VERSION="1.42.0b"

	cd $PKG_DIR/
	
	git clone -b $UV_VERSION git@gitlab.alibaba-inc.com:alex.wz/libuv-biubiu.git libuv-v$UV_VERSION/

	cd libuv-v$UV_VERSION/

	echo "make..."
	sh autogen.sh
	./configure --prefix=$INSTALL_DIR
	make
	
	echo "install..."
	make install

	echo "clean..."
	cd ../
	if [ $RM_DIR == 1 ]; then
		rm -rf libuv-v$UV_VERSION/
	fi

elif [ $1 == 'zlog' ]; then
	# build zlog
	#
	echo ">>>>>--------> build zlog ..."
	ZLOG_VERSION="1.2.15"

	if [ ! -f $PKG_DIR/zlog_$ZLOG_VERSION.tar.gz ]; then
		wget https://github.com/junglefire/zlog/archive/$ZLOG_VERSION.tar.gz --output-document=$PKG_DIR/zlog_$ZLOG_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf zlog_$ZLOG_VERSION.tar.gz

	cd zlog-$ZLOG_VERSION/

	echo "make..."
	make

	echo "install..."
	make PREFIX=$INSTALL_DIR/ install
	rm $INSTALL_DIR/lib/libzlog*dylib
	
	echo "clean..."
	cd ..
	rm -rf zlog-$ZLOG_VERSION/

elif [ $1 == 'spdlog' ]; then
	# build spdlog
	#
	echo ">>>>>--------> build spdlog ..."
	SPDLOG_VERSION="1.8.5"

	if [ ! -f $PKG_DIR/spdlog_$SPDLOG_VERSION.tar.gz ]; then
		wget https://github.com/gabime/spdlog/archive/refs/tags/v$SPDLOG_VERSION.tar.gz --output-document=$PKG_DIR/spdlog_$SPDLOG_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf spdlog_$SPDLOG_VERSION.tar.gz

	cd spdlog-$SPDLOG_VERSION/

	echo "make..."
	mkdir build && cd build
	cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
	make -j

	echo "install..."
	make install
	
	echo "clean..."
	cd ../..
	rm -rf spdlog-$SPDLOG_VERSION/

elif [ $1 == 'bdb' ]; then
	# build berkeleydb
	#
	echo ">>>>>--------> build berkeleydb ..."
	DB_VERSION="18.1.40"

	if [ ! -f $PKG_DIR/db_$DB_VERSION.tar.gz ]; then
		wget https://github.com/junglefire/berkeleydb/archive/refs/tags/$DB_VERSION.tar.gz --output-document=$PKG_DIR/db_$DB_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf db_$DB_VERSION.tar.gz 

	cd berkeleydb-$DB_VERSION/build_unix

	echo "configure"
	../dist/configure --prefix=$INSTALL_DIR --with-repmgr-ssl=no --disable-replication --enable-stl=no  --enable-tcl=no --enable-localization=no --enable-test=no --enable-java=no --enable-gui=no --enable-mingw=no --enable-dump185=no --enable-compat185=no --disable-partition --disable-queue	

	echo "make"
	make 

	echo "install..."
	make install

	echo "rm doc/ and bin/"
	rm -rf $INSTALL_DIR/docs
	rm -rf $INSTALL_DIR/bin
	
	echo "clean..."
	cd ../..
	rm -rf berkeleydb-$DB_VERSION

elif [ $1 == 'pcap' ]; then
	# build libpcap
	#
	echo ">>>>>--------> build libpcap ..."
	PCAP_VERSION="1.10.1"

	if [ ! -f $PKG_DIR/libpcap-$PCAP_VERSION.tar.gz ]; then
		wget https://www.tcpdump.org/release/libpcap-$PCAP_VERSION.tar.gz --output-document=$PKG_DIR/libpcap-$PCAP_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf libpcap-$PCAP_VERSION.tar.gz

	cd libpcap-$PCAP_VERSION

	echo "configure"
	./configure --prefix=$INSTALL_DIR	

	echo "make"
	make 

	echo "install..."
	make install

	echo "rm doc/ and bin/"
	rm -rf $INSTALL_DIR/docs
	rm -rf $INSTALL_DIR/bin
	
	echo "clean..."
	cd ../..
	rm -rf libpcap-$PCAP_VERSION

elif [ $1 == 'json' ]; then
	# build json
	#
	echo ">>>>>--------> build nlohmann::json ..."
	JSON_VERSION="3.10.4"

	if [ ! -f $PKG_DIR/json-$JSON_VERSION.zip ]; then
		wget https://github.com/nlohmann/json/archive/refs/tags/v$JSON_VERSION.zip --output-document=$PKG_DIR/json-$JSON_VERSION.zip
	fi

	cd $PKG_DIR/
	unzip json-$JSON_VERSION.zip
	cd json-$JSON_VERSION/

	echo "make..."
	cmake ./ -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DBUILD_TESTING=OFF
	make

	echo "install..."
	make install
	
	echo "clean..."
	cd ..
	rm -rf msgpack-c-$MSGPACK_VERSION/

elif [ $1 == 'msgpack' ]; then
	# build msgpack
	#
	echo ">>>>>--------> build msgpack ..."
	MSGPACK_VERSION="4.0.0"

	if [ ! -f $PKG_DIR/msgpack-c-$MSGPACK_VERSION.tar.gz ]; then
		wget https://github.com/msgpack/msgpack-c/releases/download/c-4.0.0/msgpack-c-$MSGPACK_VERSION.tar.gz --output-document=$PKG_DIR/msgpack-c-$MSGPACK_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf msgpack-c-$MSGPACK_VERSION.tar.gz

	cd msgpack-c-$MSGPACK_VERSION/

	echo "make..."
	cmake ./ -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
	make

	echo "install..."
	make install
	
	echo "clean..."
	cd ..
	rm -rf msgpack-c-$MSGPACK_VERSION/

elif [ $1 == 'cxxopts' ]; then
	# build cxxopts
	#
	echo ">>>>>--------> build cxxopts ..."
	CXXOPTS_VERSION="3.0.0"

	if [ ! -f $PKG_DIR/cxxopts-$CXXOPTS_VERSION.tar.gz ]; then
		wget https://github.com/jarro2783/cxxopts/archive/refs/tags/v$CXXOPTS_VERSION.tar.gz --output-document=$PKG_DIR/cxxopts-$CXXOPTS_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf cxxopts-$CXXOPTS_VERSION.tar.gz

	cd cxxopts-$CXXOPTS_VERSION/

	echo "make..."
	cmake ./ -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
	make

	echo "install..."
	make install
	
	echo "clean..."
	cd ..
	rm -rf cxxopts-$CXXOPTS_VERSION/

elif [ $1 == 'zmq' ]; then
	# build zmq
	#
	echo ">>>>>--------> build libzmq ..."
	ZMQ_VERSION="4.3.4"

	if [ ! -f $PKG_DIR/libzmq-$ZMQ_VERSION.tar.gz ]; then
		wget https://github.com/zeromq/libzmq/archive/refs/tags/v$ZMQ_VERSION.tar.gz --output-document=$PKG_DIR/libzmq-$ZMQ_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf libzmq-$ZMQ_VERSION.tar.gz

	cd libzmq-$ZMQ_VERSION/

	echo "make..."
	mkdir -p build_unix
	cd build_unix
	cmake .. -D WITH_PERF_TOOL=OFF -D ZMQ_BUILD_TESTS=OFF -D ENABLE_CPACK=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR
	make

	echo "install..."
	make install
	
	echo "clean..."
	cd ..
	# rm -rf libzmq-$ZMQ_VERSION/

elif [ $1 == 'sqlite3' ]; then
	# build sqlite3
	#
	echo ">>>>>--------> build sqlite3 ..."
	SQLITE3_VERSION="3380000"

	if [ ! -f $PKG_DIR/sqlite-autoconf-$SQLITE3_VERSION.tar.gz ]; then
		wget https://www.sqlite.org/2022/sqlite-autoconf-$SQLITE3_VERSION.tar.gz --output-document=$PKG_DIR/sqlite-autoconf-$SQLITE3_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf sqlite-autoconf-$SQLITE3_VERSION.tar.gz

	cd sqlite-autoconf-$SQLITE3_VERSION/

	echo "configure"
	./configure --prefix=$INSTALL_DIR	

	echo "make"
	make 

	echo "install..."
	make install

	cd ..
	rm -rf sqlite-autoconf-$SQLITE3_VERSION/

elif [ $1 == 'pcapplusplus' ]; then
	# build pcapplusplus
	#
	echo ">>>>>--------> build pcapplusplus ..."
	P3_VERSION="22.05"

	if [ ! -f $PKG_DIR/pcapplusplus-$P3_VERSION.tar.gz ]; then
		wget https://github.com/seladb/PcapPlusPlus/archive/refs/tags/v$P3_VERSION.tar.gz --output-document=$PKG_DIR/pcapplusplus-$P3_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf pcapplusplus-$P3_VERSION.tar.gz 

	cd PcapPlusPlus-$P3_VERSION/

	echo "configure"
	./configure-mac_os_x.sh --install-dir $INSTALL_DIR --use-immediate-mode --set-direction-enabled

	echo "make"
	make 

	echo "install..."
	make install

	cd ..
	rm -rf PcapPlusPlus-$P3_VERSION/

elif [ $1 == 'sdl2' ]; then
	# build sdl2
	#
	echo ">>>>>--------> build libsdl2 ..."
	SDL2_VERSION="2.24.2"

	if [ ! -f $PKG_DIR/sdl2-$SDL2_VERSION.zip ]; then
		wget https://github.com/libsdl-org/SDL/archive/refs/tags/release-$SDL2_VERSION.zip --output-document=$PKG_DIR/sdl2-$SDL2_VERSION.zip
	fi

	cd $PKG_DIR/
	unzip sdl2-$SDL2_VERSION.zip

	echo "make build path..."
	mkdir build

	echo "cmake"
	cd build
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -S ../SDL-release-2.24.2 -B .

	echo "make && make install"
	make install

	echo "clear..."
	cd ..
	rm -rf build
	rm -rf SDL-release-$SDL2_VERSION

elif [ $1 == 'sfml' ]; then
	# build sfml
	#
	echo ">>>>>--------> build SFML ..."
	SFML_VERSION="2.5.1"

	if [ ! -f $PKG_DIR/sfml-$SFML_VERSION.tar.gz ]; then
		wget https://github.com/SFML/SFML/archive/refs/tags/$SFML_VERSION.tar.gz --output-document=$PKG_DIR/sfml-$SFML_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf sfml-$SFML_VERSION.tar.gz

	echo "cmake"
	cd SFML-$SFML_VERSION/
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR .

	echo "make && make install"
	make
	sudo make install

elif [ $1 == 'roaring' ]; then
	# build RoaringBitmap
	#
	echo ">>>>>--------> build RoaringBitmap ..."
	RB_VERSION="1.1.5"

	if [ ! -f $PKG_DIR/rb-$RB_VERSION.tar.gz ]; then
		wget https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v$RB_VERSION.tar.gz --output-document=$PKG_DIR/rb-$RB_VERSION.tar.gz
	fi

	cd $PKG_DIR/
	tar -zxvf rb-$RB_VERSION.tar.gz
	cd CRoaring-$RB_VERSION/
	cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -B build
	cd build/

	echo "make && make install"
	make
	make install

	cd ../..
	rm -rf CRoaring-$RB_VERSION

	echo "Done!"

fi
