CLASS zadocl_grains_get_acc_tree DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        company_code             TYPE bukrs
        accounting_document      TYPE belnr_d
        accounting_document_year TYPE gjahr
        accounting_item          TYPE buzei.


    METHODS get_entityset_data
      RETURNING VALUE(return) TYPE zadott_grains_acc_tree.

    METHODS get_last_document
      RETURNING VALUE(return) TYPE zados_grains_acc_tree.


  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: company_code             TYPE bukrs,
          accounting_document      TYPE belnr_d,
          accounting_document_year TYPE gjahr,
          accounting_item          TYPE buzei.

    METHODS execute.

    DATA: node_id         TYPE int2,
          hierarchy_level TYPE Int2.

    METHODS get_acc_data
      IMPORTING company_code             TYPE bukrs
                accounting_document      TYPE belnr_d
                accounting_document_year TYPE gjahr
                accounting_item          TYPE buzei
                parent_node_id           TYPE int2 OPTIONAL.

    DATA: entityset TYPE TABLE OF zados_grains_acc_tree.

ENDCLASS.



CLASS zadocl_grains_get_acc_tree IMPLEMENTATION.


  METHOD constructor.

    me->company_code             = company_code.
    me->accounting_document      = accounting_document.
    me->accounting_document_year = accounting_document_year.
    me->accounting_item          = accounting_item .

    me->execute( ).

  ENDMETHOD.


  METHOD get_entityset_data.

    return = me->entityset.

  ENDMETHOD.


  METHOD get_last_document.

    return = VALUE #( me->entityset[ status = 'OPEN' ] OPTIONAL ).

  ENDMETHOD.


  METHOD execute.

    me->node_id         = 1.
    me->hierarchy_level = 0.

    me->get_acc_data( company_code             = me->company_code
                      accounting_document      = me->accounting_document
                      accounting_document_year = me->accounting_document_year
                      accounting_item          = me->accounting_item ).

  ENDMETHOD.


  METHOD get_acc_data.

    DATA: acc_docs     TYPE TABLE OF zadoi_grains_tree_acc_docs,
          reverse_docs TYPE TABLE OF zadoi_grains_tree_acc_docs.


    DATA(l_parent_node_id) = parent_node_id.


    IF node_id = 1.
      SELECT SINGLE * FROM zadoi_grains_tree_acc_docs WHERE CompanyCode            = @company_code
                                                        AND AccountingDocument     = @accounting_document
                                                        AND AccountingDocumentYear = @accounting_document_year
                                                        AND AccountingItem         = @accounting_item
                                                      INTO @DATA(acc_doc_node_1).

      APPEND acc_doc_node_1 TO acc_docs.

    ELSE.

      "Documentos Residuais
      SELECT * FROM zadoi_grains_tree_acc_docs WHERE CompanyCode         = @company_code
                                                 AND ProcedingAccDoc     = @accounting_document
                                                 AND ProcedingAccDocYear = @accounting_document_year
                                                 AND ProcedingAccItem    = @accounting_item
                                                INTO TABLE @acc_docs.

      IF sy-subrc = 0.



        "Estornos
        SELECT * FROM zadoi_grains_tree_acc_docs
         FOR ALL ENTRIES IN @acc_docs WHERE CompanyCode            = @acc_docs-CompanyCode
                                        AND AccountingDocument     = @acc_docs-ClearingDocument
                                        AND AccountingDocumentYear = @acc_docs-ClearingDocumentYear
                                        AND AccountingItem         = @acc_docs-AccountingItem
                                        AND status                 = 'REVERSEDOC'
                                       INTO TABLE @reverse_docs.

        APPEND LINES OF reverse_docs TO acc_docs.

      ENDIF.

    ENDIF.

    SORT acc_docs BY CompanyCode AccountingDocumentYear AccountingDocument.

    LOOP AT acc_docs INTO DATA(acc_doc).

      TRY.
          DATA(parent) = me->entityset[ accounting_document = acc_doc-ProcedingAccDoc ].
          me->hierarchy_level += 1.
        CATCH cx_sy_itab_line_not_found.
          TRY.
              parent = me->entityset[ clearing_document = acc_doc-AccountingDocument ].
              me->hierarchy_level += 1.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
      ENDTRY.


      APPEND VALUE zados_grains_acc_tree( node_id                  = me->node_id
                                          hierarchy_level          = me->hierarchy_level
                                          description              = |{ me->node_id }|
                                          parent_node_id           = parent-node_id
                                          drill_state              = 'expanded'
                                          company_code             = acc_doc-CompanyCode
                                          accounting_document      = acc_doc-AccountingDocument
                                          accounting_document_year = acc_doc-AccountingDocumentYear
                                          accounting_item          = acc_doc-accountingitem
                                          amount                   = COND #( WHEN acc_doc-DebitCreditIndicator = 'H' THEN acc_doc-AmountInCompanyCurrency  ELSE acc_doc-AmountInCompanyCurrency * -1 )
                                          currency                 = acc_doc-Currency
                                          status                   = acc_doc-Status
                                          clearing_document        = acc_doc-ClearingDocument
                                          clearing_document_year   = acc_doc-ClearingDocumentYear
                                          vendor                   = acc_doc-Vendor
                                          payment_term             = acc_doc-PaymentTerm
                                          business_place           = acc_doc-BusinessPlace
                                          base_date                = acc_doc-BaseDate
                                          bank_partner_type        = acc_doc-BankPartnerType
                                          reference_doc            = acc_doc-ReferenceDoc
                                          reference_year           = acc_doc-ReferenceYear
                                          reference_item           = acc_doc-ReferenceItem ) TO me->entityset.

      me->node_id += 1.


      me->get_acc_data( company_code             = acc_doc-companycode
                        accounting_document      = acc_doc-accountingdocument
                        accounting_document_year = acc_doc-accountingdocumentyear
                        accounting_item          = acc_doc-accountingitem
                        parent_node_id           = l_parent_node_id ).



    ENDLOOP.

  ENDMETHOD.



ENDCLASS.
