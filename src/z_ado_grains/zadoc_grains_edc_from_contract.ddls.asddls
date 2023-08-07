@AbapCatalog.sqlViewName: 'ZADOCGRAINSCTEDC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - EDCs do contrato'
define view ZADOC_GRAINS_EDC_FROM_CONTRACT
  as select from    /accgo/t_uisevnt               as EventDetails

    left outer join /accgo/t_cas_cai               as ApplicationDocItem   on  ApplicationDocItem.uis_guid = EventDetails.parent_key
                                                                           and ApplicationDocItem.shd_type = 'ZA'

    left outer join ztbacm_edc_docs                as EDCdocs              on  EDCdocs.tkonn  = EventDetails.tc_id
                                                                           and EDCdocs.uis_id = ApplicationDocItem.uis_id

    left outer join ztbacm_edc_nfe                 as EdcData              on EdcData.edc = ApplicationDocItem.uis_id

    left outer join I_BusinessPartner              as PartnerName          on PartnerName.BusinessPartner = EDCdocs.cod_pro

    left outer join makt                           as MaterialDescription  on  MaterialDescription.matnr = ApplicationDocItem.matnr
                                                                           and MaterialDescription.spras = $session.system_language

    left outer join ZADOA_GRAINS_PENDING_APPL      as ConsumedApplications on  ConsumedApplications.ContractNum = EventDetails.tc_id
                                                                           and ConsumedApplications.EdcNum      = ApplicationDocItem.uis_id

    left outer join ZADOC_GRAINS_ROYALTIES_BLOCK   as RoyaltiesBlock       on RoyaltiesBlock.EdcNum = ApplicationDocItem.uis_id

    left outer join ZADOA_GRAINS_EDC_INVOICES_QUAN as InvoicesQuantity     on InvoicesQuantity.EdcNum = ApplicationDocItem.uis_id

    left outer join ZADOC_GRAINS_EDC_INVOICE       as EdcInvoice           on EdcInvoice.EdcNum = ApplicationDocItem.uis_id

    left outer join ZADOA_GRAINS_RETURNED_QUANTITY as ReturnedQuantity     on ReturnedQuantity.Edc = ApplicationDocItem.uis_id

  association [1..1] to ZADOC_GRAINS_ROYALTIES_BLOCK as _RoyaltiesBlocks on _RoyaltiesBlocks.EdcNum = ApplicationDocItem.uis_id

{
  key    EventDetails.tc_id                                                         as ContractNum,

  key    ApplicationDocItem.appldoc                                                 as ApplicationDocNum,

  key    ApplicationDocItem.uis_id                                                  as EdcNum,

         ApplicationDocItem.uis_type                                                as EdcType,

         ApplicationDocItem.werks                                                   as Plant,

         case when EdcData.cod_pro is null then '' else  EdcData.cod_pro end        as Property,

         EdcInvoice.NfeNum                                                          as NfeNum,

         @Semantics.quantity.unitOfMeasure: 'Unit'
         InvoicesQuantity.EdcQuantity                                               as NfeQuantity,

         PartnerName.PersonFullName                                                 as PropertyName,

         ApplicationDocItem.matnr                                                   as Material,

         MaterialDescription.maktx                                                  as MaterialDescription,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         cast( ApplicationDocItem.adjusted_qty_dec  as zadode_grains_quantity)      as ApplicationQuantity,

         ApplicationDocItem.created_by                                              as CreatedBy,

         ApplicationDocItem.created_on                                              as CreatedOn,

         ApplicationDocItem.changed_by                                              as ChangedBy,

         ApplicationDocItem.changed_on                                              as ChangedOn,

         EventDetails./accgo/royalties_id                                           as IdRoyalties,

         case when EventDetails./accgo/royalties_id = 'TNI'
         or EventDetails./accgo/royalties_id        = 'TCV'
         or EventDetails./accgo/royalties_id is initial
         then '' else 'X' end                                                       as Transgenic,

         ReturnedQuantity.ReturnedQuantity                                          as ReturnedQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         cast(
            case
            when ConsumedApplications.Quantity > 0 and ReturnedQuantity.ReturnedQuantity > 0
                then ApplicationDocItem.delv_qty_menge_g - (ConsumedApplications.Quantity + ReturnedQuantity.ReturnedQuantity)
            when ConsumedApplications.Quantity > 0
                then ApplicationDocItem.delv_qty_menge_g - ConsumedApplications.Quantity
            when ReturnedQuantity.ReturnedQuantity > 0
                then ApplicationDocItem.delv_qty_menge_g - ReturnedQuantity.ReturnedQuantity

            else ApplicationDocItem.delv_qty_menge_g end as zadode_grains_quantity) as AvailableQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         cast(
            case
            when ConsumedApplications.Quantity > 0 and ReturnedQuantity.ReturnedQuantity > 0
                then ApplicationDocItem.delv_qty_menge_g - (ConsumedApplications.Quantity + ReturnedQuantity.ReturnedQuantity)
            when ConsumedApplications.Quantity > 0
                then ApplicationDocItem.delv_qty_menge_g - ConsumedApplications.Quantity
            when ReturnedQuantity.ReturnedQuantity > 0
                then ApplicationDocItem.delv_qty_menge_g - ReturnedQuantity.ReturnedQuantity

            else ApplicationDocItem.delv_qty_menge_g end as zadode_grains_quantity) as FinalQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         cast( RoyaltiesBlock.BlockedQuantity as  zadode_grains_quantity)           as BlockedQuantity,

         cast('KG' as abap.unit( 2 ) )                                              as Unit,

         //associations
         _RoyaltiesBlocks

}
where
  ApplicationDocItem.adjusted_qty_dec is not initial
