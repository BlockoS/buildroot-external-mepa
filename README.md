# Microchip Ethernet PHY APIs (MEPA) - Buildroot External Tree (BR2_EXTERNAL)

## Introduction

This repository provides a Buildroot external for Microchip Ethernet PHY APIs C libraries.

## Prerequisites

 * A linux host machine.
 * Buildroot with external package support.

## Quickstart

It is assumed that all the required softwares and librairies are installed on the linux host.

1. Get [Buildroot](https://www.buildroot.org) sources
   ```bash
   git clone git://git.buildroot.net/buildroot
   ```

1. Clone this repository
   ```bash
   git clone git@github.com:blockos/buildroot-external-mepa.git
   ```

1. Setup environment
   ```bash
   cd <path to>/buildroot
   export BR2_EXTERNAL="${PWD}/../buildroot-external-mepa"
   ```

1. Configuration & build </br>
   The MEPA package will be under __External options__.
   ```bash
   make menuconfig
   make -j"$(nproc)"
   ```
