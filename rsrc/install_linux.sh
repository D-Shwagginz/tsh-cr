sudo cp ./rsrc/linux/sunvox.so /usr/lib/libsunvox.so
sudo ln -s /usr/lib/libsunvox.so /lib/sunvox.so

gcc -c -fPIC lib/raylib-cr/rsrc/miniaudiohelpers/miniaudiohelpers.c -o lib/raylib-cr/rsrc/miniaudiohelpers/miniaudiohelpers.o
sudo gcc lib/raylib-cr/rsrc/miniaudiohelpers/miniaudiohelpers.o -shared -o /usr/local/lib/libminiaudiohelpers.so -lm
sudo cp /usr/local/lib/libminiaudiohelpers.so /usr/lib/libminiaudiohelpers.so
sudo ln -s /usr/lib/libminiaudiohelpers.so /lib/miniaudiohelpers.so
git clone --depth 1 --branch 5.0 https://github.com/raysan5/raylib
mkdir raylib/build
sudo apt-get install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev
cmake raylib -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -B raylib/build 
cmake --build raylib/build
sudo make install -C raylib/build
sudo cp /usr/local/lib/libraylib.so.4.5.0 /usr/lib/libraylib.so.450
sudo ln -s /usr/lib/libraylib.so.450 /lib/raylib.so