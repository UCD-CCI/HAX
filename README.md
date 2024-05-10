# H@x #

## About ##

H@x will analyse and visually represent structured data allowing the user to interact with the data. 

The tool will interpret translation scripts (kaitai script files) and has a builtin editor for the creation of new kaitai scripts.

#### Supported Platforms ####
Tested on Windows, Linux and MacOS.

See [CHANGELOG](CHANGELOG.md) for some notable changes.

## Building from source ##

H@x uses the CMake build toolset. Install CMake before proceeding (at least version 3.20).

#### Dependencies ####

To successfully build H@x from source, below libraries are required:

- Qt5 >= 5.12
- yaml-cpp >= 0.6
- libtomcrypt >= 1.18
- zlib >= 1.2
- libewf >= 20140608 (optional for EWF (.E01) support)

For per-platform dependencies and instructions see sections [Windows](#windows), [MacOS](#macos) and [Linux](#linux) below.

##### Building #####

The usual procedure is to navigate into the source directory, create a build folder (in the same location as the CMakeLists.txt file) and run CMake:

```
mkdir build
cd build
cmake [-G generator] -DCMAKE_BUILD_TYPE=Release ..
```

Where the ```..``` points to the source directory (one level up) and `generator` is the preferred build system generator.  
Run ```cmake --help``` for a list of available generators.

To start the compilation:

```
cmake --build .
```

Alternatively, for the compilation step, the build system compiler tool that was set with the ```-G generator``` option can be used. For example, if ```-G Makefile``` was selected as a generator ```make``` could be called to perform the compilation.

For an interactive configuration via a gui, the ```cmake-gui``` tool can be used.

##### Installing and/or Packaging #####

Installation of H@x can be done with:

```
cmake --install .
```

Or alternatively, to pack H@x to a setup or an archive package, cmake's ```cpack``` command can be used with an appropriate package generator.

```
cpack -G generator
```

Run ```cpack --help``` for a list of available package generators.

For custom cmake configuration see CMakeLists.txt.

#### Windows ####

##### Building with NMake #####

One way to build H@x from the command line, is using _NMake_ from the Microsoft C++ (MSVC) compiler toolset, which is available as a standalone package, avoiding installing the complete Visual Studio IDE (usually named as _Build Tools for Visual Studio_).

Install and/or build the required dependencies first.

The build procedure, using the MSVC 2019 build tools for example, would then be:

- Open a Qt command shell to have qt paths setup correctly
- Run: ``` C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat ``` to have the toolchain paths setup correctly.
- Setup the location of each dependency's .h, .lib and .dll files for cmake to correctly link against them. 

Prepare the build folder with:

```
mkdir build
cd build
```

H@x's cmake config scripts try to auto locate the appropriate headers, libs and dlls for the required dependencies. If they are located in ```C:\Libs\``` (usually in subfolders ```include```, ```lib``` and ```bin```) then the ```CMAKE_PREFIX_PATH``` variable can be used to search in ```C:\Libs\```, ie:

```
cmake -G"NMake Makefiles JOM" -DCMAKE_PREFIX_PATH="C:\Libs\" -DCMAKE_BUILD_TYPE=Release ..
```

Alternatively, each one of the dependencies' headers and libraries can be set with the exposed variables:

- `YAML-CPP-INCLUDE_DIR`, `YAML-CPP-LIBRARY_RELEASE`, `YAML-CPP-DLL_RELEASE`
- `ZLIB-INCLUDE_DIR`, `ZLIB-LIBRARY_RELEASE`, `ZLIB-DLL_RELEASE`
- `TOMCRYPT-INCLUDE_DIR`, `TOMCRYPT-LIBRARY_RELEASE`, `TOMCRYPT-DLL_RELEASE`
- `EWF-INCLUDE_DIR`, `EWF-LIBRARY_RELEASE`, `EWF-DLL_RELEASE`

Note: The locations of the dlls are not required for the compilation step but they will be needed on the install step.

To perform the actual compilation:

```
cmake --build .
```

or 

```
nmake
```

The _Hax.exe_ executable can be found in the build folder.

##### Installing #####

Installation of H@x can be done with:

```
cmake --install .
```

This will install _Hax.exe_ along with required runtime libraries at the directory pointed to by ```<install prefix>```. Usually, msvc sets the ```<install prefix>``` to ```C:\Program Files (x86)\Hax``` or ```C:\Program Files\Hax```. To change that, the ```CMAKE_INSTALL_PREFIX``` variable can be used during the configuration phase. For example,

```
cmake -G... -D... -DCMAKE_INSTALL_PREFIX="/relative-or-absolute/install/dir/directory/" ..
```

##### Packaging #####

To pack H@x to a setup or an archive package, cmake's ```cpack``` command can be used with an appropriate generator.

```
cpack -G NSIS
```

This will generate an installer (a setup package) using <a href="https://nsis-dev.github.io/" target="_blank">Nullsoft Scriptable Install System</a>. Of course the _Nullsoft Scriptable Install System_ has to be installed in the system before hand. Currently, apart from the archive generators, only NSIS has been configured as a setup package generator.

#### MacOS ####

##### Building #####

The easier method is to use brew. Required dependencies can be installed with:

```
brew install qt@5 yaml-cpp libtomcrypt zlib libewf
```  
then:

```
mkdir build
cd build
cmake ..
```
and compilation:

```
cmake --build .
```

or

```
make
```

The _Hax.app_ bundle can be found in the build folder.

##### Installing #####

Installation of H@x can be done with:

```
cmake --install .
```

This will produce a self-contained relocatable bundle, including all required runtime libraries. The bundle is installed at the directory pointed to by ```<install prefix>```. By default, the ```<install prefix>``` is set to the ```<build directory>/bin```. To change that, the ```CMAKE_INSTALL_PREFIX``` variable can be used during the configuration phase. For example,

```
cmake -DCMAKE_INSTALL_PREFIX=/relative-or-absolute/install/dir/ ..
```

##### Packaging #####

To pack the bundle into an installable or an archive package, cmake's ```cpack``` command can be used with an appropriate generator.

```
cpack -G DragNDrop
```

This will generate a drag-n-drop dmg with the bundle. Currently, apart from the archive generators, only DragNDrop has been configured as a setup package generator.

#### Linux ####

Required dependencies can be installed with the package manager.

For example in Ubuntu:

```
sudo apt install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libyaml-cpp-dev zlib1g-dev libtomcrypt-dev libewf-dev
```

Or, in AlmaLinux:

```
sudo yum install qt5-qtbase-devel yaml-cpp-devel libtomcrypt-devel libewf-devel zlib-devel
```


then:

```
mkdir build
cd build
cmake ..
make
```

and compilation:

```
cmake --build .
```

or

```
make
```

The _hax_ binary can be found in the build folder.

##### Installing #####

Installation of H@x can be done with:

```
cmake --install .
```

This will install the binary at ```<install prefix>/bin``` and the resources (desktop entry, hax icons, copyright e.t.c.) under ```<install_prefix>/share/...```.  
By default, ```<install prefix>``` is set to ```/usr/local```. To change that, the ```CMAKE_INSTALL_PREFIX``` variable can be used during the configuration phase. For example,

```
cmake -DCMAKE_INSTALL_PREFIX=/relative-or-absolute/install/dir/ ..
```

##### Packaging #####

To pack the bundle into an installable or an archive package, cmake's ```cpack``` command can be used with an appropriate generator.

```
cpack -G DEB
```

This will generate a debian package in a debian-based host. In an rpm based host, the generator ```cpack -G RPM``` can be used, to generate an rpm package.

