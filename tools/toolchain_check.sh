#!/bin/bash

# Check for NASM
if ! command -v nasm &> /dev/null; then
    echo "Error: NASM is either not installed or not in your path."
    exit 1
fi

# Check for i686-elf toolchain
if ! command -v i686-elf-gcc &> /dev/null; then
    echo "Error: i686-elf-gcc is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-g++ &> /dev/null; then
    echo "Error: i686-elf-g++ is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-ld &> /dev/null; then
    echo "Error: i686-elf-ld is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-objcopy &> /dev/null; then
    echo "Error: i686-elf-objcopy is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-as &> /dev/null; then
    echo "Error: i686-elf-as is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-ar &> /dev/null; then
    echo "Error: i686-elf-ar is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-ranlib &> /dev/null; then
    echo "Error: i686-elf-ranlib is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-objdump &> /dev/null; then
    echo "Error: i686-elf-objdump is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-nm &> /dev/null; then
    echo "Error: i686-elf-nm is not installed or not in your path."
    exit 1
fi

if ! command -v i686-elf-size &> /dev/null; then
    echo "Error: i686-elf-size is not installed or not in your path."
    exit 1
fi

# Now check for utily commands such as Make etc...
if ! command -v make &> /dev/null; then
    echo "Error: Make is not installed or not in your path."
    exit 1
fi
