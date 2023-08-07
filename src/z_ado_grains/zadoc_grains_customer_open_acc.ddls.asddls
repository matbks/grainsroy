@AbapCatalog.sqlViewName: 'ZADOCGRAINSCPAC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Partidas em aberto do cliente'
define view ZADOC_GRAINS_CUSTOMER_OPEN_ACC
  as select from ZADOI_GRAINS_CUSTOMERS_OPN_ACC
{
  key CompanyCode,
  key AccountingDocument,
  key AccountingItem,
  key AccountingDocumentYear,
      PostingDate,
      PostingYearMonth,
      DocumentType,
      Reference,
      Currency,
      AmountDocumentCurrency,
      AmountInLocalCurrency,
      AmountInHardCurrency,
      PaymentCondition,
      BillingDocument,
      BillingType,
      DeliveryDocument,
      SalesDocument,
      Customer,
      CustomerName,
      Contract,
      ContractItem,
      ContractCommodityItem,
      Material,
      MaterialDescription,
      BalanceQuantity,
      BaseUnitOfMeasure,
      BalanceSacks
}
