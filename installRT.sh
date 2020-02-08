cp /data/nv-tensorrt-repo-ubuntu1804-cuda10.1-trt6.0.1.5-ga-20190913_1-1_amd64.deb /
dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.1-trt6.0.1.5-ga-20190913_1-1_amd64.deb
apt-key add /var/nv-tensorrt-repo-cuda10.1-trt6.0.1.5-ga-20190913/7fa2af80.pub
apt-get update
apt-get install -y --no-install-recommends tensorrt
apt-get install -y --no-install-recommends python3-libnvinfer-dev
apt-get install -y --no-install-recommends uff-converter-tf
apt-get clean
apt-get autoremove 
rm nv-tensorrt-repo-ubuntu1804-cuda10.1-trt6.0.1.5-ga-20190913_1-1_amd64.deb
rm -- "$0"
