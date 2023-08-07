@AbapCatalog.sqlViewName: 'ZADOCGRAINSSABL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Informações fiscais aplicações venda'
define view ZADOC_GRAINS_SALES_APP_BILLING
  as select from    ZADOI_GRAINS_SALES_APP_BILLING as ApplicationBillingData

    left outer join j_1bnflin                      as InvoiceItem   on InvoiceItem.refkey = ApplicationBillingData.BillingDoc

    left outer join j_1bnfdoc                      as InvoiceHeader on InvoiceHeader.docnum = InvoiceItem.docnum
{
  key  ApplicationBillingData.ApplicationDoc,
  key  ApplicationBillingData.BillingDoc,
       ApplicationBillingData.BillingDocType,
       ApplicationBillingData.Edc,
       ApplicationBillingData.Quantity,
       ApplicationBillingData.Unit,
       ApplicationBillingData.Contract,
       ApplicationBillingData.pterm as Pterm,
       InvoiceHeader.series         as Series,
       InvoiceHeader.nfenum         as NfeNum,
       InvoiceHeader.docstat        as BillingStatus,
       InvoiceItem.docnum           as DocNum,
       InvoiceItem.cfop             as Cfop,
       InvoiceItem.mwskz            as Iva

}
where
  ApplicationBillingData.BillingDoc is not initial
