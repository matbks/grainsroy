@AbapCatalog.sqlViewName: 'ZADOCGRAINSMBH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Comportamentos do monitor'
define view ZADOC_GRAINS_MON_BEHAVIOR
  as select from zadot_grains_013 as MonitorBehavior
{
  key company_code         as CompanyCode,
  key app_code             as AppCode,
  key contract_type        as ContractType,
      create_fixation      as CreateFixation,
      show_fixation        as ShowFixation,
      show_invoices        as ShowInvoices,
      show_sales_barter    as ShowSalesBarter,
      show_adjusts         as ShowAdjusts,
      showconsumedquantity as ShowConsumedQuantity,
      showamount           as ShowAmount,
      active               as Active
}
where
  active is not initial
