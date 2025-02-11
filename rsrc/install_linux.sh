sudo cp ./rsrc/linux/sunvox.so /usr/lib/libsunvox.so
sudo ln -s /usr/lib/libsunvox.so /lib/sunvox.so
sudo cp ./rsrc/linux/raylib.so /usr/local/lib/libraylib.so.4.5.0
sudo cp /usr/local/lib/libraylib.so.4.5.0 /usr/lib/libraylib.so.450
sudo ln -s /usr/lib/libraylib.so.450 /lib/raylib.so