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
