@AbapCatalog.sqlViewName: 'ZADOCGRAINSTXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Get Text from Contract'
define view ZADOC_GRAINS_TXT
  as select from zadot_grains_txt
{
  key cast(guid as abap.char( 22 )) as Guid,
      plant                         as Plant,
      contractnum                   as Contractnum,
      identification_fix            as IdentificationFix,
      type                          as Type,
      created_by                    as CreatedBy,
      created_on                    as CreatedOn,
      text                          as Text
}
