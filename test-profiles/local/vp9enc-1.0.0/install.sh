#!/bin/sh

mkdir "$HOME/libvpx"
tar -xjf libvpx-1.4.0.tar.bz2

cd libvpx-1.4.0/
./configure --disable-install-docs
make -j $NUM_CPU_JOBS
echo $? > ~/install-exit-status
mv vpxenc "$HOME/libvpx/"
cd ~
rm -rf libvpx-1.4.0/

echo "#!/bin/sh
cd libvpx/
./vpxenc --codec=vp9 --good --psnr -v -t \$NUM_CPU_CORES -o /dev/null ~/blue_sky_1080p25.y4m 2> \$LOG_FILE 
echo \$? > ~/test-exit-status" > vp9enc
chmod +x vp9enc
