@AbapCatalog.sqlViewName: 'ZADOGRAINSEDC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'EDC Docs'
define view ZADOI_GRAINS_EDC_DOCS

  as select from ztbacm_edc_docs
{
      //  key LPAD( RIGHT( cast( romaneio as char11 ), 11, '0' ) as Romaneio,
  key LPAD( RIGHT( romaneio, 11 ), 11, '0' )     as Romaneio,
  key uis_id                                     as UisId,
  key tkonn                                      as Tkonn,
      peso_tara                                  as PesoTara,
      peso_bruto                                 as PesoBruto,
      peso_liquido                               as PesoLiquido,
      desconto                                   as Desconto,
      LPAD( cast( cod_pro as char10 ), 10, '0' ) as CodPro,
      uname                                      as Uname,
      data                                       as Data,
      hora                                       as Hora
}
