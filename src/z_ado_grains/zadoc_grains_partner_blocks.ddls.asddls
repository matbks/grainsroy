@AbapCatalog.sqlViewName: 'ZADOCGRAINSPB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Bloqueios do parceiro'
define view ZADOC_GRAINS_PARTNER_BLOCKS
  as select from    zadot_grains_016             as Blocks

    left outer join ZADOA_GRAINS_UNLOCK_QUANTITY as UnlockQuantity        on UnlockQuantity.BlockNumber = Blocks.block_number

    left outer join ZI_PARTNERS                  as OriginPartnerName     on OriginPartnerName.Partner = Blocks.origin_partner

    left outer join ZI_PARTNERS                  as DestinationHolderName on DestinationHolderName.Partner = Blocks.destination_holder

  association [0..*] to ZADOI_GRAINS_UNLOCK_BLOCKS as _UnlockBlocks on _UnlockBlocks.BlockNumber = Blocks.block_number

{
  key       Blocks.block_number                                                 as BlockNumber,
  key       Blocks.origin_partner                                               as OriginPartner,
            @EndUserText.label: 'Nome origem'
            OriginPartnerName.PartnerName                                       as OriginPartnerName,
            Blocks.contract                                                     as Contract,           
            Blocks.emission_date                                                as EmissionDate,
            Blocks.destination_holder                                           as DestinationHolder,
            @EndUserText.label: 'Nome destino'
            DestinationHolderName.PartnerName                                   as DestinationDescription,
            Blocks.origin_description                                           as OriginDescription,
            Blocks.product                                                      as Product,
            Blocks.block_type                                                   as BlockType,
            Blocks.transgenia                                                   as Transgenia,
            @EndUserText.label: 'Quantidade'
            @Semantics.quantity.unitOfMeasure: 'Um'
            cast( Blocks.quantity as zadode_grains_quantity )                   as Quantity,
            Blocks.um                                                           as Um,
            Blocks.status                                                       as Status,
            Blocks.observation                                                  as Observation,
            Blocks.safra                                                        as Safra,
            Blocks.balance                                                      as Balance,
            Blocks.created_by                                                   as CreatedBy,
            Blocks.created_at                                                   as CreatedAt,

            @EndUserText.label: 'Qtd. Desbloqueada'
            @Semantics.quantity.unitOfMeasure: 'Um'
            UnlockQuantity.UnlockQuantity                                       as UnlockQuantity,

            @EndUserText.label: 'Qtd. Bloqueada'
            @Semantics.quantity.unitOfMeasure: 'Um'
            cast( case when UnlockQuantity > 0
            then Blocks.quantity - UnlockQuantity
            else Blocks.quantity end               as zadode_grains_quantity  ) as BlockQuantity,

            //associations

            _UnlockBlocks

}
