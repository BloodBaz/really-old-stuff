/* Rotinas diversas        */
/* por Haroldo O. Pinheiro */

#ifndef _INCLUDE_UTILS
#define _INCLUDE_UTILS

#include "genesis.h"

extern ulong lastsamplesize;

uint random(range);
uint strlen2(str);
void out_text(X,Y,pal,fieldAddr,str);
void out_uint(X,Y,pal,fieldAddr,pad,num);
void out_ulong(X,Y,pal,fieldAddr,pad,num);
void play_GFS_sound(filename);

#endif
