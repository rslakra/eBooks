# Java Skelmir VM Core dump Instructions

---

Instructions on how to retrieve the core dump after the siege process has crashed:

To be able to write files, in this case a core dump, from an STB to a USB flash drive, 
the following components must be available in the boot image:

- Telnet needs to be running and accepting connections.
- USB needs to be enabled, allowing the device discovery subsystem to detect it when inserted and create a device node (```/dev/sdxx```).
- A file system suitable for USB flash drives needs to be present, ext2 or jfs is normally included so this is probably not a problem.
- Must be run on STB with a hard drive (i.e. 1960).
- Modify the ```startclient``` script with the following:
```shell
export SIEGE_NOSIGNALS=1
cd /pvr/storage
```

The above two lines MUST be put directly before executing the siege-process!

For reference (already in the start params to siege I assume):
```shell
# -verbose: gc = VM reports statics to console after each GC cycle
# -verbose: outofmem = Extra debug of out of memory issues
```

To copy a core file to the USB flash drive when a crash has occurred:

- Telnet to the STB
- Insert a formatted USB flash drive (formatted using a supported file system like ```ext2``` or ```jfs```)
- Check for two new device nodes in ```/dev``` probably called ```/dev/sdb``` and ```/dev/sdb1```
- If it doesn’t exist, make a directory called ```/mnt```. Also make a directory called ```/mnt/usb```
```shell
mkdir /mnt
mkdir /mnt/usb
```

- Mount the USB drive
```shell
mount –t ext2 /dev/sdb1 /mnt/usb
(or –t jfs for jfs)
```

- Now copy the core file to the USB drive (Siege should be executing ```/pvr/storage/``` as current working directory, so the core file is probably found there)
```shell
chmod 777 /pvr/storage/core*
cp /pvr/storage/core* /mnt/usb/
```

If you find that this command copies multiple files there has been more than one process crash during the test.
In that case it is especially important to know which core-file that belongs to the ```siege``` process.

This should be easy to find out in the ```logclient``` log, where the process ID for the ```run_myrio.sh``` process is the one we are looking for.

**Example**: ```run_myrio.sh(528```)  ```core.528``` in ```/pvr/storage```

- Also copy the executable (in this case ```siege```)
```shell
cp /usr/bin/siege /mnt/usb/
```

- Unmount the USB drive (important as we need to sync the written data before removing the USB stick!)
```shell
umount /mnt/usb
```

Now you can remove the USB drive from the STB


# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
