@AbapCatalog.sqlViewName: 'ZADOAGRAINSAA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Documentos Contábil - Soma do Montante'
define view ZADOA_GRAINS_ACC_AMOUNT
  as select from ZADOC_GRAINS_VENDOR_ACC_DOCS
{
  key CompanyCode,
  key AccountingDocument,
  key AccountingDocumentYear,

      cast(sum(AmountInCompanyCurrency) as dmbtr ) as AmountInCompanyCurrency,
      Currency
}

group by
  CompanyCode,
  AccountingDocument,
  AccountingDocumentYear,
  Currency
