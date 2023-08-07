*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_MAT................................*
TABLES: ZADOV_GRAINS_MAT, *ZADOV_GRAINS_MAT. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_MAT
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_MAT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_MAT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_MAT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_MAT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_MAT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_MAT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_MAT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_MAT_TOTAL.

*.........table declarations:.................................*
TABLES: MAKT                           .
TABLES: MARA                           .
TABLES: ZADOT_GRAINS_MAT               .
