*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOT_GRAINS_FIX................................*
DATA:  BEGIN OF STATUS_ZADOT_GRAINS_FIX              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZADOT_GRAINS_FIX              .
CONTROLS: TCTRL_ZADOT_GRAINS_FIX
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZADOT_GRAINS_FIX              .
TABLES: ZADOT_GRAINS_FIX               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
