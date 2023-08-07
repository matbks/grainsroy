*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_019................................*
TABLES: ZADOV_GRAINS_019, *ZADOV_GRAINS_019. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_019
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_019. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_019.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_019_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_019.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_019_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_019_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_019.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_019_TOTAL.

*.........table declarations:.................................*
TABLES: T001W                          .
TABLES: ZADOT_GRAINS_019               .
