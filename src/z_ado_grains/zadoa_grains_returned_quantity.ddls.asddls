@AbapCatalog.sqlViewName: 'ZADOAGRAINSRQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade devolvida da aplicação'
define view ZADOA_GRAINS_RETURNED_QUANTITY
  as select from ZADOTF_GRAINS_RETURNED_QUAN ( p_clnt: $session.client ) as ReturnedQuantity
{
  key ReturnedQuantity.Edc,
      sum(ReturnedQuantity.Quantity) as ReturnedQuantity
}
group by
  ReturnedQuantity.Edc
