@AbapCatalog.sqlViewName: 'ZADOAGRAINSFRST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Obter primeiro item da partida gerada nota fiscal'
define view ZADOA_GRAINS_GET_NF_FIRST_ITEM
  as select from j_1bnflin as InvoiceItem

{
  key InvoiceItem.refkey      as ReferenceKey,
      max(InvoiceItem.docnum) as DocNum
}

group by
  InvoiceItem.refkey
