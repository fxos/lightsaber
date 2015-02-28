# Lightsaber
Lightsaber build documentation and tool to flash Gaia and custom apps.

# Preparing your Aries device
We recommend that you run this on an Aries device. It will, however, run correctly on a Flame or theoretically any other device.

## Getting started
If you haven't already, you should follow the general (B2G build instructions)[https://developer.mozilla.org/en-US/Firefox_OS/Building_and_installing_Firefox_OS] up until they ask you to run ```./build.sh```.

## Important note
All paths here and beyond are relative to your user folder, ```~/```. If you are on OS X, you should be using a case sensitive image to store all of these files. For example, ```/Volumes/firefoxos```. For instructions on how to create this image, see [Mac file system case sensitivity](https://developer.mozilla.org/en-US/Firefox_OS/Firefox_OS_build_prerequisites#Be_aware_of_Mac_file_system_case_sensitivity).

Do not put the ```lightsaber``` repo in your ```B2G``` repo.

## Installing Dependencies
### Linux only
If you're on Linux, you must install the ```nodejs-legacy``` package, which symlinks ```node``` to ```nodejs```. Via apt-get:
```
sudo apt-get install nodejs-legacy
```
### Linux and OS X
Install the node global dependencies:
```
sudo npm install -g bower && sudo npm install -g gulp && sudo npm install -g apm
```

## Clone Cypress
Cypress is the Gecko branch used for Lightsaber.
```
hg clone ssh://hg.mozilla.org/projects/cypress ~/cypress
```

## Setup B2G repository
You should already have a B2G repository cloned if you followed the general B2G build instructions. If not, clone the [B2G](https://github.com/mozilla-b2g/B2G) repository locally:
```
git clone git@github.com:mozilla-b2g/B2G.git ~/B2G
cd ~/B2G
```

## Configure B2G repository
B2G must be configured to point to Cypress.
```
echo 'export GECKO_PATH=~/cypress' > .userconfig
```

## Configure for Aries device
B2G must be configured for the Aries device
```
./config.sh aries
```

## Acquire binaries and build
You must now acquire the device binaries using the ```./build.sh``` tool:
```
./build.sh
```

## Flash the full image
If the build completes without problems, you can flash the full image as follows:
```
./flash.sh
```

## Enable USB debugging
Go into the Settings app, then Developer > Debugging via USB > set this to "ADB only" or "ADB and DevTools".

## Installing Lightsaber Gaia branch and apps
```
git clone https://github.com/fxos/lightsaber
cd lightsaber
make install
make sync
GAIA_DEV_PIXELS_PER_PX=2.25 make reset-gaia
```

## Set the javascript.options.discardSystemSource pref
**You must perform this step, or the custom apps will not work.**

We're not sure why this is needed yet, but probably because RequireJS uses ```function.toSource()``` calls.
```
cd B2G
./edit_prefs.sh
```
Navigate to the bottom, and add this line:
```
user_pref("javascript.options.discardSystemSource", false);
```
Save the file using your editor, and close it, and your device should reboot.

## That's all
You should now have a device, running Lightsaber, to play around with.

# Using this tool
These instructions are separate from installing Lightsaber on an Aries device. Instructions from here onward are just for using this tool. This tool is a wrapper for *repo* (https://code.google.com/p/git-repo/). It packages Lightsaber apps into a Gaia Lightsaber branch.

## Quick setup
Install, build, and flash Lightsaber (CAUTION: this will destroy your profile!)
If you're on Linux, first run ```sudo apt-get install nodejs-legacy```
```
sudo npm install -g bower && sudo npm install -g gulp && sudo npm install -g apm
git clone https://github.com/fxos/lightsaber
cd lightsaber
make install
make sync
DEVICE_DEBUG=1 NOFTU=1 GAIA_DEV_PIXELS_PER_PX=2.25 make reset-gaia
```

## Quick update
Only run this if you already have Lightsaber installed, and you want to update your Lightsaber Gaia branch and apps
```
make sync
make install-gaia
```

## Install
```
git clone https://github.com/fxos/lightsaber
cd lightsaber
make install
```

## Sync repos
You will need to do this everytime a sub-repo is updated.
```
make sync
```

## Delete all downloaded content, built files, etc.
```
make really-clean
```

## Building
Similar to Gaia. Note that all ```make``` commands accept env vars such as ```DEVICE_DEBUG```, just like Gaia does.
Choose any of the following:

### make
Build a Gaia profile.
```
make
```

### make install-gaia
Build a Gaia profile and flash it onto your device.
```
make install-gaia
```

### make reset-gaia
Destroy your Gaia profile, build a new one, and flash it onto your device.
```
make reset-gaia
```

### make clean
Deletes all Lightsaber app build files and cleans the Gaia repo.
```
make clean
```
