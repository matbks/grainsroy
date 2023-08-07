@AbapCatalog.sqlViewName: 'ZADOIGRAINSBD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Obter a OV a partir do documento de faturamento'
define view ZADOI_GRAINS_BILLING_DELIVERY
  as select from    vbrk                                                  as BillingHeader
    inner join      vbrp                                                  as BillingItems     on BillingHeader.vbeln = BillingItems.vbeln

    left outer join lips                                                  as DeliveryItems    on  BillingItems.vgbel = DeliveryItems.vbeln
                                                                                              and BillingItems.vgpos = DeliveryItems.posnr

    left outer join wbhk                                                  as ContractHeader   on BillingItems.aubel = lpad(
      ContractHeader.zzrefbater, 10, '0'
    )

    left outer join wbhi                                                  as ContractItem     on ContractHeader.tkonn = ContractItem.tkonn

    left outer join ZADOTF_GRAINS_CONTRACT_QUANT(p_clnt :$session.client) as ContractQuantity on  ContractItem.tkonn = ContractQuantity.Contract
                                                                                              and ContractItem.tposn = ContractQuantity.ContractItem

    left outer join makt                                                  as MaterialDescr    on  ContractItem.matnr  = MaterialDescr.matnr
                                                                                              and MaterialDescr.spras = $session.system_language

    left outer join I_Customer                                            as Partners         on Partners.Customer = BillingHeader.kunag

{
  key BillingHeader.vbeln                                                        as BillingDocument,
  key BillingItems.posnr                                                         as BillingItem,
      BillingHeader.fkart                                                        as BillingType,
      DeliveryItems.vbeln                                                        as DeliveryDocument,
      DeliveryItems.posnr                                                        as DeliveryItem,
      BillingItems.aubel                                                         as SalesDocument,
      BillingItems.aupos                                                         as SalesItem,

      ContractHeader.tkonn                                                       as Contract,
      ContractItem.tposn                                                         as ContractItem,
      ContractQuantity.ContractCommodityItem                                     as ContractCommodityItem,

      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      ContractQuantity.BalanceQuantity                                           as BalanceQuantity,

      @Semantics.unitOfMeasure: true
      ContractQuantity.BaseUnitOfMeasure                                         as BaseUnitOfMeasure,

      cast(division(ContractQuantity.BalanceQuantity, 60, 3) as zadode_grains_quantity_kg) as BalanceSacks,

      ContractItem.matnr                                                         as Material,
      MaterialDescr.maktx                                                        as MaterialDescription,

      cast(case when BillingItems.uecha is initial
        then BillingItems.posnr
        else BillingItems.uecha end as uecha)                                    as HigherLevelItemBatch,

      BillingHeader.kunag                                                        as Customer,
      cast(Partners.CustomerName as ehprc_custname)                              as CustomerName

}
