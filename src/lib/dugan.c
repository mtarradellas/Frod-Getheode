#include "../include/dugan.h"
#include <stdio.h>
#include <stdlib.h>

#define BUFF_SIZE 300

static char ** mallocked;
static int sizeMallocked = 0;

char* readStr() {
  char *buffer = malloc(BUFF_SIZE-1);
  mallocked = realloc(mallocked, ++sizeMallocked);
  fgets(buffer, BUFF_SIZE-1, stdin);
  return buffer;
}

void exitProgram(){
  for(int i = 0; i < sizeMallocked; i++){
    free(*(mallocked + i));
  }
  free(mallocked);
}