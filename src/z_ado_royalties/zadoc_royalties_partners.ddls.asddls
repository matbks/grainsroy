@AbapCatalog.sqlViewName: 'ZADOCROYPARTNER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parceiro Ajuda de Pesquisa'
define view ZADOC_ROYALTIES_PARTNERS

  as select distinct from ZADOC_ROYALTIES_MONITOR as royalties
    inner join            zipartners              as partners on partners.partner = royalties.Partner

{
  key partners.partner     as Partner,
      partners.partnername as PartnerDescription,
      partners.cnpj        as Cnpj,
      partners.cpf          as Cpf,
      partners.cnpj_cpf    as CnpjOrCpf

}
