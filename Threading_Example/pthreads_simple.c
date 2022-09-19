#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

#define MAXSTRING 50
 

void *routine( void *arg )
{
   int num;
   int *pnum = (int *)arg;
   
   num = *pnum + INCCNT;

   printf("Count: %d\n", num);
   exit(EXIT_SUCCESS);
}

int main(int argc, char *argv[])
{
   char arg_append[MAXSTRING];
   pthread_t tid;
   int id = 0;
   unsigned len,  index = 0;
   char string[] = " Example";

   if (argc != 3)
   {
      printf("ERROR: Need three arguments\n");
      exit(EXIT_FAILURE);
   }

   if (strlen(argv[1]) > MAXSTRING)
   {
      printf("ERROR: Argument too big\n");
      exit(EXIT_FAILURE);
   }
   if (atoi(argv[2]))
   {
      id = atoi(argv[2]);
   }
   else
   {
      printf("ERROR: argument 3 needs to be a number\n");
      exit(EXIT_FAILURE);
   }

   pthread_create(&tid, NULL, routine, (void *)&id );

/*   strcat(arg_append, argv[1]);*/
   len = strlen(argv[1]);
   while(index <= len)
   {
      arg_append[index] = argv[1][index];
      index++;
   } 


   strcat(arg_append, string);

   printf("Concat String: %s\n", arg_append);


   pthread_join(tid, NULL);  
   exit(EXIT_SUCCESS);
}

