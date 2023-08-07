@AbapCatalog.sqlViewName: 'ZADOCGRAINSFBILL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Dados da fatura fixação'
define view ZADOC_GRAINS_FIXATION_BILL
  as select from zadot_grains_bil as Billing
{
  key Billing.contractnum        as ContractNum,
  key Billing.identification_fix as FixationId,
  key Billing.installment        as Installment,
      Billing.plant              as Plant,
      @Semantics.amount.currencyCode: 'Currency'
      Billing.amount             as Amount,
      Billing.currency           as Currency,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      @EndUserText.label: 'Quantidade'
      Billing.quantity           as Quantity,
      Billing.unit               as Unit,
      Billing.bank               as Bank,
      Billing.bankagency         as BankAgency,
      Billing.bankaccount        as BankAccount,
      Billing.bankholder         as BankHolder,
      Billing.paymentdate        as PaymentDate,
      Billing.fixation_id        as SourceFixation
}
