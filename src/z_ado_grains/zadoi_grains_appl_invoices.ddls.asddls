@AbapCatalog.sqlViewName: 'ZADOIGRAINSAPLI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Fixações do contrato'
define view ZADOI_GRAINS_APPL_INVOICES

  as select from    /accgo/t_stlhead as SettlementHeader

    left outer join /accgo/t_stlitem as SettlementItem      on SettlementItem.stl_header_guid = SettlementHeader.stl_header_guid

    left outer join /accgo/t_stlctnr as SettlementContainer on SettlementHeader.stl_header_guid = SettlementContainer.stl_header_guid

    left outer join /accgo/t_stlinv  as SettlementInvoice   on SettlementContainer.group_guid = SettlementInvoice.group_guid


{
  key  SettlementHeader.settl_doc                                              as SettlementDoc,
  key  SettlementInvoice.group_id                                              as GroupId,
  key  SettlementInvoice.group_yr                                              as GroupYear,
  key  SettlementHeader.appldoc                                                as ApplicationDoc,
       SettlementInvoice.invoice_doc                                           as InvoiceDoc,
       SettlementInvoice.invoice_doc_yr                                        as InvoiceDocYear,
       SettlementInvoice.doc_type                                              as InvoiceDocType,
       concat(SettlementInvoice.invoice_doc, SettlementInvoice.invoice_doc_yr) as InvoiceRefKey,
       SettlementItem.uis_id                                                   as Edc,
       @Semantics.quantity.unitOfMeasure: 'Unit'
       SettlementItem.document_qty                                             as Quantity,
       SettlementItem.document_uom                                             as Unit,
       SettlementHeader.tkonn                                                  as Contract,
       SettlementHeader.pterm,
       SettlementHeader.wbeln                                                  as AbdNumber
}
