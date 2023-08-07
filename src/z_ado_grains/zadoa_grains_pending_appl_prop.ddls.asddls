@AbapCatalog.sqlViewName: 'ZADOAGRAINSPPROP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Saldos de fixações pendentes por propriedade'
define view ZADOA_GRAINS_PENDING_APPL_PROP
  as select from zadot_grains_app as ApplicationsProperty
    inner join   zadot_grains_fix as FixationHeader on  FixationHeader.contractnum        = ApplicationsProperty.contractnum
                                                    and FixationHeader.identification_fix = ApplicationsProperty.identification_fix
                                                    and FixationHeader.plant              = ApplicationsProperty.plant

{
  key   ApplicationsProperty.contractnum   as ContractNum,
  key   ApplicationsProperty.property      as Property,
  key   FixationHeader.plant               as Plant,
        ''                                 as IdRoyalties,
        sum(ApplicationsProperty.quantity) as Quantity
}

where
       FixationHeader.eliminated <> 'X'
  and(
       FixationHeader.transgenic =  'TNI'
    or FixationHeader.transgenic =  'TCV'
    or FixationHeader.transgenic is initial
  )

group by
  ApplicationsProperty.contractnum,
  ApplicationsProperty.property,
  FixationHeader.plant

union select from zadot_grains_app as ApplicationsProperty
  inner join      zadot_grains_fix as FixationHeader on  FixationHeader.contractnum        = ApplicationsProperty.contractnum
                                                     and FixationHeader.identification_fix = ApplicationsProperty.identification_fix
                                                     and FixationHeader.plant              = ApplicationsProperty.plant

{
  key   ApplicationsProperty.contractnum   as ContractNum,
  key   ApplicationsProperty.property      as Property,
  key   FixationHeader.plant               as Plant,
        'X'                                as IdRoyalties,
        sum(ApplicationsProperty.quantity) as Quantity
}

where
        FixationHeader.eliminated <> 'X'
  and(
        FixationHeader.transgenic <> 'TNI'
    and FixationHeader.transgenic <> 'TCV'
  )
  and   FixationHeader.transgenic is not initial

group by
  ApplicationsProperty.contractnum,
  ApplicationsProperty.property,
  FixationHeader.plant
