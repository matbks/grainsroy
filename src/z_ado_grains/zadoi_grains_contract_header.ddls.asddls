@AbapCatalog.sqlViewName: 'ZADOIGRAINSCTH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Cabeçalhos de Contratos de ACM'
define view ZADOI_GRAINS_CONTRACT_HEADER
  as select from    wbhk as ContractHeader

  //    left outer join wbhk                      as ContractHeaderBase   on ContractHeader.TradingContractNumber = ContractHeaderBase.tkonn

    left outer join wbhd as ContractBusinessData on  ContractHeader.tkonn           = ContractBusinessData.tkonn
                                                 and ContractBusinessData.tposn     = '000000'
                                                 and ContractBusinessData.tposn_sub = '000000'

  association [0..*] to ZADOI_GRAINS_CONTRACT_ITEMS  as _ContractFirstItem on  $projection.TradingContractNumber = _ContractFirstItem.TradingContractNumber

  association [0..1] to I_TradingContractStatusDesc  as _ContractStatus    on  $projection.ContractStatus = _ContractStatus.ContractStatus
                                                                           and _ContractStatus.Language   = $session.system_language

  association [0..1] to I_TrdgContrTypeDesc          as _ContractTypeDesc  on  $projection.TradingContractType = _ContractTypeDesc.TrdgContrReferenceDocumentType
                                                                           and _ContractTypeDesc.Language      = $session.system_language

  association [0..1] to I_CompanyCode                as _CompanyCode       on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [0..1] to I_Plant                      as _Plant             on  $projection.Plant = _Plant.Plant

  association [0..1] to ZADOA_GRAINS_SUM_ITEMS_QUANT as _SumContractQuant  on  $projection.TradingContractNumber = _SumContractQuant.TradingContractNumber

  association [0..1] to I_Customer                   as _Customer          on  $projection.Customer = _Customer.Customer
  association [0..1] to I_Supplier                   as _Supplier          on  $projection.Supplier = _Supplier.Supplier

  association [0..1] to I_CreatedByUser              as _ContractCreatedBy on  $projection.TradingContractCreatedBy = _ContractCreatedBy.UserName
{

  key ContractHeader.tkonn                                   as TradingContractNumber,
      ContractHeader.tctyp                                   as TradingContractType,
      ContractHeader.btbsta                                  as ContractStatus,


      cast(dats_tims_to_tstmp( ContractHeader.erdat,
                               ContractHeader.erzeit,
                               abap_system_timezone( $session.client,'NULL' ),
                               $session.client,
                               'NULL' ) as udmo_create_time) as CreatedOn,


      ContractHeader.ernam                                   as TradingContractCreatedBy,
      _ContractCreatedBy.UserDescription                     as TradingContractCreatedByName,
      ContractHeader.company_code                            as CompanyCode,
      _ContractFirstItem.ContractPlant                       as Plant,

      _ContractFirstItem.TradingContractItem                 as FirstItem,
      _ContractFirstItem.TrdgContrCommoditySubitem           as FirstSubItem,
      _ContractFirstItem.ContractMaterial                    as FirstMaterial,
      ContractHeader.zzsafra                                 as Safra,

      @Semantics.amount.currencyCode: 'ContractCurrency'
      ContractHeader.netwr_sd                                as ContractNetAmount,

      @Semantics.currencyCode: true
      ContractHeader.tkwaers                                 as ContractCurrency,


      ContractHeader.kunnr                                   as Customer,
      ContractBusinessData.elifn                             as Supplier,

      cast(
        case
          when ContractHeader.kunnr is not initial
            then ContractHeader.kunnr
            else ContractBusinessData.elifn
            end
        as bu_partner )                                      as Partner,

      case
        when ContractHeader.kunnr is not initial
          then _Customer.CustomerName
          else _Supplier.SupplierName
        end                                                  as PartnerName,


      ContractHeader.zzdata_pagto                            as PaymentDate,



      //Associations
      _ContractStatus,
      _ContractTypeDesc,
      _CompanyCode,
      _Plant,
      _ContractFirstItem,
      _SumContractQuant
}
