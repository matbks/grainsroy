@AbapCatalog.sqlViewName: 'ZADOIGRAINSSCA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Configurações Tp. Contrato suj. Aprovação'
define view ZADOI_GRAINS_SETTINGS_CTR_APR
  as select from ZADOI_GRAINS_SETTINGS_MAIN as MainSettings

    inner join   zadot_grains_003           as CtrTypes on  MainSettings.CompanyCode = CtrTypes.company_code
                                                        and MainSettings.AppCode     = CtrTypes.app_code


  association [0..1] to I_TrdgContrTypeDesc as _ContractTypeDesc on  $projection.TradingContractType = _ContractTypeDesc.TrdgContrReferenceDocumentType
                                                                 and _ContractTypeDesc.Language      = $session.system_language

{
  key MainSettings.CompanyCode,
  key MainSettings.AppCode,
  key CtrTypes.contract_type     as TradingContractType,
      AppDescription,
      _ContractTypeDesc.TradingContractTypeName,

      CtrTypes.fixing_approval   as FixingApproval,
      CtrTypes.contract_approval as ContractApproval,

      // Associations
      _ContractTypeDesc
}


where
  CtrTypes.active = 'X'
