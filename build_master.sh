#!/bin/sh
export PLATFORM="TW"
export MREV="JB4.3"
export CURDATE=`date "+%m.%d.%Y"`
export MUXEDNAMELONG="_BioShock_4.0-$MREV-$PLATFORM-$CARRIER-$CURDATE"
export MUXEDNAMESHRT="_BioShock_4.0-$MREV-$PLATFORM-$CARRIER*"
export KTVER="_BioShock_4.0-"
export KERNELDIR=`readlink -f .`
export PARENT_DIR=`readlink -f ..`
export INITRAMFS_DEST=$KERNELDIR/kernel/usr/initramfs
export INITRAMFS_SOURCE=`readlink -f ..`/Ramdisks/$PLATFORM"_"$CARRIER"4.3"
export CONFIG_$PLATFORM_BUILD=y
export PACKAGEDIR=/home/jamison/android/kernel/out/Packages/$PLATFORM
#Enable FIPS mode
export USE_SEC_FIPS_MODE=true
export ARCH=arm
export CROSS_COMPILE=$PARENT_DIR/linaro4.7/bin/arm-eabi-

time_start=$(date +%s.%N)

echo "Remove old Package Files"
rm -rf $PACKAGEDIR/*

echo "Setup Package Directory"
mkdir -p $PACKAGEDIR/system/app
mkdir -p $PACKAGEDIR/system/lib/modules
mkdir -p $PACKAGEDIR/system/etc/init.d

echo "Create initramfs dir"
mkdir -p $INITRAMFS_DEST

echo "Remove old initramfs dir"
rm -rf $INITRAMFS_DEST/*

echo "Copy new initramfs dir"
cp -R $INITRAMFS_SOURCE/* $INITRAMFS_DEST

echo "chmod initramfs dir"
chmod -R g-w $INITRAMFS_DEST/*
rm $(find $INITRAMFS_DEST -name EMPTY_DIRECTORY -print)
rm -rf $(find $INITRAMFS_DEST -name .git -print)

echo "Remove old zImage"
rm $PACKAGEDIR/zImage
rm arch/arm/boot/zImage

echo "Make the kernel"
make VARIANT_DEFCONFIG=jf_$CARRIER"_defconfig" SELINUX_DEFCONFIG=jfselinux_defconfig SELINUX_LOG_DEFCONFIG=jfselinux_log_defconfig KT_jf_defconfig

echo "Modding .config file - "$KTVER
sed -i 's,CONFIG_LOCALVERSION="_BioShock_4.0-",CONFIG_LOCALVERSION="'$KTVER'",' .config

	make -j5


