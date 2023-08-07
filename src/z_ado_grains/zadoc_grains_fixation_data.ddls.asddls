@AbapCatalog.sqlViewName: 'ZADOCGRAINSFIXDT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Dados de fixação'
define view ZADOC_GRAINS_FIXATION_DATA
  as select from    zadot_grains_fix           as FixationData

    left outer join t001k                      as CompanyData         on CompanyData.bwkey = FixationData.plant

    left outer join zadot_grains_014           as CommodityData       on  CommodityData.company_code = CompanyData.bukrs
                                                                      and CommodityData.commodity    = FixationData.materialnum
                                                                      and CommodityData.app_code     = 'ACMCONTROL'

    left outer join zadot_grains_015           as PlaceData           on  PlaceData.company_code = CompanyData.bukrs
                                                                      and PlaceData.app_code     = 'ACMCONTROL'
                                                                      and PlaceData.plant        = FixationData.plant

    left outer join ZADOC_GRAINS_APPL_INVOICES as ApplicationInvoices on  ApplicationInvoices.SettlementDoc  = FixationData.settlement_doc
                                                                      and ApplicationInvoices.GroupYear      = FixationData.settlement_year
                                                                      and ApplicationInvoices.InvoiceDocType = 'SD'
{
  key FixationData.contractnum             as ContractNum,
  key FixationData.identification_fix      as IdentificationFix,
      CompanyData.bukrs                    as CompanyCode,
      FixationData.plant                   as Plant,
      FixationData.material                as Material,
      FixationData.materialnum             as MaterialNum,
      FixationData.transgenic              as Transgenic,
      @EndUserText.label: 'Quantidade'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      FixationData.quantity                as Quantity,
      FixationData.unit                    as Unit,
      @Semantics.amount.currencyCode: 'Currency'
      FixationData.amount                  as Amount,
      @Semantics.amount.currencyCode: 'Currency'
      FixationData.bagprice                as Bagprice,
      @Semantics.amount.currencyCode: 'DolarCurrency'
      FixationData.basis_price             as BasisPrice,
      @Semantics.amount.currencyCode: 'DolarCurrency'
      FixationData.future_price            as FuturePrice,
      @Semantics.amount.currencyCode: 'DolarCurrency'
      FixationData.dolar_quotation         as DolarQuotation,
      cast( 'USD' as /accgo/e_trade_curr ) as DolarCurrency,
      FixationData.keydate_code            as KeydateCode,
      FixationData.payment_date            as PaymentDate,
      FixationData.createdby               as CreatedBy,
      FixationData.createdon               as CreatedOn,
      FixationData.currency                as Currency,
      FixationData.property                as Property,
      FixationData.status                  as Status,
      FixationData.eliminated              as Eliminated,
      FixationData.blocked_quantity        as BlockedQuantity,
      CommodityData.commodity_id           as CommodityId,
      PlaceData.mic                        as Mic,
      FixationData.settlement_doc          as SettlementDoc,
      FixationData.settlement_year         as SettlementYear,
      FixationData.invoice_doc             as InvoiceDoc,
      FixationData.invoice_doc_year        as InvoiceDocYear,
      FixationData.invoice_post_manually   as InvoicePostManually,
      FixationData.settlement_group_id     as SettlementGroupId,
      ApplicationInvoices.DocNum           as DocNum,
      ApplicationInvoices.SupplierInvoice  as SupplierInvoice,
      ApplicationInvoices.BR_NotaFiscal,
      ApplicationInvoices.AbdNumber
}
