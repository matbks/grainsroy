@AbapCatalog.sqlViewName: 'ZADOIGRAINSCOA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Partidas em aberto do cliente'
define view ZADOI_GRAINS_CUSTOMERS_OPN_ACC
  as select from    bsid                           as AccountingDocuments

    left outer join kna1                                               on kna1.kunnr = AccountingDocuments.kunnr

    left outer join ZI_PARTNERS                    as Partners         on Partners.Partner = kna1.kunnr

    left outer join ZADOI_GRAINS_BILLING_FRST_ITEM as BillingFirstItem on AccountingDocuments.vbeln = BillingFirstItem.BillingDocument

    left outer join ZADOI_GRAINS_BILLING_DELIVERY  as BillingDocuments on  BillingFirstItem.BillingDocument = BillingDocuments.BillingDocument
                                                                       and BillingFirstItem.BillingItem     = BillingDocuments.BillingItem

{
  key AccountingDocuments.bukrs                                  as CompanyCode,
  key AccountingDocuments.belnr                                  as AccountingDocument,
  key AccountingDocuments.buzei                                  as AccountingItem,
  key AccountingDocuments.gjahr                                  as AccountingDocumentYear,
      AccountingDocuments.budat                                  as PostingDate,
      cast(left(AccountingDocuments.budat,6) as spmon)           as PostingYearMonth,
      AccountingDocuments.blart                                  as DocumentType,
      AccountingDocuments.xblnr                                  as Reference,
      AccountingDocuments.waers                                  as Currency,

      cast( case when shkzg = 'H'
              then AccountingDocuments.wrbtr * -1
              else AccountingDocuments.wrbtr end as wrbtr_fm)    as AmountDocumentCurrency,

      cast( case when shkzg = 'H'
              then AccountingDocuments.dmbtr * -1
              else AccountingDocuments.dmbtr end as bhwhr)       as AmountInLocalCurrency,

      cast( case when shkzg = 'H'
              then AccountingDocuments.dmbe2 * -1
              else AccountingDocuments.dmbe2 end as fin_amthard) as AmountInHardCurrency,

      AccountingDocuments.zterm                                  as PaymentCondition,
      BillingDocuments.BillingDocument                           as BillingDocument,
      BillingDocuments.BillingType                               as BillingType,
      BillingDocuments.DeliveryDocument                          as DeliveryDocument,
      BillingDocuments.SalesDocument                             as SalesDocument,
      AccountingDocuments.kunnr                                  as Customer,
      cast(Partners.PartnerName as ehprc_custname)               as CustomerName,
      BillingDocuments.Contract                                  as Contract,
      BillingDocuments.ContractItem                              as ContractItem,
      BillingDocuments.ContractCommodityItem                     as ContractCommodityItem,
      BillingDocuments.Material                                  as Material,
      BillingDocuments.MaterialDescription                       as MaterialDescription,
      BillingDocuments.BalanceQuantity                           as BalanceQuantity,
      BillingDocuments.BaseUnitOfMeasure                         as BaseUnitOfMeasure,
      BillingDocuments.BalanceSacks                              as BalanceSacks

}

where
      AccountingDocuments.augbl =  ''
  and AccountingDocuments.umsks <> 'W'
  and AccountingDocuments.umskz <> 'R'
  and AccountingDocuments.umskz <> 'F'
//  and BillingDocuments.BillingItem = BillingDocuments.HigherLevelItemBatch
