@AbapCatalog.sqlViewName: 'ZADOCGRAINSBK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Dados contas bancárias precificação'
define view ZADOC_GRAINS_PRICING_BANK_DATA
  as select from    but0bk as PartnerBankData

    left outer join bnka   as BankData on  BankData.bankl = PartnerBankData.bankl
                                       and BankData.banks = PartnerBankData.banks
{
  key PartnerBankData.partner                                                                                              as Partner,
  key PartnerBankData.bkvid                                                                                                as BankAccountId,
      PartnerBankData.banks                                                                                                as BankCountry,
      PartnerBankData.bankl                                                                                                as BankId,
      PartnerBankData.bankn                                                                                                as BankAccount,
      PartnerBankData.bkont                                                                                                as BankAccountDigit,
      PartnerBankData.koinh                                                                                                as BankHolder,
      BankData.banka                                                                                                       as Bank,
      BankData.bnklz                                                                                                       as BankAgency,
      BankData.ort01                                                                                                       as BankCity,
      BankData.provz                                                                                                       as BankState,
      tstmp_to_dats(PartnerBankData.bk_valid_from, abap_system_timezone($session.client, 'NULL'), $session.client, 'NULL') as ValidFrom,
      tstmp_to_dats(PartnerBankData.bk_valid_to, abap_system_timezone($session.client, 'NULL'), $session.client, 'NULL')   as ValidTo
}
