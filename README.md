# Lightsaber
Lightsaber build system for Gaia and custom apps. This tool is a wrapper for *repo*
(https://code.google.com/p/git-repo/). It packages Lightsaber apps into a Gaia Lightsaber branch.

# Quick setup
```
git clone https://github.com/fxos/lightsaber
cd lightsaber
make install
make sync
DEVICE_DEBUG=1 NOFTU=1 make reset-gaia
```

# Install
```
git clone https://github.com/fxos/lightsaber
cd lightsaber
make install
```

# Sync repos
You will need to do this everytime a sub-repo is updated.
```
make sync
```

# Delete all downloaded content, built files, etc.
```
make really-clean
```

# Building
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
