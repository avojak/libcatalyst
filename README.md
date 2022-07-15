![CI](https://github.com/avojak/libcatalyst/actions/workflows/ci.yml/badge.svg)
![Lint](https://github.com/avojak/libcatalyst/actions/workflows/lint.yml/badge.svg)
![GitHub](https://img.shields.io/github/license/avojak/libcatalyst.svg?color=blue)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/avojak/libcatalyst?sort=semver)

# Catalyst

Catalyst is a companion library for GLib containing a collection of convenience functions and classes.

## Features

- TODO

## Example Usage

If using Meson, simply add the dependency:

```meson
dependency('catalyst-1', version: '>= 1.0.0')
```

TODO

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