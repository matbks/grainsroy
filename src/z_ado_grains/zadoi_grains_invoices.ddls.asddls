@AbapCatalog.sqlViewName: 'ZADOIGRAINSINVO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório de notas fiscais'
define view ZADOI_GRAINS_INVOICES

  as select from /accgo/t_stlhead as SettlementHeader
    inner join   /accgo/t_stlctnr as SettlementDocument on SettlementDocument.stl_header_guid = SettlementHeader.stl_header_guid
    inner join   /accgo/t_stlinv  as SettlementInvoices on  SettlementInvoices.group_guid = SettlementDocument.group_guid
                                                        and SettlementInvoices.doc_type   = 'IV'
    inner join   /accgo/t_stlitem as SettlementItems    on SettlementItems.stl_header_guid = SettlementHeader.stl_header_guid
{

  SettlementHeader.tkonn                                                    as Contract,
  SettlementInvoices.group_id,
  SettlementInvoices.group_yr,
  SettlementHeader.appldoc,
  SettlementInvoices.invoice_doc,
  SettlementInvoices.invoice_doc_yr,
  SettlementInvoices.doc_type,
  SettlementItems.uis_id,
  concat(SettlementInvoices.invoice_doc, SettlementInvoices.invoice_doc_yr) as refkey,
  SettlementHeader.pterm
}
