![CI](https://github.com/avojak/libcatalyst/actions/workflows/ci.yml/badge.svg)
![Lint](https://github.com/avojak/libcatalyst/actions/workflows/lint.yml/badge.svg)
![GitHub](https://img.shields.io/github/license/avojak/libcatalyst.svg?color=blue)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/avojak/libcatalyst?sort=semver)
[![Documentation](https://img.shields.io/badge/documentation-valadoc-a56de2)](https://avojak.com/libcatalyst/catalyst-1/)

# Catalyst

Catalyst is a companion library for GLib containing a collection of convenience functions and classes.

Each function and class originated from scenarios I've come across and decided would be beneficial in a library like this.

API documentation is available at: https://avojak.com/libcatalyst/catalyst-1/

## Features

- Asynchronous and monitored downloading of files ([Catalyst.HttpUtils](https://avojak.com/libcatalyst/catalyst-1/Catalyst.HttpUtils.html))
- Basic arithmetic of arbitrary-precision integers ([Catalyst.BigInteger](https://avojak.com/libcatalyst/catalyst-1/Catalyst.BigInteger.html))
- Container class for objects which may or may not contain a null value ([Catalyst.Optional](https://avojak.com/libcatalyst/catalyst-1/Catalyst.Optional.html))
- Enumarate all values on an enum ([Catalyst.EnumUtils](https://avojak.com/libcatalyst/catalyst-1/Catalyst.EnumUtils.html))
- Compute checksums of files ([Catalyst.DigestUtils](https://avojak.com/libcatalyst/catalyst-1/Catalyst.DigestUtils.html))
- Recursively copy, delete, and list files ([Catalyst.FileUtils](https://avojak.com/libcatalyst/catalyst-1/Catalyst.FileUtils.html))

And lots more!

## Example Usage

If using Meson, simply add the dependency after installation:

```meson
dependency('catalyst-1', version: '>= 1.0.0')
```

## Building, Testing, and Installation

Run `meson build` to configure the build environment:

```bash
meson build --prefix=/usr
```

This will create a `build` directory.

To build and install Catalyst, use `ninja`:

```bash
ninja -C build install
```

To run tests:

```bash
ninja -C build test
```

There's also a Makefile if you're lazy like me and don't want to type those commands all the time.

## Demo

Some features are demonstrated through a simple demo application. To run the demo after installation:

```bash
catalyst-1-demo
```

## Documentation

The additional requirements for building the documentation are:

- valadoc

To generate the valadoc documentation, pass the additional `-Ddocumentation=true` flag to Meson, and then run `ninja` as before.