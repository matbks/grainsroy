@AbapCatalog.sqlViewName: 'ZADOCGRAINSPAPP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Saldos de fixações pendentes'
define view ZADOA_GRAINS_PENDING_APPL
  as select from zadot_grains_app as PendentAppl
    inner join   zadot_grains_fix as FixationHeader on  FixationHeader.contractnum     = PendentAppl.contractnum
                                                    and FixationHeader.identification_fix = PendentAppl.identification_fix
{
  key   PendentAppl.contractnum     as ContractNum,
  key   edcnum          as EdcNum,
  key   measure         as Measure,
        sum( PendentAppl.quantity ) as Quantity
}

where 
    FixationHeader.eliminated <> 'X'

group by
  PendentAppl.contractnum,
  edcnum,
  measure
