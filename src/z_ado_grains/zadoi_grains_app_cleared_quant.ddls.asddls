@AbapCatalog.sqlViewName: 'ZADOIGRAINSACQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade Compensada da Aplicação'
define view ZADOI_GRAINS_APP_CLEARED_QUANT
  as select from zadot_grains_clr as ClearedQuantities

    inner join   bkpf             as AccHeader on  ClearedQuantities.clearing_document      = AccHeader.belnr
                                               and ClearedQuantities.clearing_document_year = AccHeader.gjahr
                                               and ClearedQuantities.company_code           = AccHeader.bukrs
                                               and AccHeader.xreversed = ''

{
  key contract_num             as ContractNum,
  key application_doc          as ApplicationDoc,
  key application_doc_item     as ApplicationDocItem,
  key company_code             as CompanyCode,
  key clearing_document        as ClearingDocument,
  key clearing_document_year   as ClearingDocumentYear,
      accounting_document_year as AccountingDocumentYear,
      accounting_document      as AccountingDocument,
      accounting_document_item as AccountingDocumentItem,
      edc                      as Edc,
      cleared_quantity         as ClearedQuantity,
      uom                      as Uom,
      created_by               as CreatedBy,
      created_on               as CreatedOn
}
