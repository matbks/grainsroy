@AbapCatalog.sqlViewName: 'ZADOSFTAXSAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS para buscar dos impostos para o Bol. de Fixação de venda'
define view ZADOC_GRAINS_SF_TAX_SALES
  as select from ZADOC_GRAINS_SF_SALES_NFE_BOL as SalesFinancialData

    inner join   vbrk                          as InvoiceDocHeader on InvoiceDocHeader.vbeln = SalesFinancialData.Vbeln

    inner join   prcd_elements                 as PricingElements  on PricingElements.knumv   = InvoiceDocHeader.knumv

                                                                   and(
                                                                        PricingElements.kschl = 'ZFDM'
                                                                     or PricingElements.kschl = 'ZFDS'
                                                                     or PricingElements.kschl = 'ZCMI'
                                                                     or PricingElements.kschl = 'ZFHB'
                                                                   )

{

  key SalesFinancialData.ContractNum as ContractNum,
  key PricingElements.knumv          as DocCond,
      @Semantics.currencyCode
      PricingElements.waerk          as CurrCode,
      @Semantics.amount.currencyCode: 'CurrCode'
      PricingElements.kwert          as CondValue,
      PricingElements.kschl          as CondType
}
