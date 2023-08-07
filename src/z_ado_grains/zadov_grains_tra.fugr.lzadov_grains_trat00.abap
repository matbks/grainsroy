*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_TRA................................*
TABLES: ZADOV_GRAINS_TRA, *ZADOV_GRAINS_TRA. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_TRA
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_TRA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_TRA.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_TRA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_TRA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_TRA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_TRA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_TRA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_TRA_TOTAL.

*.........table declarations:.................................*
TABLES: ZADOT_GRAINS_TRA               .
