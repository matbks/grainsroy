@AbapCatalog.sqlViewName: 'ZADOTRCRB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Transgenia'
define view ZADOC_GRAINS_TRANSGENIA
  as select from zadot_grains_tra as Transgenia
    inner join   zadot_grains_mat as Products on  Products.app_code     = Transgenia.app_code
                                              and Products.company_code = Transgenia.company_code
                                              and Products.transgenia   = Transgenia.transgenia

{
  key Transgenia.transgenia_descr as Transgenia,
  key Transgenia.transgenia_id    as TransgeniaId,
  key Products.material           as Material,
      Products.company_code       as Company

}
