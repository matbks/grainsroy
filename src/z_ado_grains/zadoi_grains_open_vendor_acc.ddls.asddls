@AbapCatalog.sqlViewName: 'ZADOIGRAINSOVA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Partidas Abertas Fornecedor'
define view ZADOI_GRAINS_OPEN_VENDOR_ACC
  as select from bkpf      as AccountingHeader

    inner join   bsik_view as OpenAccountingItem on  AccountingHeader.bukrs = OpenAccountingItem.bukrs
                                                 and AccountingHeader.belnr = OpenAccountingItem.belnr
                                                 and AccountingHeader.gjahr = OpenAccountingItem.gjahr


  association [1..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode

{
  key AccountingHeader.bukrs                                as CompanyCode,
  key AccountingHeader.belnr                                as AccountingDocument,
  key AccountingHeader.gjahr                                as AccountingDocumentYear,
  key OpenAccountingItem.buzei                              as AccountingItem,
  key OpenAccountingItem.lifnr                              as Vendor,
  key cast('OPEN' as zadode_grains_acc_status)              as Status,
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
