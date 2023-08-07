CLASS zcl_zadop_credit_block_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zadop_credit_block_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS jsoncommset_create_entity
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZADOP_CREDIT_BLOCK_DPC_EXT IMPLEMENTATION.


  METHOD jsoncommset_create_entity.

    DATA: log_return TYPE bapiret2.
    DATA: edc_data       TYPE zadott_grains_creditb_json_dat,
          edc            TYPE TABLE OF zadot_grains_016,
          discharge_data TYPE zadott_grains_creditd_json_dat.

    io_data_provider->read_entry_data( IMPORTING es_data = er_entity ).

    CASE er_entity-action.

      WHEN 'CRCRBLC'.

        DATA(return) = NEW zadocl_grains_credit_block( )->set_block( er_entity-json ).

      WHEN 'CRCRBLCD'.

        IF er_entity IS NOT INITIAL.

          cl_fdt_json=>json_to_data(
            EXPORTING
              iv_json = er_entity-json
            CHANGING
              ca_data = discharge_data ).

          IF discharge_data IS NOT INITIAL.

            TRY.
                DATA(company) = discharge_data[ 1 ]-company.

                SELECT SINGLE * FROM zadot_grains_009 INTO @DATA(authorized_user) WHERE username      = @sy-uname
                                                                                    AND ( auth_group  = 'DELETEDISC'
                                                                                     OR    auth_group = 'ADMIN' )
                                                                                    AND active        = 'X'
                                                                                    AND company_code  = @company.

              CATCH cx_sy_itab_line_not_found.
                CLEAR: company.
            ENDTRY.

            IF authorized_user IS NOT INITIAL.

              DATA(discharge) = VALUE zadot_grains_017(
                  block_number = discharge_data[ 1 ]-blocknumber
                  ref_doc      = discharge_data[ 1 ]-refdoc
                  reason       = discharge_data[ 1 ]-reason
                  status       = discharge_data[ 1 ]-status
                  quantity     = discharge_data[ 1 ]-quantity
                  operation    = discharge_data[ 1 ]-operation
                  created_at   = sy-datlo
                  created_on   = sy-timlo
                  created_by   = sy-uname
              ).

              IF discharge_data[ 1 ]-operation = '1'.

                MODIFY zadot_grains_017 FROM discharge.

              ELSEIF discharge_data[ 1 ]-operation = '2'.

                DATA(blocknumber) = discharge_data[ 1 ]-blocknumber.

                MODIFY zadot_grains_017 FROM discharge.

                UPDATE zadot_grains_017 SET operation = '2' WHERE block_number = blocknumber.


              ENDIF.

              IF sy-subrc <> 0.

                er_entity-returnmessage = 'Falha no registro da baixa na tabela ZADOT_GRAINS_017'.

                EXIT.

              ENDIF.

            ELSE.

              er_entity-returnmessage = 'Falha no registro da baixa por falta de permissão'.

            ENDIF.

          ENDIF.

        ELSE.

          er_entity-returnmessage = 'Falha no registro da baixa na tabela zadot_grains_017'.

        ENDIF.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
