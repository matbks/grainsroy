@AbapCatalog.sqlViewName: 'ZADOCGRAINSFA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Aprovação de Fixação'
define view ZADOC_GRAINS_FIX_APPROVAL
  as select from    ZADOC_GRAINS_CONTRACT_APPROVAL as ContractApproval

    inner join      t001w                          as Plants         on ContractApproval.Plant = Plants.werks

    inner join      t001k                          as ValuationArea  on Plants.bwkey = ValuationArea.bwkey

    left outer join ZADOI_GRAINS_CONTR_USER_AUTH   as Authorizations on  Authorizations.Username = $session.user
                                                                     and ContractApproval.Plant  = Authorizations.Plant
                                                                     and ValuationArea.bukrs     = Authorizations.CompanyCode


    inner join      zadot_grains_fix               as Fixations      on ContractApproval.TradingContractNumber = Fixations.contractnum
  //                                                                     and ContractApproval.Plant                 = PreFixations.plant

    left outer join user_addr                      as User           on Fixations.createdby = User.bname


  association [0..1] to dd07t   as _StatusFixation  on  $projection.FixStatus      = _StatusFixation.domvalue_l
                                                    and _StatusFixation.domname    = 'ZADODO_GRAINS_FIX_STATUS'
                                                    and _StatusFixation.as4local   = 'A'
                                                    and _StatusFixation.ddlanguage = $session.system_language

  association [0..1] to dd07t   as _BlockReasonText on  $projection.BlockReason     = _BlockReasonText.domvalue_l
                                                    and _BlockReasonText.domname    = 'ZADODO_GRAINS_BLOCK_REASON'
                                                    and _BlockReasonText.as4local   = 'A'
                                                    and _BlockReasonText.ddlanguage = $session.system_language

  association [0..1] to I_Plant as _FixationPlant   on  $projection.FixationPlant = _FixationPlant.Plant


{

  key TradingContractNumber,
  key identification_fix                                              as IdentificationFix,
      ContractApproval.TradingContractType,
      ContractApproval.TradingContractTypeName,
      ContractStatus,
      ContractStatusText,

      Fixations.createdon                                             as CreatedOn,
      Fixations.createdby                                             as CreatedBy,
      User.name_textc                                                 as CreatedByName,

      ContractApproval.CompanyCode,
      CompanyCodeName,
      ContractApproval.Plant                                          as ContractPlant,
      ContractApproval.PlantName                                      as ContractPlantName,

      Fixations.plant                                                 as FixationPlant,
      _FixationPlant.PlantName                                        as FixationPlantName,
      PlantName,
      FirstMaterial,
      ProductHierarchyText,
      Safra,
      ContractApproval.Quantity,
      BaseUnitOfMeasure,
      ContractNetAmount,
      ContractCurrency,
      Partner,
      PartnerName,
      Authorizations.FixApprover                                      as Approver,
      /* Associations */
      //      _ApprovalHistory,
      _ContractItem,
      _FixingItem,

      Fixations.material                                              as Material,
      Fixations.transgenic                                            as Trangenic,
      Fixations.quantity                                              as FixQuantity,
      Fixations.unit                                                  as FixUnit,
      Fixations.amount                                                as FixAmount,
      Fixations.basis_price                                           as FixBasisPrice,
      Fixations.future_price                                          as FixFuturePrice,
      Fixations.currency                                              as Currency,
      Fixations.property                                              as Property,
      Fixations.block_reason                                          as BlockReason,
      Fixations.payment_date                                          as FixationPaymentDate,
      cast(_BlockReasonText.ddtext as zadode_grains_block_reason_txt) as BlockReasonDescr,

      @ObjectModel.text.element: ['FixStatusText']
      Fixations.status                                                as FixStatus,
      @Semantics.text: true
      _StatusFixation.ddtext                                          as FixStatusText,

      cast( case
              when ContractApproval.TradingContractTypeName like '%FIXO%'
                then 'X'
                else ''
              end as zadode_grains_fixed_contract)                    as FixedContract

}

//where
//  Fixations.eliminated <> 'X'
