# Documentation
The man page for this API is located [here](./apaction.3). To view it on Linux systems, you can run `man -l apaction.3` in the terminal

# Build
Any programs that use this library must be compiled using a custom implementation of the riscv-gnu-toolchain, located [here](https://github.com/rerunlv/riscv-gnu-toolchain). This can be built using the following commands:

```bash
git clone git@github.com:rerunlv/riscv-gnu-toolchain.git
git switch ant
git submodule update --init --recursive
./configure --prefix=/opt/riscv
sudo make linux
```

The associated gcc binary will then be located in `/opt/riscv/bin/riscv64-unknown-linux-gnu-gcc`. For example, if you wanted to compile to script located in `example.c`, you would run the following `/opt/riscv/bin/riscv64-unknown-linux-gnu-gcc example.c ap.c ap.S`

