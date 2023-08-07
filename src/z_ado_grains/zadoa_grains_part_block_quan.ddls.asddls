@AbapCatalog.sqlViewName: 'ZADOAGRAINSBQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade bloqueada do parceiro'
define view ZADOA_GRAINS_PART_BLOCK_QUAN
  as select from ZADOC_GRAINS_PARTNER_BLOCKS as BlockQuantity
{
  key BlockQuantity.OriginPartner      as OriginPartner,
  key BlockQuantity.Contract           as Contract,
      sum(BlockQuantity.BlockQuantity) as BlockQuantity
}
group by
  OriginPartner,
  Contract
