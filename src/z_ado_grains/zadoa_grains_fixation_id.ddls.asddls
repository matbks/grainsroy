@AbapCatalog.sqlViewName: 'ZADOAGRAINSFID'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Id fixação'
define view ZADOA_GRAINS_FIXATION_ID
  as select from zadot_grains_fix
{
  key contractnum               as ContractNum,
      max( identification_fix ) as Identification_Fix
}
group by
  contractnum
