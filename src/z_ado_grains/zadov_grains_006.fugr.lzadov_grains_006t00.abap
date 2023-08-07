*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZADOV_GRAINS_006................................*
TABLES: ZADOV_GRAINS_006, *ZADOV_GRAINS_006. "view work areas
CONTROLS: TCTRL_ZADOV_GRAINS_006
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZADOV_GRAINS_006. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZADOV_GRAINS_006.
* Table for entries selected to show on screen
DATA: BEGIN OF ZADOV_GRAINS_006_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_006.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_006_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZADOV_GRAINS_006_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZADOV_GRAINS_006.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZADOV_GRAINS_006_TOTAL.

*.........table declarations:.................................*
TABLES: /UI2/SEMOBJ                    .
TABLES: /UI2/SEMOBJT                   .
TABLES: DDDDLSRCT                      .
TABLES: T001                           .
TABLES: ZADOT_GRAINS_001               .
TABLES: ZADOT_GRAINS_002               .
TABLES: ZADOT_GRAINS_004               .
TABLES: ZADOT_GRAINS_006               .
