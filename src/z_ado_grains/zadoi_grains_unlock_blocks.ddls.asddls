@AbapCatalog.sqlViewName: 'ZADOIGRAINSUB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Desbloqueios do parceiro'
define view ZADOI_GRAINS_UNLOCK_BLOCKS
  as select from zadot_grains_017 as UnlockBlocks
{

  key block_number as BlockNumber,
  key created_at   as CreatedAt,
      created_by   as CreatedBy,
      unlocked_at  as UnlockedAt,
      ref_doc      as RefDoc,
      reason       as Reason,
      status       as Status,
      quantity     as Quantity
}
 