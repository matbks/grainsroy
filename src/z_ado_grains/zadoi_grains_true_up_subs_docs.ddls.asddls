@AbapCatalog.sqlViewName: 'ZADOIGRAINSTUSD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Documentos Subseq. Diferenças Aplicações'
define view ZADOI_GRAINS_TRUE_UP_SUBS_DOCS
  as select from    /accgo/t_brdiffd             as TrueUpDocs

    inner join      rbkp                         as InvoiceHeader      on  TrueUpDocs.doc_nr = InvoiceHeader.belnr
                                                                       and TrueUpDocs.doc_yr = InvoiceHeader.gjahr

    left outer join dd07t                        as DetDocTypeDescr    on  TrueUpDocs.det_doc_type    = DetDocTypeDescr.domvalue_l
                                                                       and DetDocTypeDescr.domname    = 'WLF_SHADOW_DOC_TYPE'
                                                                       and DetDocTypeDescr.ddlanguage = $session.system_language
                                                                       and DetDocTypeDescr.as4local   = 'A'


    left outer join ZADOC_GRAINS_VENDOR_ACC_DOCS as AccountingDocument on  InvoiceHeader.bukrs = AccountingDocument.CompanyCode
                                                                       and InvoiceHeader.belnr = AccountingDocument.InvoiceDocument
                                                                       and InvoiceHeader.gjahr = AccountingDocument.InvoiceDocumentYear

{
  key TrueUpDocs.doc_type         as DocType,
  key InvoiceHeader.belnr         as InvoiceDoc,
  key InvoiceHeader.gjahr         as InvoiceDocYear,
      TrueUpDocs.true_up_guid     as TrueUpGuid,
      TrueUpDocs.category         as Category,
      TrueUpDocs.det_doc_type     as DetDocType,
      DetDocTypeDescr.ddtext      as DetDocTypeDescr,
      TrueUpDocs.manual_doc_flg   as ManualDocFlg,
      TrueUpDocs.reversed_flg     as ReversedFlg,
      TrueUpDocs.reverse_doc_type as ReverseDocType,
      TrueUpDocs.reverse_doc_nr   as ReverseDocNr,
      TrueUpDocs.reverse_doc_yr   as ReverseDocYr,
      AccountingDocument.CompanyCode,
      AccountingDocument.AccountingDocument,
      AccountingDocument.AccountingDocumentYear,
      AccountingDocument.AccountingItem,

      @Semantics.amount.currencyCode: 'Currency'
      AccountingDocument.AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      AccountingDocument.Currency

}

where
      doc_type            = 'H'
  and InvoiceHeader.stblg is initial
