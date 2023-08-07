@AbapCatalog.sqlViewName: 'ZADOCGRAINSCAPP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Documentos de aplicação consumidos por fixação'
define view ZADOC_GRAINS_CONSUMED_APPL
  as select from    zadot_grains_app           as Applications

    left outer join ZADOC_GRAINS_APPL_INVOICES as ApplicationInvoices on  ApplicationInvoices.ApplicationDoc = Applications.apl_doc
                                                                      and ApplicationInvoices.InvoiceDocType = 'IV'

{
  key       Applications.contractnum        as ContractNum,
  key       Applications.identification_fix as FixationId,
  key       Applications.apl_doc            as ApplicationDoc,
  key       Applications.edcnum             as EdcNum,
            Applications.plant              as Plant,
            Applications.property           as Property,
            @Semantics.quantity.unitOfMeasure: 'Unit'
            @EndUserText.label: 'Quantidade'
            Applications.quantity           as Quantity,
            Applications.measure            as Unit
}
