@AbapCatalog.sqlViewName: 'ZADOCGRAINSAPLI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Informações fiscais documento de aplicação'
define view ZADOC_GRAINS_APPL_INVOICES
  as select from    ZADOI_GRAINS_APPL_INVOICES as AppInvoiceData

    left outer join wbhk                       as ContractHeader on AppInvoiceData.Contract = ContractHeader.tkonn

    left outer join rbkp                       as InvoiceHeader  on AppInvoiceData.InvoiceDoc = InvoiceHeader.belnr

    left outer join j_1bnflin                  as InvoiceItem    on  InvoiceItem.refkey = AppInvoiceData.InvoiceRefKey
                                                                 and InvoiceItem.reftyp = 'LI'

    left outer join j_1bnfdoc                  as NFHeader       on NFHeader.docnum = InvoiceItem.docnum

{
  key AppInvoiceData.SettlementDoc,
  key AppInvoiceData.GroupId,
  key AppInvoiceData.GroupYear,
      @EndUserText.label: 'Chave referência'
  key cast( AppInvoiceData.InvoiceRefKey as awkey ) as InvoiceRefKey,
  key AppInvoiceData.InvoiceDoc                     as SupplierInvoice,
  key AppInvoiceData.ApplicationDoc,
      AppInvoiceData.InvoiceDocYear                 as FiscalYear,
      AppInvoiceData.InvoiceDocType,
      AppInvoiceData.Contract,
      ContractHeader.tctyp                          as ContractType,
      AppInvoiceData.pterm,
      AppInvoiceData.Edc,
      AppInvoiceData.Quantity,
      AppInvoiceData.Unit,
      AppInvoiceData.AbdNumber,
      NFHeader.docnum                               as DocNum,
      NFHeader.nfenum                               as BR_NotaFiscal,
      NFHeader.series                               as Serie,
      InvoiceItem.cfop                              as Cfop,
      InvoiceItem.mwskz                             as Iva,
      NFHeader.docstat                              as InvoiceStatus,
      InvoiceHeader.j_1bnftype                      as NfType,

      case
      when InvoiceHeader.stblg is not initial then 'X'
      else '' end                                   as Reversed

}
