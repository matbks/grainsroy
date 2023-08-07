@AbapCatalog.sqlViewName: 'ZADOGRAINSBATI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Link Balanca Ticket'
define view ZADOI_GRAINS_BALANCA_TICKET

  as select from zado_balancat040
{
  key LPAD( cast( ticket as char11 ), 11, '0' ) as Ticket,
  key bukrs                                     as Bukrs,
  key werks                                     as Werks,
  key werks_destino                             as WerksDestino,
      status                                    as Status,
      cod_portaria                              as CodPortaria,
      processo                                  as Processo,
      tp_processo                               as TpProcesso,
      safra                                     as Safra,
      tipo_veiculo                              as TipoVeiculo,
      motorista                                 as Motorista,
      placa                                     as Placa,
      ebeln                                     as Ebeln,
      ebelp                                     as Ebelp,
      ebeln_c                                   as EbelnC,
      ebelp_c                                   as EbelpC,
      nfenum                                    as Nfenum,
      series                                    as Series,
      prueflos                                  as Prueflos,
      vbeln                                     as Vbeln,
      posnr                                     as Posnr,
      tkonn                                     as Tkonn,
      tposn                                     as Tposn,
      vbeln_vl                                  as VbelnVl,
      posnr_vl                                  as PosnrVl,
      matnr                                     as Matnr,
      meins                                     as Meins,
      LPAD( RIGHT( partner, 10 ), 10, '0' )     as Partner,
      recebedor                                 as Recebedor,
      peso_tara                                 as PesoTara,
      peso_liquido                              as PesoLiquido,
      peso_bruto                                as PesoBruto,
      desconto                                  as Desconto,
      un_medida                                 as UnMedida,
      cultura                                   as Cultura,
      estorno                                   as Estorno,
      updated_at                                as UpdatedAt,
      updated_by                                as UpdatedBy,
      obs                                       as Obs,
      log                                       as Log,
      lgort                                     as Lgort,
      transportadora                            as Transportadora,
      propriedade                               as Propriedade,
      created_at                                as CreatedAt,
      created_by                                as CreatedBy,
      local_entrega                             as LocalEntrega,
      local_retirada                            as LocalRetirada,
      vbeln_c                                   as VbelnC,
      posnr_c                                   as PosnrC,
      campo_origem                              as CampoOrigem,
      aufnr                                     as Aufnr,
      barcaca                                   as Barcaca,
      mblnr                                     as Mblnr,
      ticket_transferencia                      as TicketTransferencia,
      werks_transferencia                       as WerksTransferencia,
      werks_nf                                  as WerksNf,
      nr_romaneio                               as Romaneio,
      acckey                                    as Acckey
}