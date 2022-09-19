#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <wait.h>

#define SIZE 20
/*#define ASIZE*/


int main(int argc, char *argv[])
{
   int array[ASIZE];
   int i;
   int returnVal;
   int check_child;   
   int tube[2];
   unsigned long *sum, *sum2;
   unsigned long num1 = 0, num2 = 0;

   sum = &num1;
   sum2 = &num2;

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

   /*pipe creation*/
   if ( pipe(tube) == -1 )
   {   
      printf("ERROR: Pipe not created\n");
      exit(EXIT_FAILURE);
   }



   /*fork creation*/
   returnVal = fork();
   if (returnVal == -1)
   {
      printf("ERROR: Fork was not created\n");
      exit(EXIT_FAILURE);
   }

   /*Parent add and send*/
   if( returnVal > 0 )
   {
      
      for (i = 0; i < (ASIZE/2); i++)
         *sum += array[i];
   }

   /*Child recieve and add*/
   if( returnVal == 0 )
   {
      unsigned long *psumy;
      unsigned long sumy = 0;
      
      for (i = ASIZE/2; i < ASIZE; i++)
         sumy += array[i];

      psumy = &sumy;
      write(tube[1], psumy, sizeof(psumy));
      exit(EXIT_SUCCESS);
   }


   if( returnVal > 0)
   {  
      wait(&check_child);
      read(tube[0], sum2, sizeof(sum2));
      *sum += *sum2;

      printf("%ld\n", *sum); 

      close(tube[0]);
      close(tube[1]);
 
      if(check_child == 0)
         exit(EXIT_SUCCESS);
      else
         exit(EXIT_FAILURE);
   }


}
      
