@AbapCatalog.sqlViewName: 'ZADOROYALREPO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Relatório de Baixas de Royalties'

define view ZADOC_ROYALTIES_DISCHAR_REPORT

  as select from ZADOC_ROYALTIES_MONITOR as RoyaltiesMonitor
    inner join   ZADOC_ROYALTIES_LOG     as RoyaltiesLog on  RoyaltiesMonitor.EdcNum   = RoyaltiesLog.EdcNumber
                                                              and RoyaltiesMonitor.Romaneio = RoyaltiesLog.Romaneio
//                                                              and RoyaltiesMonitor.Plant    = RoyaltiesLog.Plant
{
  key RoyaltiesMonitor.EdcNum              as EdcNum,
  key RoyaltiesLog.CreatedOn               as CreatedOn,
      RoyaltiesMonitor.ContractNum         as ContractNum,
      RoyaltiesMonitor.ApplicationDocNum   as ApplicationDocNum,
      RoyaltiesMonitor.EdcType             as EdcType,
      RoyaltiesMonitor.Property            as Property,
      RoyaltiesMonitor.Material            as Material,
      RoyaltiesMonitor.MaterialDescription as MaterialDescription,
      RoyaltiesMonitor.ApplicationQuantity as ApplicationQuantity,
      RoyaltiesMonitor.Ticket              as Ticket,
      RoyaltiesMonitor.CreatedBy           as CreatedBy,
      RoyaltiesMonitor.ChangedBy           as ChangedBy,
      RoyaltiesMonitor.ChangedOn           as ChangedOn,
      RoyaltiesMonitor.Romaneio            as Romaneio,
      RoyaltiesMonitor.TicketDate          as TicketDate,
      RoyaltiesMonitor.Partner             as Partner,
      RoyaltiesMonitor.CpfCnpj             as PartnerId,
      RoyaltiesMonitor.PropertyDescription as PropertyDescription,
      RoyaltiesMonitor.PartnerDescription  as PartnerDescription,
      RoyaltiesMonitor.Safra               as Safra,
      RoyaltiesMonitor.Plant               as Plant,
      RoyaltiesMonitor.Transgenia          as Trasngenia,
      RoyaltiesMonitor.Discharges          as Discharges,
      RoyaltiesMonitor.CpfCnpj             as CpfCnpj,
      RoyaltiesLog.Discharge               as Discharge,
      RoyaltiesLog.FiscalYear              as FiscalYear,
      RoyaltiesLog.Balance                 as Balance,
      RoyaltiesLog.DischargeStatus         as DischargeStatus,
      RoyaltiesLog.Protocol                as Protocol
}
