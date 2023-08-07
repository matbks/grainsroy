@AbapCatalog.sqlViewName: 'ZADOIGRAINSBALQM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Link Balanca QM'
define view ZADOI_GRAINS_BALANCA_QM

  as select from zado_balancat012
{
  key LPAD( cast( ticket as char11 ), 11, '0' ) as Ticket,
  key bukrs                                     as Bukrs,
  key werks                                     as Werks,
  key werks_destino                             as WerksDestino,
  key vorglfnr                                  as Vorglfnr,
  key merknr                                    as Merknr,
  key zaehl                                     as Zaehl,
      charact_id1                               as CharactId1,
      mittelwert                                as Mittelwert,
      codegruppe                                as Codegruppe,
      code                                      as Code,
      mbewertg                                  as Mbewertg,
      waehrung                                  as Waehrung,
      fkosten                                   as Fkosten,
      prueflos                                  as Prueflos,
      pruefbemkt                                as Pruefbemkt,
      codegruppe_du                             as CodegruppeDu,
      code_du                                   as CodeDu,
      mbewertg_du                               as MbewertgDu,
      waehrung_du                               as WaehrungDu,
      fkosten_du                                as FkostenDu,
      code_du_description                       as CodeDuDescription,
      matnr_downgrade                           as MatnrDowngrade,
      observacao                                as Observacao,
      royalties                                 as Royalties,
      tabela_referencia                         as TabelaReferencia
}
