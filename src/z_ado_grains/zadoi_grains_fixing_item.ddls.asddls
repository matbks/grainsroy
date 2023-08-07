@AbapCatalog.sqlViewName: 'ZADOIGRAINSFI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Graisn - Fixação'
define view ZADOI_GRAINS_FIXING_ITEM
  as select from zadot_grains_fix
{
  key plant                                   as Plant,
  key contractnum                             as ContractNum,
  key identification_fix                      as IdentificationFix,
      material                                as Material,
      transgenic                              as Transgenic,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity                                as Quantity,

      @Semantics.unitOfMeasure: true
      unit                                    as Unit,

      @EndUserText.label: 'Montante'
      cast(amount as abap.dec( 14, 4 ))       as Amount,


      @EndUserText: {
          label: 'Prç. Saca',
          quickInfo: 'Preço da Saca'
      }
      cast(bagprice as abap.dec( 10, 4 ))     as Bagprice,

      @EndUserText: {
      label: 'Prç. Basis',
      quickInfo: 'Preço Basis'
      }
      cast(basis_price as abap.dec( 8, 4 ))  as BasisPrice,

      @EndUserText: {
      label: 'Prç. Futuro',
      quickInfo: 'Preço Futuro'
      }
      cast(future_price as abap.dec( 8, 4 )) as FuturePrice,

      currency                                as Currency,
      property                                as Property,
      status                                  as Status
}
