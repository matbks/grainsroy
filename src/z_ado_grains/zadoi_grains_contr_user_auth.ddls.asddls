@AbapCatalog.sqlViewName: 'ZADOIGRAINSCUA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Controle de Autorizações de Contratos'
define view ZADOI_GRAINS_CONTR_USER_AUTH
  as select from    zadot_grains_008 as Users

    left outer join zadot_grains_010 as Plants    on  Users.company_code = Plants.company_code
                                                  and Users.username     = Plants.username
                                                  and Plants.active      = 'X'

    left outer join zadot_grains_009 as GrpAdmin  on  Users.company_code  = GrpAdmin.company_code
                                                  and Users.username      = GrpAdmin.username
                                                  and GrpAdmin.auth_group = 'ADMIN'
                                                  and GrpAdmin.active     = 'X'

    left outer join I_Plant          as AllPlants on GrpAdmin.active = 'X'

    left outer join zadot_grains_009 as GrpAppFix on  Users.company_code   = GrpAppFix.company_code
                                                  and Users.username       = GrpAppFix.username
                                                  and GrpAppFix.auth_group = 'APPROV_FIX'
                                                  and GrpAppFix.active     = 'X'

    left outer join zadot_grains_009 as GrpAppCtr on  Users.company_code   = GrpAppCtr.company_code
                                                  and Users.username       = GrpAppCtr.username
                                                  and GrpAppCtr.auth_group = 'APPROV_CTR'
                                                  and GrpAppCtr.active     = 'X'

{
  key Users.company_code       as CompanyCode,
  key Users.username           as Username,
  key case
        when AllPlants.Plant is not null
          then AllPlants.Plant  
          else Plants.plant
        end                    as Plant,

      cast(
        case
          when GrpAdmin.auth_group is not null then 'X'
          when GrpAppFix.auth_group is not null then 'X'
        else '' end  as xfeld) as FixApprover,

      cast(
        case
          when GrpAdmin.auth_group is not null then 'X'
          when GrpAppCtr.auth_group is not null then 'X'
        else '' end as xfeld)  as CtrApprover


}

where
  Users.active = 'X'
