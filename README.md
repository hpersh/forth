# Implementation of the FORTH programming language

FORTH is a great language for hardware bring-up, and boot firmware.  It is compact, undemanding of the platform (all it needs is some memory and a serial port), and powerful.

## Goals
- Support multiple CPUs
- Support multiple platforms

## Implementation
- Classic, "threaded code", IP is a pointer to a pointer to machine code
- Most words defined in the FIG FORTH standard
- Omitted
  - Double-size operations
  - Vocabularies

## Components
- src/i386: Source for i386 CPU (32-bit)
- src/i386-linux: Source for i386 CPU (32-bit) on Linux platform (i.e. I/O)
- src/linux: Source for Linux platform (i.e. I/O)
- src/shared: Source code common to all CPUs and platforms
- src/x86_64: Source for x86_64 CPU (64-bit)
- src/x86_64-linux: Source for x86_64 CPU (64-bit) on Linux platform (i.e. I/O)
- bld/i386-linux: Build files for i386 on Linux platform
- bld/linux: Build files for all CPUs on Linux platforms 
- bld/x86_64-linux: Build files for x86_64 CPU on Linux platform
- test/x86_64-linux: Test files for x86_64 CPU on Linux platform

## How to build
1. cd to appropriate build directory, based on CPU and platform, eg. bld/x86_64-linux
2. make all

