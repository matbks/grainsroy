@AbapCatalog.sqlViewName: 'ZADOCGRAINSEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Nota fiscal do EDC'
define view ZADOC_GRAINS_EDC_INVOICE
  //  as select distinct from ZADOC_GRAINS_INVOICES as EdcInvoice
  as select distinct from ZADOC_GRAINS_APPL_INVOICES as EdcInvoice
{
  key  Edc                  as EdcNum,
       max(BR_NotaFiscal  ) as NfeNum
}

group by
  Edc
