*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOT_ROYAL_DEL.................................*
DATA:  BEGIN OF STATUS_ZADOT_ROYAL_DEL               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZADOT_ROYAL_DEL               .
CONTROLS: TCTRL_ZADOT_ROYAL_DEL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZADOT_ROYAL_DEL               .
TABLES: ZADOT_ROYAL_DEL                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
