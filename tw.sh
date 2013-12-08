time_start=$(date +%s.%N)

echo "Make the kernel"
make VARIANT_DEFCONFIG=jf_tmo_defconfig SELINUX_DEFCONFIG=jfselinux_defconfig SELINUX_LOG_DEFCONFIG=jfselinux_log_defconfig jf_defconfig

echo "Making"
	make -j5

time_end=$(date +%s.%N)
echo -e "${BLDYLW}Total time elapsed: ${TCTCLR}${TXTGRN}$(echo "($time_end - $time_start) / 60"|bc ) ${TXTYLW}minutes${TXTGRN} ($(echo "$time_end - $time_start"|bc ) ${TXTYLW}seconds) ${TXTCLR}"
