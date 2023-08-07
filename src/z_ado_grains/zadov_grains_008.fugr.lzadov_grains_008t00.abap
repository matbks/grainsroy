*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_008................................*
TABLES: ZADOV_GRAINS_008, *ZADOV_GRAINS_008. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_008
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_008. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_008.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_008_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_008.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_008_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_008_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_008.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_008_TOTAL.

*.........table declarations:.................................*
TABLES: ADRP                           .
TABLES: T001                           .
TABLES: USR21                          .
TABLES: ZADOT_GRAINS_001               .
TABLES: ZADOT_GRAINS_008               .
