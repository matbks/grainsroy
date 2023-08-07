CLASS zadocl_grains_change_acc_doc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_bkdf_subst TYPE TABLE OF bkdf_subst.

    CLASS-METHODS change_acc_doc
      IMPORTING
        i_bkdf      TYPE bkdf OPTIONAL
      CHANGING
        i_bkdfsub   TYPE bkdf_subst OPTIONAL
        t_bkpf_t    TYPE bkpf_t
        t_bseg_t    TYPE bseg_t
        t_bkpfsub_t TYPE bkpf_subst_t
        t_bsegsub_t TYPE bseg_subst_t
        t_bsec_t    TYPE bsec_t OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zadocl_grains_change_acc_doc IMPLEMENTATION.

  METHOD change_acc_doc.

    BREAK t_lzanella.

    CHECK t_bkpf_t    IS NOT INITIAL.
    CHECK t_bsegsub_t IS NOT INITIAL.

    TRY.
        DATA(invoice_doc)      = CONV re_belnr( t_bkpf_t[ 1 ]-awkey(10)   ).
        DATA(invoice_doc_year) = CONV re_belnr( t_bkpf_t[ 1 ]-awkey+10(4) ).
      CATCH cx_sy_itab_line_not_found.
        CLEAR: invoice_doc, invoice_doc_year.

        RETURN.
    ENDTRY.

    CHECK invoice_doc      IS NOT INITIAL.
    CHECK invoice_doc_year IS NOT INITIAL.

    TRY.
        SELECT SINGLE * FROM zadot_grains_fix WHERE invoice_doc      = @invoice_doc
                                                AND invoice_doc_year = @invoice_doc_year
                                               INTO @DATA(fixation_header).
      CATCH cx_sy_open_sql_data_error.
        RETURN.
    ENDTRY.

    CHECK sy-subrc = 0.

    SELECT * FROM zadot_grains_bil WHERE plant              = @fixation_header-plant
                                     AND contractnum        = @fixation_header-contractnum
                                     AND identification_fix = @fixation_header-identification_fix
                                    INTO TABLE @DATA(fixation_installments).

    CHECK sy-subrc = 0.

    LOOP AT t_bsegsub_t ASSIGNING FIELD-SYMBOL(<bsegsub>).

      TRY.
          DATA(fixation_installment) = fixation_installments[ installment = CONV zadode_grains_installment( <bsegsub>-qsznr ) ].
        CATCH cx_sy_itab_line_not_found.
          CLEAR fixation_installment.
          CONTINUE.
      ENDTRY.

      <bsegsub>-bvtyp = fixation_installment-bankaccountid.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
