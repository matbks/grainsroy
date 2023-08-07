@AbapCatalog.sqlViewName: 'ZADOCGRAINSBPROP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Saldos de aplicações por propriedade'
define view ZADOC_GRAINS_BALANCES_PROPERTY
  as select from    but050                         as Property

    left outer join ZADOA_GRAINS_BALANCES_PROPERTY as BalanceProperty on BalanceProperty.Property = Property.partner2

    left outer join I_BusinessPartner              as PartnerName     on PartnerName.BusinessPartner = Property.partner1

    left outer join I_BusinessPartner              as PropertyName    on PropertyName.BusinessPartner = Property.partner2

{
  key    Property.partner1                                                   as Partner,
  key    BalanceProperty.ContractNum                                         as ContractNum,
  key    Property.partner2                                                   as Property,
  key    BalanceProperty.Transgenic                                          as IdRoyalties,
  key    BalanceProperty.Plant                                               as Plant,
         PartnerName.PersonFullName                                          as PartnerName,
         PropertyName.BusinessPartnerSalutation                              as PropertyName,

         cast('KG' as abap.unit( 2 ) )                                       as Unit,
         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         BalanceProperty.Quantity                                            as Quantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         BalanceProperty.InvoicesQuantity                                    as InvoicesQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         BalanceProperty.PendingQuantity                                     as PendingQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         cast( case
               when BalanceProperty.PendingQuantity > 0 and BalanceProperty.ReturnedQuantity > 0
                then BalanceProperty.Quantity - ( BalanceProperty.PendingQuantity + BalanceProperty.ReturnedQuantity )

               when BalanceProperty.PendingQuantity > 0
                then BalanceProperty.Quantity - BalanceProperty.PendingQuantity

               when BalanceProperty.ReturnedQuantity > 0
                then BalanceProperty.Quantity - BalanceProperty.ReturnedQuantity

               else BalanceProperty.Quantity end as zadode_grains_quantity ) as AvailableQuantity
}
where
       Property.reltyp                  = 'TM0002'
  and  BalanceProperty.InvoicesQuantity is not initial
  and(
       BalanceProperty.PendingQuantity  is null
    or BalanceProperty.PendingQuantity  < BalanceProperty.Quantity
  )


union select from ZADOA_GRAINS_BALANCES_PROPERTY as BalanceProperty

  left outer join itrdgcontrpart                 as TradingContractPartnerDetails on  TradingContractPartnerDetails.tradingcontractnumber = BalanceProperty.ContractNum
                                                                                  and TradingContractPartnerDetails.partnerfunction       = 'LF'

{
  key    TradingContractPartnerDetails.partner                               as Partner,
  key    BalanceProperty.ContractNum                                         as ContractNum,
  key    ''                                                                  as Property,
  key    BalanceProperty.Transgenic                                          as IdRoyalties,
  key    BalanceProperty.Plant                                               as Plant,
         TradingContractPartnerDetails.businesspartnername1                  as PartnerName,
         ''                                                                  as PropertyName,

         cast('KG' as abap.unit( 2 ) )                                       as Unit,
         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         BalanceProperty.Quantity                                            as Quantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         BalanceProperty.InvoicesQuantity                                    as InvoicesQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         BalanceProperty.PendingQuantity                                     as PendingQuantity,

         @Semantics.quantity: {unitOfMeasure: 'Unit'}
         cast( case
               when BalanceProperty.PendingQuantity > 0 and BalanceProperty.ReturnedQuantity > 0
                then BalanceProperty.Quantity - ( BalanceProperty.PendingQuantity + BalanceProperty.ReturnedQuantity )

               when BalanceProperty.PendingQuantity > 0
                then BalanceProperty.Quantity - BalanceProperty.PendingQuantity

               when BalanceProperty.ReturnedQuantity > 0
                then BalanceProperty.Quantity - BalanceProperty.ReturnedQuantity

               else BalanceProperty.Quantity end as zadode_grains_quantity ) as AvailableQuantity
}
where
       BalanceProperty.InvoicesQuantity is not initial
  and(
       BalanceProperty.Property         is null
    or BalanceProperty.Property         is initial
  )
  and(
       BalanceProperty.PendingQuantity  is null
    or BalanceProperty.PendingQuantity  < BalanceProperty.Quantity
  )
