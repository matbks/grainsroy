@AbapCatalog.sqlViewName: 'ZADOCGRAINSVAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Doc. Contábeis do Fornecedor'
define view ZADOC_GRAINS_VENDOR_ACC_DOCS
  as select from ZADOI_GRAINS_OPEN_VENDOR_ACC
{
  key CompanyCode,
  key AccountingDocument,
  key AccountingDocumentYear,
  key AccountingItem,
  key Vendor,
  key Status,
      Assignment,
      AccountingPostingDate,
      DebitCreditIndicator,
      PaymentTerm,
      BusinessPlace,
      BaseDate,
      BankPartnerType,
      AmountInCompanyCurrency,
      Currency,
      InvoiceDocument,
      InvoiceDocumentYear,
      ClearingDocument,
      ClearingDocumentYear,
      ClearingDate
}

union

select from ZADOI_GRAINS_VENDOR_CLEAR_ACC
{
  key CompanyCode,
  key AccountingDocument,
  key AccountingDocumentYear,
  key AccountingItem,
  key Vendor,
  key Status,
      Assignment,
      AccountingPostingDate,
      DebitCreditIndicator,
      PaymentTerm,
      BusinessPlace,
      BaseDate,
      BankPartnerType,
      AmountInCompanyCurrency,
      Currency,
      InvoiceDocument,
      InvoiceDocumentYear,
      ClearingDocument,
      ClearingDocumentYear,
      ClearingDate
}

//union 
//
//select from ZADOI_GRAINS_RESID_VENDOR_ACC{
//  key CompanyCode,
//  key AccountingDocument,
//  key AccountingDocumentYear,
//  key AccountingItem,
//  key Vendor,
//  key Status,
//      Assignment,
//      AccountingPostingDate,
//      DebitCreditIndicator,
//      PaymentTerm,
//      BusinessPlace,
//      BaseDate,
//      BankPartnerType,
//      AmountInCompanyCurrency,
//      Currency,
//      InvoiceDocument,
//      InvoiceDocumentYear,
//      ClearingDocument,
//      ClearingDocumentYear,
//      ClearingDate
//}
