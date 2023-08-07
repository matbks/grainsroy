@AbapCatalog.sqlViewName: 'ZADOCGRAINSBTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Saldos disponíveis para fixações de venda'
define view ZADOC_GRAINS_BALANCES_TO_SALES
  as select from    /accgo/t_uisevnt                                         as EventDetails

    left outer join /accgo/t_cas_cai                                         as ApplicationDocItem  on  ApplicationDocItem.uis_guid = EventDetails.parent_key
                                                                                                    and ApplicationDocItem.shd_type = 'ZA'

    left outer join ZADOTF_GRAINS_BALANCES_SALES ( p_clnt: $session.client ) as ApplicationQuantity on ApplicationQuantity.ApplicationDoc = ApplicationDocItem.appldoc

    left outer join t001w                                                    as PlantData           on PlantData.werks = ApplicationDocItem.werks

    left outer join ZADOA_GRAINS_SALES_CONS_APP                              as ConsumedQuantity    on ConsumedQuantity.ApplDoc = ApplicationDocItem.appldoc

    left outer join ZADOC_GRAINS_SALES_APP_BILLING                           as BillingData         on  BillingData.ApplicationDoc = ApplicationDocItem.appldoc
                                                                                                    and BillingData.BillingStatus  = '1'
                                                                                                    and BillingData.BillingDocType = 'M'
{
  key    ApplicationDocItem.appldoc             as ApplicationDoc,
  key    EventDetails.tc_id                     as ContractNum,
         EventDetails.tc_item                   as ContractItem,
         ApplicationDocItem.uis_id              as Edc,
         ApplicationDocItem.werks               as Plant,
         PlantData.name1                        as PlantName,
         ApplicationDocItem.matnr               as Material,
         ApplicationDocItem.base_uom            as AppUnit,
         @Semantics.quantity: {unitOfMeasure: 'AppUnit'}
         ApplicationQuantity.Quantity           as AppQuantity,
         @Semantics.quantity: {unitOfMeasure: 'AppUnit'}
         ConsumedQuantity.ConsumedQuantity      as ConsumedQuantity,
         @Semantics.quantity: {unitOfMeasure: 'AppUnit'}
         case when ConsumedQuantity.ConsumedQuantity > 0 then
         ApplicationQuantity.Quantity - ConsumedQuantity.ConsumedQuantity
         else  ApplicationQuantity.Quantity end as AvailableQuantity,
         BillingData.DocNum                     as DocNum
}
