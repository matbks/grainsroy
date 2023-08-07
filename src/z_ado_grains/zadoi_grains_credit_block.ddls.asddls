@AbapCatalog.sqlViewName: 'ZADOGCREDBLOCK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Bloqueios de crédito'
define view ZADOI_GRAINS_CREDIT_BLOCK

  as select from    zadot_grains_016            as CreditBlocks
  
    left outer join wbhk                        as ContractData        on ContractData.tkonn = CreditBlocks.contract
    
    left outer join t001k                       as CompanyData         on CompanyData.bwkey = ContractData.vkorg

    left outer join mara                        as MaterialDocument    on MaterialDocument.matnr = CreditBlocks.product

    left outer join ZI_PARTNERS                 as OriginPartners      on OriginPartners.Partner = CreditBlocks.origin_partner

    left outer join ZI_PARTNERS                 as DestinationPartners on DestinationPartners.Partner = CreditBlocks.destination_holder

    left outer join ZADOI_GRAINS_CREDIT_BLOCK_D as Balances            on Balances.block_number = CreditBlocks.block_number

  association [0..*] to ZADOA_GRAINS_CREDIT_BLOCK_D as _CreditBlockDischarge on $projection.block_number = _CreditBlockDischarge.BlockNumber

{
  key CreditBlocks.block_number                                 as BlockNumber, 
      emission_date                                             as EmissionDate,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['DestinationDescription']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BusinessPartnerVH', element: 'BusinessPartner' } }]
      CreditBlocks.destination_holder                           as DestinationHolder,
      DestinationPartners.PartnerName                           as DestinationDescription,
      OriginPartners.PartnerName                                as OriginDescription,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['OriginPartner']
      @Consumption: { valueHelpDefinition: [ { entity:  { name: 'ZI_PARTNERS', element: 'Partner' } }] }
      origin_partner                                            as OriginPartner,
      product                                                   as Product,
      block_type                                                as BlockType,
      transgenia                                                as Transgenia,
      @Semantics.quantity.unitOfMeasure : 'Um'
      quantity                                                  as Quantity,
      @Semantics.unitOfMeasure: true
      MaterialDocument.meins                                    as Um,
      observation                                               as Observation,
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZADOC_CREDIT_BLOCK_CONTRACT_VH', element: 'Contract' } }]
      //      LPAD( contract, 10, '0' )                                 as Contract,
      CreditBlocks.contract                                     as Contract,
      safra                                                     as Safra,
      cast( case when Balances.Balance is null then quantity
            else Balances.Balance end as zadode_grains_balance) as Balance,
      //      status                        as Status,
      case when Balances.Balance is null or Balances.Balance = quantity then  'Bloqueio Total'
           when Balances.Balance = 0 then 'Baixa Total'
           else 'Baixa parcial' end                             as Status,
      created_by                                                as CreatedBy,
      created_at                                                as CreatedAt,
      created_on                                                as CreatedOn,
      CompanyData.bukrs                                         as Company,


      _CreditBlockDischarge
}
