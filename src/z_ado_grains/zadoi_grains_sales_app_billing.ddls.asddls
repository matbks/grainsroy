@AbapCatalog.sqlViewName: 'ZADOIGRAINSSAPBL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Informações fiscais aplicações venda'
define view ZADOI_GRAINS_SALES_APP_BILLING

  as select from    /accgo/t_stlhead as SettlementHeader

    left outer join /accgo/t_stlitem as SettlementItem on SettlementItem.stl_header_guid = SettlementHeader.stl_header_guid

    left outer join /accgo/t_billdue as BillingData    on BillingData.stl_header_guid = SettlementItem.stl_header_guid

{
  key  SettlementHeader.appldoc    as ApplicationDoc,
  key  BillingData.billing_doc     as BillingDoc,
  key  BillingData.billing_doc_cat as BillingDocType,
       SettlementItem.uis_id       as Edc,
       @Semantics.quantity.unitOfMeasure: 'Unit'
       SettlementItem.document_qty as Quantity,
       SettlementItem.document_uom as Unit,
       SettlementHeader.tkonn      as Contract,
       SettlementHeader.pterm

}
