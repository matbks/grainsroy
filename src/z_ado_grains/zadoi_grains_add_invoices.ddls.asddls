@AbapCatalog.sqlViewName: 'ZADOIGRAINSADINV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Notas Fiscais Complementares'
define view ZADOI_GRAINS_ADD_INVOICES

  as select from /accgo/t_stlhead as SettlementHeader
    inner join   /accgo/t_stlctnr as SettlementDocument    on SettlementDocument.stl_header_guid = SettlementHeader.stl_header_guid
    inner join   /accgo/t_stlinv  as SettlementInvoices    on  SettlementInvoices.group_guid = SettlementDocument.group_guid
                                                           and SettlementInvoices.doc_type   = 'SD'
    inner join   rbma             as ReceivedInvoiceItem   on  ReceivedInvoiceItem.belnr = SettlementInvoices.invoice_doc
                                                           and ReceivedInvoiceItem.gjahr = SettlementInvoices.invoice_doc_yr
    inner join   rbkp             as ReceivedInvoiceHeader on  ReceivedInvoiceHeader.belnr =  ReceivedInvoiceItem.belnr
                                                           and ReceivedInvoiceHeader.gjahr =  ReceivedInvoiceItem.gjahr
                                                           and ReceivedInvoiceHeader.zuonr <> ''

{

  SettlementHeader.tkonn                                                    as Contract,
  SettlementInvoices.group_id,
  SettlementInvoices.group_yr,
  SettlementInvoices.invoice_doc,
  SettlementInvoices.invoice_doc_yr,
  SettlementInvoices.doc_type,
  concat(SettlementInvoices.invoice_doc, SettlementInvoices.invoice_doc_yr) as refkey

}
