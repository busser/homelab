# OS Image

Use the resources in this directory to build an OS image for your Raspberry Pi.

## Usage

### Build an image

To build an OS image, run this command:

```bash
make build
```

You can specify a hostname for your Raspberry Pi:

```bash
make build PI_HOSTNAME=pi0
```

Once you are done building, you can delete the build environment:

```bash
make clean
```

### Flash an SD card

> Note that the commands below work on OS X. These most likely will not work on
> other platforms, although the general steps should be similar.

Connect your SD card to your computer and find its device ID:

```bash
diskutil list | awk '$0 ~ /(external, physical)/ { print $1 }'

DEVICE="/dev/disk2" # This may be different for you.
```

Unmount the device before flashing the image onto it:

```bash
diskutil unmountdisk "${DEVICE}"
```

Now, flash the image onto the SD card:

```bash
IMAGE=pi0.img # This may be different for you.

sudo dd if="${IMAGE}" of="${DEVICE}" bs=1m
```
