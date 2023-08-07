@AbapCatalog.sqlViewName: 'ZADOGCREDBLOCKD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Baixas de bloqueio de crédito'
define view ZADOA_GRAINS_CREDIT_BLOCK_D
  as select from zadot_grains_017 
{

  key block_number as BlockNumber,
      created_at   as CreatedAt,
      created_by   as CreatedBy,
      created_on   as CreatedOn,
      unlocked_at  as UnlockedAt,
      ref_doc      as RefDoc,
      reason       as Reason,
//     cast( case when status = '2' then 'Baixa Parcial' 
//           when status = '1' then 'Baixa Total' 
//           else '' end as zadode_grains_status) as Status ,
      quantity     as Quantity 
     
}
where operation = '1'
