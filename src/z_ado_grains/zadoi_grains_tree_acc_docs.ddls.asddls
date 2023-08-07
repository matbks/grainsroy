@AbapCatalog.sqlViewName: 'ZADOIGRAINSACCTR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Documentos Contábeis - Tree'
define view ZADOI_GRAINS_TREE_ACC_DOCS
  as select from bkpf      as AccountingHeader

    inner join   bsak_view as ClearedAccountingItem on  AccountingHeader.bukrs = ClearedAccountingItem.bukrs
                                                    and AccountingHeader.belnr = ClearedAccountingItem.belnr
                                                    and AccountingHeader.gjahr = ClearedAccountingItem.gjahr

  association [1..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode


{
  key ClearedAccountingItem.bukrs            as CompanyCode,
  key ClearedAccountingItem.belnr            as AccountingDocument,
  key ClearedAccountingItem.gjahr            as AccountingDocumentYear,
  key ClearedAccountingItem.buzei            as AccountingItem,
      ClearedAccountingItem.lifnr            as Vendor,


      cast( case
              when AccountingHeader.xreversed  = 'X' then 'REVERSED'
              when AccountingHeader.xreversing = 'X' then 'REVERSEDOC'
              else 'CLEARING'
            end as zadode_grains_acc_status) as Status,

      ClearedAccountingItem.zuonr            as Assignment,
      ClearedAccountingItem.budat            as AccountingPostingDate,
      ClearedAccountingItem.shkzg            as DebitCreditIndicator,

      @Semantics.amount.currencyCode: 'Currency'
      ClearedAccountingItem.dmbtr            as AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      _CompanyCode.Currency,


      ClearedAccountingItem.augbl            as ClearingDocument,
      ClearedAccountingItem.auggj            as ClearingDocumentYear,
      ClearedAccountingItem.augdt            as ClearingDate,

      ClearedAccountingItem.rebzg            as ProcedingAccDoc,
      ClearedAccountingItem.rebzj            as ProcedingAccDocYear,
      ClearedAccountingItem.rebzz            as ProcedingAccItem,
      AccountingHeader.xreversed             as Reversed,
      AccountingHeader.xreversal             as Reversal,
      AccountingHeader.xreversing            as Reversing,
      ClearedAccountingItem.zterm            as PaymentTerm,
      ClearedAccountingItem.bupla            as BusinessPlace,
      ClearedAccountingItem.zfbdt            as BaseDate,
      ClearedAccountingItem.bvtyp            as BankPartnerType,
      ClearedAccountingItem.rebzg            as ReferenceDoc,
      ClearedAccountingItem.rebzj            as ReferenceYear,
      ClearedAccountingItem.rebzz            as ReferenceItem
}


union select from bkpf      as AccountingHeader

  inner join      bsik_view as OpenAccountingItem on  AccountingHeader.bukrs = OpenAccountingItem.bukrs
                                                  and AccountingHeader.belnr = OpenAccountingItem.belnr
                                                  and AccountingHeader.gjahr = OpenAccountingItem.gjahr

association [1..1] to I_CompanyCode as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode


{
  key OpenAccountingItem.bukrs                 as CompanyCode,
  key OpenAccountingItem.belnr                 as AccountingDocument,
  key OpenAccountingItem.gjahr                 as AccountingDocumentYear,
  key OpenAccountingItem.buzei                 as AccountingItem,
      OpenAccountingItem.lifnr                 as Vendor,
      cast('OPEN' as zadode_grains_acc_status) as Status,
      OpenAccountingItem.zuonr                 as Assignment,
      OpenAccountingItem.budat                 as AccountingPostingDate,
      OpenAccountingItem.shkzg                 as DebitCreditIndicator,

      @Semantics.amount.currencyCode: 'Currency'
      OpenAccountingItem.dmbtr                 as AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      _CompanyCode.Currency,


      OpenAccountingItem.augbl                 as ClearingDocument,
      OpenAccountingItem.auggj                 as ClearingDocumentYear,
      OpenAccountingItem.augdt                 as ClearingDate,
      OpenAccountingItem.rebzg                 as ProcedingAccDoc,
      OpenAccountingItem.rebzj                 as ProcedingAccDocYear,
      OpenAccountingItem.rebzz                 as ProcedingAccItem,
      AccountingHeader.xreversed               as Reversed,
      AccountingHeader.xreversal               as Reversal,
      AccountingHeader.xreversing              as Reversing,
      OpenAccountingItem.zterm                 as PaymentTerm,
      OpenAccountingItem.bupla                 as BusinessPlace,
      OpenAccountingItem.zfbdt                 as BaseDate,
      OpenAccountingItem.bvtyp                 as BankPartnerType,
      OpenAccountingItem.rebzg                 as ReferenceDoc,
      OpenAccountingItem.rebzj                 as ReferenceYear,
      OpenAccountingItem.rebzz                 as ReferenceItem


}
