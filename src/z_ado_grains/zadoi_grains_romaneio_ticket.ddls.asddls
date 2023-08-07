@AbapCatalog.sqlViewName: 'ZADOGRAINSROTI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Link Romaneio Ticket Balanca'
define view ZADOI_GRAINS_ROMANEIO_TICKET

  as select from zado_balancat016
{
  key LPAD( cast( romaneio as char11 ), 11, '0' )  as Romaneio,
  key bukrs                                        as Bukrs,
  key werks_destino                                as WerksDestino,
  key werks                                        as Werks,
      LPAD( cast( ticket_id as char11 ), 11, '0' ) as TicketId
}
