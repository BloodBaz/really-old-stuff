#include <stdio.h>

#include "rpg_conf.h"
#include "rpg_defs.h"
#include "chs_defs.h"
#include "chs_load.h"
#include "chs_intr.h"

#include "mfs.h"

void rpg_chs_run_prog(rpg_display_data *data, rpg_map *map, int prognum, char *param) {
    char fname[16];
    mfs_dir_entry *dir;
	cheese_envyro envyro;
	rpg_extra_data extra;

    sprintf(fname, "PROG%d.CHO", prognum);
    dir = mfs_find_dir_entry(fname);
    if (!dir) {
       printf("%s not found.", fname);
    }
//    wclear(data->textwin);
//    if ((progfile=fopen(fname,"rb"))==NULL) { /* open Mouse source file        */
//        waddstr(data->textwin, fname);
//        waddstr(data->textwin, " not found.");
//        wrefresh(data->textwin);
//        return;
//    }
    
	envyro.prog = mfs_fetch(dir);
	envyro.tracing = 0;
	envyro.extra = &extra;
	
	extra.display = data;
	extra.map = map;
	extra.env = map->extra;
	extra.data_ptr = map->prog_parms;
    
//	chs_load(progfile, &envyro);                /* load program into memory      */
//	fclose(progfile);                           /* close Mouse source file       */

	/*---------------------------------------------------------------------------*/
	/*  If load went OK, then define macros and run the interpreter.             */
	/*---------------------------------------------------------------------------*/

	if (!envyro.disaster) {                      /* if no load problems..         */
		chs_makedeftable(&envyro);               /* create macro definition table */
		chs_interpret(&envyro);                  /* and run interpreter           */
	}    
}

void rpg_map_load(rpg_display_data *data, char *buf, int mapnum) {
    char fname[16];
    FILE  *mapfile;

    sprintf(fname, "MAP%d.PMP", mapnum);
/*    wclear(data->textwin);
    if ((mapfile=fopen(fname,"rb"))==NULL) { 
        waddstr(data->textwin, fname);
        waddstr(data->textwin, " not found.");
        wrefresh(data->textwin);
        return;
    }*/
    
/*	fread(buf, 2048, 1, mapfile);
	fclose(mapfile);                          */
}
