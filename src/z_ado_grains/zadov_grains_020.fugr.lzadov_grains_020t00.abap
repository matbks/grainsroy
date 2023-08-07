*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_020................................*
TABLES: ZADOV_GRAINS_020, *ZADOV_GRAINS_020. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_020
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_020. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_020.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_020_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_020.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_020_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_020_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_020.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_020_TOTAL.

*.........table declarations:.................................*
TABLES: ZADOT_GRAINS_020               .
