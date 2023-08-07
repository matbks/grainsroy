@AbapCatalog.sqlViewName: 'ZADOGRAINSCRB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Saldo de baixas - bloqueio de crédito'
define view ZADOI_GRAINS_CREDIT_BLOCK_D

  as select from zadot_grains_016              as CreditBlocks
    inner join   ZADOA_GRAINS_CREDIT_BLOCK_DIS as DischargeBalance on CreditBlocks.block_number = DischargeBalance.BlockNumber
{
  key CreditBlocks.block_number, 
      CreditBlocks.contract,
      cast( CreditBlocks.quantity - DischargeBalance.DischargeQuantity as zadode_grains_balance ) as Balance
}
