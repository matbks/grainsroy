@AbapCatalog.sqlViewName: 'ZADOIGRAINSTAXES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Busca Taxas das Fixações'
define view ZADOI_GRAINS_TAXES_FIXATIONS
  as select from wbhk             as ContractHeader

    inner join   zadot_grains_fix as Fixations          on ContractHeader.tkonn = Fixations.contractnum

    inner join   bseg             as AccountingDocument on  Fixations.accounting_document = AccountingDocument.belnr
                                                        and Fixations.company_code        = ContractHeader.company_code

    inner join   with_item        as Taxes              on  AccountingDocument.belnr = Taxes.belnr
                                                        and AccountingDocument.bukrs = Taxes.bukrs
                                                        and AccountingDocument.qsskz = Taxes.witht

{
  Fixations.company_code       as CompanyCode,
  Fixations.plant              as Plant,
  ContractHeader.tctyp         as ContractType,
  ContractHeader.tkonn         as Contract,
  AccountingDocument.belnr     as AccountingDocument,
  Taxes.wt_qbshh               as Taxe,
  Taxes.witht                  as TaxeCategory,
  Fixations.identification_fix as IdentificationFixation,
  Fixations.fixation_id        as FixationId
}
