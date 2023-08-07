*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_009................................*
TABLES: ZADOV_GRAINS_009, *ZADOV_GRAINS_009. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_009
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_009. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_009.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_009_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_009.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_009_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_009_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_009.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_009_TOTAL.

*.........table declarations:.................................*
TABLES: ADRP                           .
TABLES: T001                           .
TABLES: USR21                          .
TABLES: ZADOT_GRAINS_001               .
TABLES: ZADOT_GRAINS_008               .
TABLES: ZADOT_GRAINS_009               .
