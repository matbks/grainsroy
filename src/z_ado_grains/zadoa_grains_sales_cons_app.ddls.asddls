@AbapCatalog.sqlViewName: 'ZADOCGRAINSCSA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Quantidade consumida aplicação vendas '
define view ZADOA_GRAINS_SALES_CONS_APP
  as select from zadot_grains_app as ConsumedAppl
    inner join   zadot_grains_fix as FixationHeader on  FixationHeader.contractnum        = ConsumedAppl.contractnum
                                                    and FixationHeader.identification_fix = ConsumedAppl.identification_fix
{
  key ConsumedAppl.apl_doc        as ApplDoc,
      ConsumedAppl.measure        as Measure,
      sum(ConsumedAppl.quantity ) as ConsumedQuantity

}
where
      FixationHeader.eliminated is initial
  and FixationHeader.status     <> 'S'
group by
  ConsumedAppl.apl_doc,
  ConsumedAppl.measure
