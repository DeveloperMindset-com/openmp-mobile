# OpenMP Mobile

This library provides means to compile and dsitribute OpenMP library for iOS.

OpenMP is part of [LLVM](https://github.com/llvm/llvm-project) distribution.

## Version

Latest supported version of OpenMP is [16.0.5](https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/openmp-16.0.5.src.tar.xz).

## Supported platforms

- iOS
- iOS Simulator
- tvOS
- tvOS Simulator
- watchOS
- watchOS Simulator
- macOS

## Requirements

- Xcode
- LLVM with Clang
- Homebrew
- g++
- CMake

## Why

Libraries such as BLAS, or FAISS depend on OpenMP to run parallel execution across different platforms, this repository is a structured way to get the OpenMP source code compiled and distributed to iOS developers.

## Getting started

Run `./openmp.sh` and it will create `dist/openmp.xcframework` that you can use in your Xcode project.

## openmp.xcframework

Once the compilation is done, you'll have XCframework created with the files below:

```shell
dist/openmp.xcframework
├── Info.plist
├── ios-arm64_arm64e
│   ├── Headers
│   │   └── omp.h
│   └── libomp.a
├── ios-arm64_arm64e_x86_64-simulator
│   ├── Headers
│   │   └── omp.h
│   └── libomp.a
├── macos-arm64_arm64e_x86_64
│   ├── Headers
│   │   └── omp.h
│   └── libomp.a
├── tvos-arm64
│   ├── Headers
│   │   └── omp.h
│   └── libomp.a
├── tvos-x86_64-simulator
│   ├── Headers
│   │   └── omp.h
│   └── libomp.a
├── watchos-arm64_32_armv7k
│   ├── Headers
│   │   └── omp.h
│   └── libomp.a
└── watchos-i386-simulator
    ├── Headers
    │   └── omp.h
    └── libomp.a
```

## Takeaways

If you're looking to run parallel code on iOS using Objective-C or Swift, make sure to check `examples` for the details on how to integrate the library.

If you're not looking to run complex calculations (linear algebra, DSP, neural networks), then you might want to consider Apple's Grand Central Dispatch, as it is more optimized to provide a better user experience (battery management and performance).

## Contributing

Contributions are welcome, feel free to submit an issue or open a pull request.

## License

[MIT](./LICENSE)

Copyright (c) 2023 [Eugene Hauptmann](http://twitter.com/eugenehp)

## Trademarks

The OpenMP name and the OpenMP logo are registered trademarks of the [OpenMP Architecture Review Board](https://www.openmp.org/about/trademarks/)
