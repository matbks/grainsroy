@AbapCatalog.sqlViewName: 'ZADOROYALLOG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Registro de transações de consula e baixa de credito'
define view ZADOC_ROYALTIES_LOG
  as select from zadot_royal_log
{

  key plant            as Plant,
  key romaneio         as Romaneio,
  key edc_number       as EdcNumber,
      //  key case when creation_date is initial then '00000000' else creation_date end as creation_date,
  key created_on       as CreatedOn,
      discharge        as Discharge,
      fiscal_year      as FiscalYear,
      balance          as Balance,
      discharge_status as DischargeStatus,
      protocol         as Protocol
}

where
  operation = '1'
