#include <stdio.h>
#include <omp.h>

int main()
{
  omp_set_dynamic(0);

  int maxThreads = omp_get_max_threads();
  omp_set_num_threads(maxThreads);
  int threadNumber = omp_get_num_threads();

#pragma omp parallel
#pragma omp critical
  {
    int tid = omp_get_thread_num();
    printf("Thread id - %d, Number of threads - %d, max threads - %d\n", tid, threadNumber, maxThreads);
  }

  return 0;
}