#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>

/*ASIZE  &   NTHREADS*/

#ifndef NTHREADS
   #define NTHREADS 2
#endif
#ifndef ASIZE
   #define ASIZE 1000
#endif


int array[ASIZE];

void *add_up( void *number)
{
   int *pnum = (int *)number;
   int start = (*pnum  ) * (ASIZE/NTHREADS);
   int end = (*pnum + 1) * (ASIZE/NTHREADS);
   long sum = 0;

   for (start = start; start < end; start++)
      sum += array[start];
 
   return (void *)sum;
}


int main(int argc, char *argv[])
{
   int i;
   long sum = 0;
   pthread_t tid[NTHREADS];
   void * status;

   if( ASIZE % NTHREADS != 0 )
   {
      printf("ERROR: the disection does not break evenly\n");
      exit(EXIT_FAILURE);
   }

   if (argc != 2)
   {
      printf("ERROR: Need 2 arguments\n");
      exit(EXIT_FAILURE);
   }

   if ( ASIZE % 2 != 0 )
   {
      printf("ERROR: Cannot split array evenly\n");
      exit(EXIT_FAILURE);
   }

   for (i = 0; i < ASIZE; i++)
      array[i] = i*atoi(argv[1]);
   
  /*******************************************************/ 
   for (i = 0; i < NTHREADS; i++)
   {
      pthread_create(&tid[i], NULL, add_up, (void*)&i);
   }

   for (i = 0; i < NTHREADS; i++)
   {
      pthread_join(tid[i], &status);
      sum += (long)status;
   }
   /*******************************************************/

   /*For the main add up its portions*/
/*
   for (i = 0; i< (ASIZE/NTHREADS); i++)
      sum += array[i];
*/
   printf("%ld\n", sum);

   exit(EXIT_SUCCESS);
}

   
