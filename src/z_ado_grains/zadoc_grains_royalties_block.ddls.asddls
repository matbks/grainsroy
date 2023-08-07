@AbapCatalog.sqlViewName: 'ZADOCGRAINSRB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Bloqueio de Royalties'
define view ZADOC_GRAINS_ROYALTIES_BLOCK
  as select from ZADOC_ROYALTIES_MONITOR as RoyaltiesBlock
{
  key EdcNum                                                     as EdcNum,
      ContractNum                                                as ContractNum,
      ApplicationDocNum                                          as ApplicationDocNum,
      EdcType                                                    as Edctype,
      Property                                                   as Property,
      Material                                                   as Material,
      MaterialDescription                                        as MaterialDescription,
      ApplicationQuantity                                        as ApplicationQuantity,
      CreatedBy                                                  as Createdby,
      CreatedOn                                                  as Createdon,
      ChangedBy                                                  as Changedby,
      ChangedOn                                                  as Changedon,
      Romaneio                                                   as Romaneio,
      TicketDate                                                 as Ticketdate,
      Partner                                                    as Partner,
      CpfCnpj                                                    as Partnerid,
      PropertyDescription                                        as PropertyDescription,
      Safra                                                      as Safra,
      Plant                                                      as Plant,
      Transgenia                                                 as IdRoyalties,
      Discharges                                                 as Discharges,

      @EndUserText.label: 'UMB'
      cast( 'KG' as abap.unit( 2 ) )                             as Unit,

      @EndUserText.label: 'Qtd. Bloqueada'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      cast(RoyaltiesBlock.Discharges as zadode_grains_quantity ) as BlockedQuantity
}
