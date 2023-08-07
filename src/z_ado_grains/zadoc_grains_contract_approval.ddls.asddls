@AbapCatalog.sqlViewName: 'ZADOCGRAINSCTAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@Search.searchable: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Contratos para aprovação'
define view ZADOC_GRAINS_CONTRACT_APPROVAL
  as select from    ZADOI_GRAINS_CONTRACT_HEADER as ContractHeader


    inner join      t001w                        as Plants         on ContractHeader.Plant = Plants.werks

    inner join      t001k                        as ValuationArea  on Plants.bwkey = ValuationArea.bwkey


    left outer join ZADOI_GRAINS_CONTR_USER_AUTH as Authorizations on  Authorizations.Username = $session.user
                                                                   and ContractHeader.Plant    = Authorizations.Plant
                                                                   and ValuationArea.bukrs     = Authorizations.CompanyCode

  //    inner join   ZADOI_GRAINS_SETTINGS_CTR_APR as Settings on  ContractHeader.CompanyCode         = Settings.CompanyCode
  //                                                           and ContractHeader.TradingContractType = Settings.TradingContractType
  //                                                           and Settings.AppCode =

  association [1..*] to ZADOI_GRAINS_CONTRACT_ITEMS as _ContractItem on $projection.TradingContractNumber = _ContractItem.TradingContractNumber

  association [0..*] to ZADOI_GRAINS_FIXING_ITEM    as _FixingItem   on $projection.TradingContractNumber = _FixingItem.ContractNum


  association [0..1] to I_Product                   as _Product      on $projection.FirstMaterial = _Product.Product

  //  association [0..*] to ZADOC_GRAINS_CONTR_APPROV_HIST as _ApprovalHistory on  $projection.TradingContractNumber = _ApprovalHistory.TradingContractNumber

{
      @Search.defaultSearchElement: true
  key TradingContractNumber,

      @ObjectModel.text.element: ['TradingContractTypeName']
      TradingContractType,
      @Semantics.text: true
      ContractHeader._ContractTypeDesc.TradingContractTypeName,

      @ObjectModel.text.element: ['ContractStatusText']
      ContractHeader.ContractStatus,
      @Semantics.text: true
      ContractHeader._ContractStatus.TrdgContrApplStsName as ContractStatusText,

      @Semantics.systemDateTime.createdAt: true
      CreatedOn,

      @ObjectModel.text.element: ['TradingContractCreatedByName']
      TradingContractCreatedBy,
      @Semantics.text: true
      TradingContractCreatedByName,

      @ObjectModel.text.element: ['CompanyCodeName']
      ContractHeader.CompanyCode,
      @Semantics.text: true
      ContractHeader._CompanyCode.CompanyCodeName,

      @ObjectModel.text.element: ['PlantName']
      ContractHeader.Plant,
      @Semantics.text: true
      ContractHeader._Plant.PlantName,


      ContractHeader.FirstMaterial,

      _Product._ProductHierarchyText[Language = $session.system_language].ProductHierarchyText,
      ContractHeader.Safra,

      @Semantics.quantity.unitOfMeasure: 'BaseUnitOfMeasure'
      ContractHeader._SumContractQuant.Quantity,
      @Semantics.unitOfMeasure: true
      ContractHeader._SumContractQuant.BaseUnitOfMeasure,

      @Semantics.amount.currencyCode: 'ContractCurrency'
      ContractHeader.ContractNetAmount,
      @Semantics.currencyCode: true
      ContractHeader.ContractCurrency,

      @ObjectModel.text.element: ['PartnerName']
      @Consumption: { valueHelpDefinition: [ { entity:  { name: 'I_BusinessPartnerVH', element: 'BusinessPartner' } }] }
      ContractHeader.Partner,
      @Semantics.text: true
      ContractHeader.PartnerName,

      cast( case
              when ContractHeader.PaymentDate = ''
                then '00000000'
                else ContractHeader.PaymentDate
              end as zed_data_pagto)                      as PaymentDate,

      cast( case
              when ContractHeader._ContractTypeDesc.TradingContractTypeName like '%FIXO%'
                then 'X'
                else ''
              end as zadode_grains_fixed_contract)        as FixedContract,


      Authorizations.CtrApprover                          as Approver,

      //Associations
      _ContractItem,
      _FixingItem
      //      _ApprovalHistory

}
