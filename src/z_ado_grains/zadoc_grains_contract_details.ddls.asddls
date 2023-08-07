@AbapCatalog.sqlViewName: 'ZADOCSEEDSCDT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey:true
@AccessControl.authorizationCheck:  #CHECK
@ClientHandling.type: #INHERITED
@ClientHandling.algorithm: #SESSION_VARIABLE
@VDM.viewType: #BASIC
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@EndUserText.label: 'ACM Contract Details'
@Metadata.ignorePropagatedAnnotations:true
@ObjectModel.representativeKey: 'ContractNum'

define view ZADOC_GRAINS_CONTRACT_DETAILS
  as select from    wbhk                         as ContractHeader

    inner join      wbhi                         as ContractItem                 on ContractHeader.tkonn = ContractItem.tkonn

    inner join      zadot_grains_003             as ContractTypes                on  ContractTypes.contract_type = ContractHeader.tctyp
                                                                                 and ContractTypes.app_code      = 'ACMCONTROL'
                                                                                 and ContractTypes.company_code  = ContractHeader.company_code

    left outer join itrdgcontrpart               as ContractSupplier             on  ContractSupplier.tradingcontractnumber = ContractHeader.tkonn
                                                                                 and ContractSupplier.partnerfunction       = 'LF'

    left outer join itrdgcontrpart               as ContractCustomer             on  ContractCustomer.tradingcontractnumber = ContractHeader.tkonn
                                                                                 and ContractCustomer.partnerfunction       = 'AG'

    left outer join tb2bet                       as ContractTypeDescription      on  ContractTypeDescription.tctyp = ContractHeader.tctyp
                                                                                 and ContractTypeDescription.spras = 'P'

    left outer join pcontrheader                 as ContractHeaderAdditionData   on ContractHeaderAdditionData.tradingcontractnumber = ContractHeader.tkonn


    left outer join ZADOA_GRAINS_FIXATION_ID     as FixationId                   on FixationId.ContractNum = ContractHeader.tkonn

    left outer join I_TrdgContrItemShadowQtyData as ShadowQuantiy                on  ShadowQuantiy.ContractNum  = ContractHeader.tkonn
                                                                                 and ShadowQuantiy.ContractItem = ContractItem.tposn

    left outer join ZADOA_GRAINS_PART_BLOCK_QUAN as PartnerContractBlockQuantity on  PartnerContractBlockQuantity.OriginPartner = ContractSupplier.partner
                                                                                 and PartnerContractBlockQuantity.Contract      = ContractHeader.tkonn

    left outer join ZADOA_GRAINS_PART_BLOCK_QUAN as PartnerBlockQuantitySup      on  PartnerBlockQuantitySup.OriginPartner = ContractSupplier.partner
                                                                                 and PartnerBlockQuantitySup.Contract      is initial

    left outer join ZADOA_GRAINS_CONT_APP_QUAN   as ContractApplicationQuantity  on ContractApplicationQuantity.ContractNum = ContractHeader.tkonn

  association [0..1] to I_CompanyCode                  as _Company              on  $projection.CompanyCode = _Company.CompanyCode

  association [0..*] to ZADOC_GRAINS_CNTRACT_FIXATIONS as _Fixations            on  $projection.ContractNum = _Fixations.ContractNum

  association [0..*] to ZADOC_GRAINS_EDC_FROM_CONTRACT as _Applications         on  $projection.ContractNum = _Applications.ContractNum

  association [0..*] to ZADOC_GRAINS_INVOICES          as _Nfs                  on  $projection.ContractNum = _Nfs.ContractNum

  association [0..*] to ZADOC_GRAINS_APPL_INVOICES     as _AppInvoices          on  $projection.ContractNum     = _AppInvoices.Contract
                                                                                and _AppInvoices.InvoiceDocType = 'IV'
                                                                                and _AppInvoices.Reversed is initial

  association [0..*] to ZADOC_GRAINS_APPL_INVOICES     as _FixInvoices          on  $projection.ContractNum     = _FixInvoices.Contract
                                                                                and _FixInvoices.InvoiceDocType = 'SD'
                                                                                and _FixInvoices.Reversed is initial

  association [0..*] to ZADOC_GRAINS_SALES_APP_BILLING as _SalesAppBilling      on  $projection.ContractNum         = _SalesAppBilling.Contract
                                                                                and _SalesAppBilling.BillingDocType = 'M'

  association [0..*] to ZADOC_GRAINS_SALES_APP_BILLING as _SalesFixBilling      on  $projection.ContractNum         = _SalesFixBilling.Contract
                                                                                and _SalesFixBilling.BillingDocType = 'P'

  association [1..*] to ZADOI_GRAINS_CONTRACT_ITEMS    as _CommodityItemDetails on  $projection.ContractNum = _CommodityItemDetails.TradingContractNumber

  association [0..*] to ZADOC_GRAINS_BALANCES_PROPERTY as _BalanceProperty      on  $projection.ContractNum = _BalanceProperty.ContractNum

  association [0..*] to ZADOC_GRAINS_CUSTOMER_OPEN_ACC as _CustOpenAcc          on  $projection.ContractNum = _CustOpenAcc.Contract

  association [0..*] to ZADOC_GRAINS_PARTNER_BLOCKS    as _PartnerBlocks        on  $projection.Partner = _PartnerBlocks.OriginPartner

  association [0..*] to ZADOC_GRAINS_ROYALTIES_BLOCK   as _RoyaltiesBlocks      on  $projection.ContractNum = _RoyaltiesBlocks.ContractNum

  //  association [0..*] to ZADOC_GRAINS_BALANCES_TO_SALES as _BalancesToSales      on $projection.ContractNum = _BalancesToSales.ContractNum

  association [0..*] to ZADOA_GRAINS_SALES_APPL        as _ApplicationsToSales  on  $projection.ContractNum = _ApplicationsToSales.ContractNum


