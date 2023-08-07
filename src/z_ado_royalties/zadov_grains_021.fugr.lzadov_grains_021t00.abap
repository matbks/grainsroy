*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_021................................*
TABLES: ZADOV_GRAINS_021, *ZADOV_GRAINS_021. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_021
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_021. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_021.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_021_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_021.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_021_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_021_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_021.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_021_TOTAL.

*.........table declarations:.................................*
TABLES: MAKT                           .
TABLES: ZADOT_GRAINS_001               .
TABLES: ZADOT_GRAINS_021               .
