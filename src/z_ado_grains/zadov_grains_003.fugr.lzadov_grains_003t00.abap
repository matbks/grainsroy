*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_003................................*
TABLES: ZADOV_GRAINS_003, *ZADOV_GRAINS_003. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_003
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_003. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_003.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_003_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_003.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_003_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_003_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_003.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_003_TOTAL.

*.........table declarations:.................................*
TABLES: T001                           .
TABLES: TB2BE                          .
TABLES: TB2BET                         .
TABLES: ZADOT_GRAINS_001               .
TABLES: ZADOT_GRAINS_002               .
TABLES: ZADOT_GRAINS_003               .
