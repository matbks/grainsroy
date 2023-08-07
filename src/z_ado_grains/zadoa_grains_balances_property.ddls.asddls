@AbapCatalog.sqlViewName: 'ZADOAGRAINSBPROP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Agregação saldos aplicação por propriedade'

define view ZADOA_GRAINS_BALANCES_PROPERTY
  as select from    /accgo/t_uisevnt               as EventDetails

    left outer join /accgo/t_cas_cai               as ApplicationDocItem on  ApplicationDocItem.uis_guid = EventDetails.parent_key
                                                                         and ApplicationDocItem.shd_type = 'ZA'

    inner join      ZADOA_GRAINS_EDC_INVOICES_QUAN as InvoicesQuantity   on  InvoicesQuantity.EdcNum      = ApplicationDocItem.uis_id
                                                                         and InvoicesQuantity.EdcQuantity is not initial

    left outer join ztbacm_edc_nfe                 as EdcData            on EdcData.edc = ApplicationDocItem.uis_id

    left outer join ZADOA_GRAINS_PENDING_APPL_PROP as PendingQuantity    on  PendingQuantity.ContractNum = EventDetails.tc_id
                                                                         and PendingQuantity.Property    = EdcData.cod_pro
                                                                         and PendingQuantity.Plant       = ApplicationDocItem.werks
                                                                         and PendingQuantity.IdRoyalties = ''

    left outer join ZADOA_GRAINS_RETURNED_QUANTITY as ReturnedQuantity   on ReturnedQuantity.Edc = ApplicationDocItem.uis_id

{
  key    EventDetails.tc_id                                    as ContractNum,
  key    EdcData.cod_pro                                       as Property,
  key    ApplicationDocItem.werks                              as Plant,
         sum( case when  EventDetails.nfqty is initial
         then EventDetails.laqty else EventDetails.nfqty end ) as Quantity,
         sum(InvoicesQuantity.EdcQuantity)                     as InvoicesQuantity,
         sum(ReturnedQuantity.ReturnedQuantity)                as ReturnedQuantity,
         PendingQuantity.Quantity                              as PendingQuantity,
         ''                                                    as Transgenic
}

where
     EventDetails./accgo/royalties_id = 'TNI'
  or EventDetails./accgo/royalties_id = 'TCV'
  or EventDetails./accgo/royalties_id is initial

group by
  EventDetails.tc_id,
  EdcData.cod_pro,
  Quantity,
  ApplicationDocItem.werks


union select from /accgo/t_uisevnt               as EventDetails

  left outer join /accgo/t_cas_cai               as ApplicationDocItem on  ApplicationDocItem.uis_guid = EventDetails.parent_key
                                                                       and ApplicationDocItem.shd_type = 'ZA'

  inner join      ZADOA_GRAINS_EDC_INVOICES_QUAN as InvoicesQuantity   on  InvoicesQuantity.EdcNum      = ApplicationDocItem.uis_id
                                                                       and InvoicesQuantity.EdcQuantity is not initial

  left outer join ztbacm_edc_nfe                 as EdcData            on EdcData.edc = ApplicationDocItem.uis_id

  left outer join ZADOA_GRAINS_PENDING_APPL_PROP as PendingQuantity    on  PendingQuantity.ContractNum = EventDetails.tc_id
                                                                       and PendingQuantity.Property    = EdcData.cod_pro
                                                                       and PendingQuantity.Plant       = ApplicationDocItem.werks
                                                                       and PendingQuantity.IdRoyalties = 'X'

  left outer join ZADOA_GRAINS_RETURNED_QUANTITY as ReturnedQuantity   on ReturnedQuantity.Edc = ApplicationDocItem.uis_id

{
  key    EventDetails.tc_id                                    as ContractNum,
  key    EdcData.cod_pro                                       as Property,
  key    ApplicationDocItem.werks                              as Plant,
         sum( case when  EventDetails.nfqty is initial
         then EventDetails.laqty else EventDetails.nfqty end ) as Quantity,
         sum(InvoicesQuantity.EdcQuantity)                     as InvoicesQuantity,
         sum(ReturnedQuantity.ReturnedQuantity)                as ReturnedQuantity,
         PendingQuantity.Quantity                              as PendingQuantity,
         'X'                                                   as Transgenic
}

where
  (
        EventDetails./accgo/royalties_id <> 'TNI'
    and EventDetails./accgo/royalties_id <> 'TCV'
    and EventDetails./accgo/royalties_id is not initial
  )

group by
  EventDetails.tc_id,
  EdcData.cod_pro,
  Quantity,
  ApplicationDocItem.werks
