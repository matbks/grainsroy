@AbapCatalog.sqlViewName: 'ZADOIGRAINSCF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Obter contratos fixos'
define view ZADOI_GRAINS_CONTRACT_FIX
  as select from    wbhk                as ContractHeader


    inner join      I_TrdgContrTypeDesc as ContractTypeDescr on  ContractHeader.tctyp       = ContractTypeDescr.TrdgContrReferenceDocumentType
                                                             and ContractTypeDescr.Language = $session.system_language


{
  key ContractHeader.tkonn as TradingContractNumber,
      ContractHeader.tctyp as TradingContractType,
      ContractTypeDescr.TradingContractTypeName

}

where
  TradingContractTypeName like '%FIXO%'
