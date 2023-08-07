@AbapCatalog.sqlViewName: 'ZADOIGRAINSFFB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Primeira parcela da Fixação'
define view ZADOI_GRAINS_FIRST_FIX_BIL
  as select from zadot_grains_bil
{
  key plant                                               as Plant,
  key contractnum                                         as Contractnum,
  key identification_fix                                  as IdentificationFix,
      cast(min(installment) as zadode_grains_installment) as Installment

}

group by
  plant,
  contractnum,
  identification_fix
