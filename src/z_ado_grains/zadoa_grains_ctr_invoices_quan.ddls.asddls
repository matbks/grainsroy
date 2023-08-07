@AbapCatalog.sqlViewName: 'ZADOAGRAINSCINVQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade fornecida pelas notas fiscais contrato'
define view ZADOA_GRAINS_CTR_INVOICES_QUAN
  as select from ZADOC_GRAINS_INVOICES as ContractInvoices
{
  key ContractInvoices.ContractNum as ContractNum,
      sum(ContractInvoices.Menge)  as InvoiceQuantity
}
group by
  ContractInvoices.ContractNum
