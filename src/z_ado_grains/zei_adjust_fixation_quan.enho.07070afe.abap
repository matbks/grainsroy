"Name: \TY:/ACCGO/CL_IM_VC_CRT_CHG_API\IN:/ACCGO/IF_BADI_CAK_CRT_CHG_API\ME:MODIFY_PRICE_FIXATION_DATA\SE:END\EI
ENHANCEMENT 0 ZEI_ADJUST_FIXATION_QUAN.
LOOP AT ct_prc_exercise_all ASSIGNING FIELD-SYMBOL(<fs_line>).
  <fs_line>-accgo_per_quantity = 100.
ENDLOOP.
ENDENHANCEMENT.
