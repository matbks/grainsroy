*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_015................................*
TABLES: ZADOV_GRAINS_015, *ZADOV_GRAINS_015. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_015
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_015. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_015.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_015_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_015.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_015_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_015_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_015.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_015_TOTAL.

*.........table declarations:.................................*
TABLES: T001W                          .
TABLES: ZADOT_GRAINS_001               .
TABLES: ZADOT_GRAINS_002               .
TABLES: ZADOT_GRAINS_015               .
