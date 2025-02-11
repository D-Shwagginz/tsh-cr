sudo cp ./rsrc/linux/sunvox.so /usr/lib/libsunvox.so
sudo ln -s /usr/lib/libsunvox.so /lib/sunvox.so
sudo cp ./rsrc/linux/raylib.so /usr/local/lib/libraylib.so.5.0.0
sudo cp /usr/local/lib/libraylib.so.5.0.0 /usr/lib/libraylib.so.500
sudo ln -s /usr/lib/libraylib.so.500 /lib/raylib.so