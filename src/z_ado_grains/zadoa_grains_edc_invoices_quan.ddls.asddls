@AbapCatalog.sqlViewName: 'ZADOA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade fornecida pelas notas fiscais do edc'
define view ZADOA_GRAINS_EDC_INVOICES_QUAN
  as select from ZADOC_GRAINS_APPL_INVOICES as EdcInvoices
{
  key EdcInvoices.Edc           as EdcNum,
      sum(EdcInvoices.Quantity) as EdcQuantity
}

where
          EdcInvoices.pterm          = 'ZAFI'
  and     EdcInvoices.InvoiceDocType = 'IV'
  and(
    (
          EdcInvoices.NfType         is not initial
      and EdcInvoices.InvoiceStatus  = '1'
      and EdcInvoices.BR_NotaFiscal  is not initial
    )
    or(
          EdcInvoices.ContractType   = 'ZCR6'
    )
  )

group by
  EdcInvoices.Edc
