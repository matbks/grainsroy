@AbapCatalog.sqlViewName: 'ZADOCGRAINSAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Lista de Contrato e Fixações para aprovação'
define view ZADOC_GRAINS_APPROVAL_LIST
  as select from ZADOC_GRAINS_CONTRACT_APPROVAL as ContractApproval

    inner join   ZADOI_GRAINS_SETTINGS_CTR_APR  as Settings on  ContractApproval.CompanyCode         = Settings.CompanyCode
                                                            and ContractApproval.TradingContractType = Settings.TradingContractType
                                                            and Settings.ContractApproval            = 'X'
                                                            and Settings.AppCode                     = 'ACMAPPROVA'

  association [0..*] to ZADOC_GRAINS_CONTR_APPROV_HIST as _StatusChangeLog on  $projection.TradingContractNumber = _StatusChangeLog.TradingContractNumber
                                                                           and $projection.IdentificationFix     = _StatusChangeLog.IdentificationFix
{
  key TradingContractNumber,
  key cast('Contrato' as zadode_grains_approval_type) as Type,
  key cast(0 as zadode_grains_origin_fix)             as IdentificationFix,
      ContractApproval.TradingContractType,
      ContractApproval.TradingContractTypeName,
      ContractStatus                                  as Status,
      ContractStatusText                              as StatusText,
      CreatedOn,
      TradingContractCreatedBy                        as CreatedBy,
      TradingContractCreatedByName                    as CreatedByName,
      ContractApproval.CompanyCode,
      CompanyCodeName,

      Plant                                           as ContractPlant,
      PlantName                                       as ContractPlantName,
      cast('' as werks_d)                             as FixationPlant, 
      cast('' as werks_name)                          as FixationPlantName,

      FirstMaterial,
      ProductHierarchyText,
      Safra, 
      Quantity,
      BaseUnitOfMeasure,
      ContractNetAmount, 
      ContractCurrency,
      Partner,
      PartnerName,
      Approver,
      cast('' as matnr)                               as Material,
      cast('' as /accgo/e_br_royalties_id)            as Trangenic,
      cast(0 as zadode_grains_quantity)               as FixQuantity,
      cast('' as /accgo/e_csl_trade_qty_uom  )        as FixUnit,
      cast(0 as zadode_grains_amount)                 as FixAmount,
      cast(0 as zadode_grains_basis_price)            as FixBasisPrice,
      cast(0 as zadode_grains_future_price)           as FixFuturePrice,
      cast('' as abap.cuky(5) )                       as Currency,
      cast('' as zadode_grains_property  )            as Property,
      cast('' as zadode_grains_block_reason)          as BlockReason,
      cast('' as zadode_grains_block_reason_txt)      as BlockReasonDescr,
      PaymentDate                                     as PaymentDate,
      ContractApproval.FixedContract,

      cast('Contrato ' as abap.char(13))              as Title,


      /* Associations */
      //      _ApprovalHistory,
      _ContractItem,
      _FixingItem,
      _StatusChangeLog
}

union select from ZADOC_GRAINS_FIX_APPROVAL     as FixApproval

  inner join      ZADOI_GRAINS_SETTINGS_CTR_APR as Settings on  FixApproval.CompanyCode         = Settings.CompanyCode
                                                            and FixApproval.TradingContractType = Settings.TradingContractType
                                                            and Settings.FixingApproval         = 'X'
                                                            and Settings.AppCode                = 'ACMAPPROVA'

association [0..*] to ZADOC_GRAINS_CONTR_APPROV_HIST as _StatusChangeLog on  $projection.TradingContractNumber = _StatusChangeLog.TradingContractNumber
                                                                         and $projection.IdentificationFix     = _StatusChangeLog.IdentificationFix

{
  key TradingContractNumber,
  key cast('Fixação' as zadode_grains_approval_type)                                as Type,
  key IdentificationFix,
      FixApproval.TradingContractType,
      FixApproval.TradingContractTypeName,

      FixStatus                                                                     as Status,
      FixStatusText                                                                 as StatusText,

      CreatedOn,
      CreatedBy,
      CreatedByName,
      FixApproval.CompanyCode,
      CompanyCodeName,

      ContractPlant,
      ContractPlantName,
      FixationPlant,
      FixationPlantName,

      FirstMaterial,
      ProductHierarchyText,
      Safra,
      Quantity,
      BaseUnitOfMeasure,
      ContractNetAmount,
      ContractCurrency,
      Partner,
      PartnerName,
      Approver,
      Material,
      Trangenic,
      FixQuantity,
      FixUnit,
      FixAmount,
      FixBasisPrice,
      FixFuturePrice,
      Currency,
      Property,
      BlockReason,
      BlockReasonDescr,
      FixationPaymentDate                                                           as PaymentDate,
      FixApproval.FixedContract,


      concat_with_space('Fixação - ', cast(IdentificationFix as abap.char( 3 )), 1) as Title,




      /* Associations */
      //      _ApprovalHistory,
      _ContractItem,
      _FixingItem,
      _StatusChangeLog
}