{
  key ContractHeader.tkonn                                                               as ContractNum,

  key ContractItem.tposn                                                                 as ContractItem,

      ContractHeader.tctyp                                                               as TradingContractType,

      @EndUserText.label: 'Descrição Tipo'
      ContractTypeDescription.bezei                                                      as TradingContractTypeDescription,

      ContractHeader.btbsta                                                              as ContractStatus,

      @EndUserText.label: 'Descrição Status'
      ContractHeaderAdditionData.bezei                                                   as ContractStatusText,

      ContractHeader.ernam                                                               as TradingContractCreatedBy,

      @EndUserText.label: 'Nome criador'
      ContractHeaderAdditionData.createdby                                               as ContractCreatedByName,

      ContractHeader.erdat                                                               as TradingContractCreatedOn,

      ContractHeader.aenam                                                               as TradingContractChangedBy,

      @EndUserText.label: 'Nome modificador'
      ContractHeaderAdditionData.changedby                                               as ContractChangedByName,

      ContractHeader.aedat                                                               as TradingContractChangedOn,

      ContractHeader.vkorg                                                               as SalesOrganization,

      ContractItem.werks                                                                 as Plant,

      ContractHeader.vtweg                                                               as DistributionChannel,

      ContractHeader.spart                                                               as Division,

      @ObjectModel.text.element: ['CompanyCodeName']
      ContractHeader.company_code                                                        as CompanyCode,

      _Company.CompanyCodeName,

      _Company.CityName                                                                  as CompanyLocation,

      _Company.Country                                                                   as CompanyCountry,

      @Semantics.amount: { currencyCode: 'Currency' }
      ContractHeader.netwr_sd                                                            as Amount,

      ContractHeader.sdwrs                                                               as Currency,

      ContractHeader.zzsafra                                                             as Safra,

      case dats_is_valid(ContractHeader.zzdata_pagto)
      when 1 then ContractHeader.zzdata_pagto end                                        as PaymentDate,

      ContractItem.matnr                                                                 as MaterialNum,

      ContractItem.arktx                                                                 as Material,

      ContractItem.lgort                                                                 as WareHouse,

      @EndUserText.label: 'Qtd.Contrato'
      case when ContractItem.menge is initial
      then cast( ContractItem.kwmeng as zadode_grains_quantity ) else
      cast( ContractItem.menge as zadode_grains_quantity  ) end                          as Quantity,
      @EndUserText.label: 'UMB'

      ContractItem.meins                                                                 as Measure,

      @EndUserText.label: 'Quantidade inicial contrato'
      @Semantics.quantity.unitOfMeasure: 'Measure'
      cast(ShadowQuantiy.TradingContractItemQuantity as zadode_grains_quantity )         as InitialQuantity,

      @EndUserText.label: 'Quantidade consumida'
      @Semantics.quantity.unitOfMeasure: 'Measure'
      cast(ShadowQuantiy.ContractItemConsumedQuantity as zadode_grains_quantity )        as ConsumedFixQuantiy,

      @EndUserText.label: 'Percentual consumido'
      case when ShadowQuantiy.TradingContractItemQuantity > 0 then
      division(ShadowQuantiy.ContractItemConsumedQuantity * 100,
      ShadowQuantiy.TradingContractItemQuantity, 2) else
      division(ShadowQuantiy.ContractItemConsumedQuantity * 100,
      1, 2)   end                                                                        as AvailablePercentValue,

      @EndUserText.label: 'Quantidade entregue parceiro'
      @Semantics.quantity.unitOfMeasure: 'Measure'
      cast(ContractApplicationQuantity.AvailableQuantity     as zadode_grains_quantity ) as ApplicationQuantity,

      @EndUserText.label: 'Cód. Parceiro'
      case when ContractSupplier.partner is null
      then ContractCustomer.partner
      else ContractSupplier.partner end                                                  as Partner,

      @EndUserText.label: 'Nome parceiro'
      case when ContractSupplier.partner is null
      then ContractCustomer.businesspartnername1
      else ContractSupplier.businesspartnername1 end                                     as PartnerName,

      case when ContractSupplier.partner is null
      then ContractCustomer.customersuppliercityname
      else ContractSupplier.customersuppliercityname end                                 as PartnerCity,

      case when ContractSupplier.partner is null
      then ContractCustomer.customersupplierpostalcode
      else ContractSupplier.customersupplierpostalcode end                               as PartnerPostalCode,

      case when ContractSupplier.partner is null
      then ContractCustomer.customersupplierstreetname
      else ContractSupplier.customersupplierstreetname end                               as PartnerStreetNumber,

      @EndUserText.label: 'Intervalo precificações'
      case when FixationId.Identification_Fix is null
      then 1 else FixationId.Identification_Fix + 1 end                                  as IdentificationFix,

      @EndUserText.label: 'Qtd. Bloqueada parceiro'
      @Semantics.quantity.unitOfMeasure: 'Measure'
      case
      when PartnerContractBlockQuantity.BlockQuantity is not null and PartnerBlockQuantitySup.BlockQuantity is not null
        then PartnerBlockQuantitySup.BlockQuantity + PartnerContractBlockQuantity.BlockQuantity
          when PartnerBlockQuantitySup.BlockQuantity is not null
            then PartnerBlockQuantitySup.BlockQuantity
              when PartnerContractBlockQuantity.BlockQuantity is not null
                then PartnerContractBlockQuantity.BlockQuantity
                else 0 end                                                               as PartnerBlockQuantity,

      @EndUserText.label: 'Cat. Contrato'
      substring(ContractHeader.tctyp, 1, 2)                                              as Type,

      //associations

      _Fixations,
      _Applications,
      _Nfs,
      _AppInvoices,
      _CommodityItemDetails,
      _BalanceProperty,
      _CustOpenAcc,
      _PartnerBlocks,
      _RoyaltiesBlocks,
      //      _BalancesToSales,
      _ApplicationsToSales,
      _FixInvoices,
      _SalesFixBilling,
      _SalesAppBilling
}
