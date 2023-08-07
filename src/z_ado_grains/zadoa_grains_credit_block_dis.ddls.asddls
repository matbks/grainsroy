@AbapCatalog.sqlViewName: 'ZADOGRAINCBD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Saldo de baixas do bloqueio de crédito'
define view ZADOA_GRAINS_CREDIT_BLOCK_DIS 

as select from zadot_grains_017
{
    max( block_number ) as BlockNumber,
    sum( quantity ) as DischargeQuantity
}
where operation =    '1'
group by block_number


