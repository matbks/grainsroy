@AbapCatalog.sqlViewName: 'ZADOCSEEDSCNTFIX'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Fixações do contrato'
define view ZADOC_GRAINS_CNTRACT_FIXATIONS

  as select from    ZADOC_GRAINS_CONTRACT_DETAILS as ContractDetails

    left outer join zadot_grains_fix              as ContractFixations on ContractFixations.contractnum = ContractDetails.ContractNum

    left outer join /accgo/t_stlhead              as SettlementHeader  on  ContractFixations.settlement_doc  = SettlementHeader.settl_doc
                                                                       and ContractFixations.settlement_year = SettlementHeader.settl_yr


  association [0..*] to ZADOC_GRAINS_CONSUMED_APPL     as _ConsApplications on  $projection.ContractNum    = _ConsApplications.ContractNum
                                                                            and $projection.FixationId     = _ConsApplications.FixationId
                                                                            and _ConsApplications.Quantity is not initial

  association [0..*] to ZADOC_GRAINS_FIXATION_BILL     as _Billing          on  $projection.ContractNum = _Billing.ContractNum
                                                                            and $projection.FixationId  = _Billing.FixationId

  association [0..*] to ZADOC_GRAINS_FIXATION_DATA     as _FixationData     on  $projection.ContractNum = _FixationData.ContractNum
                                                                            and $projection.FixationId  = _FixationData.IdentificationFix

  association [0..*] to ZADOC_GRAINS_BALANCES_PROPERTY as _BalanceProperty  on  $projection.ContractNum = _BalanceProperty.ContractNum

  association [0..*] to ZADOC_GRAINS_PARTNER_BLOCKS    as _PartnerBlocks    on  $projection.Partner = _PartnerBlocks.OriginPartner

{
  key ContractDetails.ContractNum                                  as ContractNum,

  key ContractFixations.identification_fix                         as FixationId,

      ContractFixations.plant                                      as Plant,

      @EndUserText.label: 'Tipo contrato'
      ContractDetails.TradingContractTypeDescription               as ContractTypeDescription,

      @ObjectModel.text.element: ['CompanyCodeName']
      ContractDetails.CompanyCode                                  as CompanyCode,

      @EndUserText.label: 'Empresa'
      ContractDetails.CompanyCodeName                              as CompanyCodeName,

      @ObjectModel.text.element: ['ProductName']
      ContractDetails.Partner,
      ContractDetails.PartnerName                                  as PartnerName,

      @EndUserText.label: 'Status'
      ContractFixations.status                                     as FixationStatus,

      ContractDetails.CompanyLocation                              as CompanyLocation,

      @EndUserText.label: 'Commodity'
      ContractDetails.Material                                     as Material,

      @EndUserText.label: 'Descrição status'
      case ContractFixations.status
        when 'U' then 'Em aprovação'
        when 'T' then 'Autorizado'
        when 'S' then 'Reprovado'
        when 'L' then 'Liquidado'
        when 'F' then 'Fat. comp. registrada'
        when 'C' then 'Compensado'
      else 'Esboço' end                                            as FixationStatusDescription,

      @Semantics.amount.currencyCode: 'Currency'
      cast( ContractFixations.amount as zadode_grains_amount )     as FixationAmount,

      ContractFixations.currency                                   as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label: 'Preço saca'
      cast( ContractFixations.bagprice as zadode_grains_amount )   as BagPrice,

      ContractFixations.property                                   as Property,

      @EndUserText.label: 'Quantidade'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      cast( ContractFixations.quantity as zadode_grains_quantity ) as FixationQuantity,

      @EndUserText.label: 'UMB'
      ContractFixations.unit                                       as Unit,

      @EndUserText.label: 'Transgenia'
      ContractFixations.transgenic                                 as Trangenic,

      ContractFixations.eliminated                                 as Eliminated,

      @EndUserText.label: 'Criação'
      ContractFixations.createdon                                  as CreatedOn,

      ContractFixations.settlement_doc                             as SettlementDoc,

      ContractFixations.settlement_group_id                        as SettlementGroupId,

      ContractFixations.settlement_year                            as SettlementDocYear,

      SettlementHeader.wbeln                                       as AbdNumber,

      ContractFixations.invoice_doc                                as InvoiceDoc,
      ContractFixations.invoice_doc_year                           as InvoiceDocYear,
      ContractFixations.invoice_post_manually                      as InvoicePostManually,


      //associations

      _ConsApplications,
      _Billing,
      _FixationData,
      _BalanceProperty,
      _PartnerBlocks

}
where
  ContractFixations.identification_fix is not initial
