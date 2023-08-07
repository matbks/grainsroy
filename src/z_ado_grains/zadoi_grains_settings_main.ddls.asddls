@AbapCatalog.sqlViewName: 'ZADOIGRAINSSM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Configurações principais dos aplicativos'
define view ZADOI_GRAINS_SETTINGS_MAIN
  as select from zadot_grains_001 as CompanyCodes

    inner join   zadot_grains_002 as Apps on  CompanyCodes.company_code = Apps.company_code
                                          and Apps.active               = 'X'



{

  key CompanyCodes.company_code as CompanyCode,
  key Apps.app_code             as AppCode,
      Apps.app_description      as AppDescription


}

where
  CompanyCodes.active = 'X'
