# macOS example application that uses OpenMP

## Getting started

1. Make sure to build OpenMP library in the root of the repository first using `./openmp.sh`
2. Compile and run the macOS app using `./go.sh`
3. Done

Here's an example output you should expect:

```shell
./go.sh 
Thread id - 4, Number of threads - 1, max threads - 8
Thread id - 3, Number of threads - 1, max threads - 8
Thread id - 6, Number of threads - 1, max threads - 8
Thread id - 0, Number of threads - 1, max threads - 8
Thread id - 7, Number of threads - 1, max threads - 8
Thread id - 5, Number of threads - 1, max threads - 8
Thread id - 2, Number of threads - 1, max threads - 8
Thread id - 1, Number of threads - 1, max threads - 8
```