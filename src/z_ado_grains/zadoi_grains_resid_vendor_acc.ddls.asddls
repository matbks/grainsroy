@AbapCatalog.sqlViewName: 'ZADOIGRAINSRVA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Documentos contábeis - Saldos Residuais'
define view ZADOI_GRAINS_RESID_VENDOR_ACC
  as select from bkpf      as AccountingHeader

    inner join   bsak_view as ClearedAccountingItem on  AccountingHeader.bukrs = ClearedAccountingItem.bukrs
                                                    and AccountingHeader.belnr = ClearedAccountingItem.belnr
                                                    and AccountingHeader.gjahr = ClearedAccountingItem.gjahr

    inner join   bsik_view as OpenAccountingItem    on  ClearedAccountingItem.bukrs = OpenAccountingItem.bukrs
                                                    and ClearedAccountingItem.belnr = OpenAccountingItem.rebzg
                                                    and ClearedAccountingItem.gjahr = OpenAccountingItem.rebzj
                                                    and ClearedAccountingItem.buzei = OpenAccountingItem.rebzz


  association [1..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode

{
  key OpenAccountingItem.bukrs                              as CompanyCode,
  key OpenAccountingItem.belnr                              as AccountingDocument,
  key OpenAccountingItem.gjahr                              as AccountingDocumentYear,
  key OpenAccountingItem.buzei                              as AccountingItem,
  key OpenAccountingItem.lifnr                              as Vendor,
  key cast('RESIDUAL' as zadode_grains_acc_status)          as Status,
      OpenAccountingItem.zuonr                              as Assignment,

      OpenAccountingItem.budat                              as AccountingPostingDate,
      OpenAccountingItem.shkzg                              as DebitCreditIndicator,
      OpenAccountingItem.zterm                              as PaymentTerm,
      OpenAccountingItem.bupla                              as BusinessPlace,
      OpenAccountingItem.zfbdt                              as BaseDate,
      OpenAccountingItem.bvtyp                              as BankPartnerType,

      @Semantics.amount.currencyCode: 'Currency'
      OpenAccountingItem.dmbtr                              as AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      _CompanyCode.Currency,


      cast(left(AccountingHeader.awkey, 10) as re_belnr)    as InvoiceDocument,
      cast(substring(AccountingHeader.awkey,11,4) as gjahr) as InvoiceDocumentYear,

      OpenAccountingItem.augbl                              as ClearingDocument,
      OpenAccountingItem.auggj                              as ClearingDocumentYear,
      OpenAccountingItem.augdt                              as ClearingDate


}
