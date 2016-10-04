#!/bin/sh

mkdir "$HOME/libvpx"
tar -xjf libvpx-1.6.0.tar.bz2

cd libvpx-1.6.0/
./configure --disable-install-docs --disable-unit-tests --disable-vp8
make -j $NUM_CPU_JOBS
echo $? > ~/install-exit-status
mv vpxenc "$HOME/libvpx/"
cd ~
rm -rf libvpx-1.6.0/

echo "#!/bin/sh
cd libvpx/
./vpxenc --codec=vp9 --good --cpu-used=1 --target-bitrate=2000 --psnr -v -t \$NUM_CPU_CORES -o /dev/null ~/blue_sky_1080p25.y4m 2> \$LOG_FILE
echo \$? > ~/test-exit-status
sed -i -e 's/[\x01-\x1F\x7F]//g' -e 's/.*Pass /Pass /' -e 's/ fps).*/ fps)/' \$LOG_FILE" > vp9enc
chmod +x vp9enc
