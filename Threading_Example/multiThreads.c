#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

#define MAX 50
#define LINE 10000
/*---------------------------------------------------------------------------*/
int finder( char haystack[], char needle[] )
{
   int index = 0;
   int len = strlen(needle);

   while( strstr(haystack, needle) != NULL)
   {
      index++;
      haystack = strstr(haystack, needle);
      haystack = &haystack[len];
   }
   return index;
}
/*--------------------------------------------------------------------------*/
void move(char str1[], char *str2)
{
   unsigned len,    index = 0;
   len = strlen(str2);
   
   while(index <= len)
   {
      str1[index] = str2[index];
      index++;
   }

}
/*--------------------------------------------------------------------------*/
struct filesAndwords
{
   char file[MAX];
   char word[MAX];
};
typedef struct filesAndwords FAW;
/*-------------------------------------------------------------------------*/
void *find_w2(void *arguments)
{
   unsigned index = 0;
   FILE *fp;
   char string[LINE];
   FAW *arg = (FAW *)arguments;

   fp = fopen(arg->file, "r");
   if (fp == NULL)
   {
      perror("Failed Thread ");
      exit(EXIT_FAILURE);
   }
   
   while( fgets(string, sizeof(string), fp) != NULL )
      index += finder(string, arg->word);

   printf("%s Count: %d\n", arg->word,index);
   sleep(2);
   exit(EXIT_SUCCESS); 
}  /*I got structs to work by passing the address of the nonpointer, how build the find function*/
/*-------------------------------------------------------------------------*/
int main(int argc, char *argv[])
{
   FILE *fp;
   FAW arg1;
   pthread_t tid;
   unsigned index = 0;
   char string[LINE];
   

   if (argc != 5)
   {
      printf("ERRROR: incorrect number of arguments!\n");
      exit(EXIT_FAILURE);
   }
   
   move(arg1.file, argv[3]);
   move(arg1.word, argv[4]);
   
   if (pthread_create(&tid, NULL, find_w2, (void *)&arg1) != 0)
   {
      printf("ERROR: pthread was not created\n");
      exit(EXIT_FAILURE);
   }
   /*From here I am trying to read the file and figure out the number of that type of word in this*/
   
   fp = fopen(argv[1], "r");
   if (fp == NULL)
   {
      perror("Failed Main ");
      exit(EXIT_FAILURE);
   }
   
   while( fgets(string, sizeof(string), fp) != NULL )
      index += finder(string, argv[2]);



   printf("%s Count: %d\n",argv[2], index);
   fclose(fp);
   
   pthread_join(tid, NULL);


   exit(EXIT_SUCCESS);

}
