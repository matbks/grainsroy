@AbapCatalog.sqlViewName: 'ZADOIGRAINSVCAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Documentos Contábeis de Forn. Compensados'
define view ZADOI_GRAINS_VENDOR_CLEAR_ACC
  as select from bkpf      as AccountingHeader

    inner join   bsak_view as ClearedAccountingItem on  AccountingHeader.bukrs = ClearedAccountingItem.bukrs
                                                    and AccountingHeader.belnr = ClearedAccountingItem.belnr
                                                    and AccountingHeader.gjahr = ClearedAccountingItem.gjahr


  association [1..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode

{
  key AccountingHeader.bukrs                                as CompanyCode,
  key AccountingHeader.belnr                                as AccountingDocument,
  key AccountingHeader.gjahr                                as AccountingDocumentYear,
  key ClearedAccountingItem.buzei                           as AccountingItem,
  key ClearedAccountingItem.lifnr                           as Vendor,
  key cast('CLEARING' as zadode_grains_acc_status)          as Status,
      ClearedAccountingItem.zuonr                           as Assignment,

      ClearedAccountingItem.budat                           as AccountingPostingDate,
      ClearedAccountingItem.shkzg                           as DebitCreditIndicator,
      ClearedAccountingItem.zterm                           as PaymentTerm,
      ClearedAccountingItem.bupla                           as BusinessPlace,
      ClearedAccountingItem.zfbdt                           as BaseDate,
      ClearedAccountingItem.bvtyp                           as BankPartnerType,

      @Semantics.amount.currencyCode: 'Currency'
      ClearedAccountingItem.dmbtr                           as AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      _CompanyCode.Currency,


      cast(left(AccountingHeader.awkey, 10) as re_belnr)    as InvoiceDocument,
      cast(substring(AccountingHeader.awkey,11,4) as gjahr) as InvoiceDocumentYear,

      ClearedAccountingItem.augbl                           as ClearingDocument,
      ClearedAccountingItem.auggj                           as ClearingDocumentYear,
      ClearedAccountingItem.augdt                           as ClearingDate

}

