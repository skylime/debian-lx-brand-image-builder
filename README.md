# Debian lx-brand Image Builder

[![Build Status](https://travis-ci.org/joyent/debian-lx-brand-image-builder.svg?branch=master)](https://travis-ci.org/joyent/debian-lx-brand-image-builder) (shecllcheck)

This is a collection of scripts used for creating an lx-brand Debian image.

## Requirements

In order to use these scripts you'll need:

- Debian running in a VM or bare metal (required for the `install` script)
- debootstrap: `apt-get install -y debootstrap`
- git: `apt-get install -y git`
- A SmartOS (or SDC headnode) install (required for the `create-lx-image` script)

## Manual usage

1. Run `./install -d <chroot> -m <mirror> -i <image name> -p <proper name> -u <image docs` uunder Debian to install Debian 7 in a given directory. This will create a tarball of the installation in your working directory (named `<image name>-<YYMMDD>.tar.gz`). See `./install -h` for detailed usage.
2. Copy the tarball to a SmartOS machine or SDC headnode and run `./create-lx-image -t /full/path/to/<image name>-<YYMMDD>.tar.gz` (substituting the name of your tar file). This will create the image file and manifest.

## Vagrant usage

### Additinonal requirements

- [Vagrant](https://www.vagrantup.com/)
- VMware (Fusion) or Virtualbox
- GNU make

### Usage

With the usage of vagrant you do not need access to an Debian or SmartOS machine
for now. Vagrant create the required machines and upload the result to an Image
API server.

The following environment variables need to be configured:

- `IMAGE_NAME`: The image name for example `debian-9`
- `KERNEL`: The kernel version which need to be used, in the example below `4.9.0`
- `OS_VERSION`: Which debian OS version is used (by OS name)
- `PUBLISH_URL`: The Image API URL

```
$ make IMAGE_NAME="debian-9" KERNEL="4.9.0" OS_VERSION="stretch" PUBLISH_URL="https://user:pass@imgapi.example.com"
```
