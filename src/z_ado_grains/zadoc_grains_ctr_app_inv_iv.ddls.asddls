@AbapCatalog.sqlViewName: 'ZADOCGRAINSCAII'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Invoices de Faturas (Aplicações)'
define view ZADOC_GRAINS_CTR_APP_INV_IV
  as select from ZADOC_GRAINS_CTR_APP_INV_SD    as Settlements

    inner join   ZADOI_GRAINS_INVOICES_SD_ITEMS as SettlementsItems on  Settlements.TradingContract = SettlementsItems.TradingContract
                                                                    and Settlements.AbdNumber       = SettlementsItems.AbdNumber
                                                                    and Settlements.InvoiceDocType  = SettlementsItems.InvoiceDocType



    inner join   ZADOI_GRAINS_CONTRACT_INVOICES as Invoices         on  SettlementsItems.TradingContract    = Invoices.TradingContract
                                                                    and SettlementsItems.ApplicationDoc     = Invoices.ApplicationDoc
                                                                    and SettlementsItems.ApplicationDocItem = Invoices.ApplicationDocItem
                                                                    and Invoices.InvoiceDocType             = 'IV'
  //
  //    left outer join ZADOA_GRAINS_APP_CLEARED_QUANT as ClearedQuantity  on  Invoices.TradingContract    = ClearedQuantity.ContractNum
  //                                                                       and Invoices.ApplicationDoc     = ClearedQuantity.ApplicationDoc
  //                                                                       and Invoices.ApplicationDocItem = ClearedQuantity.ApplicationDocItem


  association [0..1] to ZI_PARTNERS                as _Partner on  $projection.InvoicePartner = _Partner.Partner

  association [0..*] to ZADOI_GRAINS_TREE_ACC_DOCS as _AccTree on  $projection.InvoiceCompanyCode     = _AccTree.CompanyCode
                                                               and $projection.AccountingDocument     = _AccTree.AccountingDocument
                                                               and $projection.AccountingItem         = _AccTree.AccountingItem
                                                               and $projection.AccountingDocumentYear = _AccTree.AccountingDocumentYear




{

      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ { entity:  { name: 'ZI_ACM_CONTRACT_VH', element: 'Contract' } }]
  key Settlements.TradingContract,
  key Settlements.AbdNumber,
  key SettlementsItems.AbdItem,

      @Consumption.valueHelpDefinition: [ { entity:  { name: 'P_TradingContractTypeVH', element: 'tctyp' } }]
      Settlements.TradingContractType                                    as tctyp,
      SettlementsItems.InvoiceDoc                                        as SettlementsInvoice,
      Invoices.ApplicationDoc,
      Invoices.ApplicationDocItem,
      Invoices.AccountingDocumentCompanyCode,
      Invoices.AccountingDocumentYear,
      Invoices.AccountingDocument,
      Invoices.AccountingDocumentStatus,
      Invoices.ClearingDocument,
      Invoices.ClearingDocumentYear,
      Invoices.ClearingDate,
      Invoices.AccountingItem,
      Invoices.SettlementType,
      Invoices.EDC,
      Invoices.Quantity,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasure', element: 'UnitOfMeasure'} }]
      Invoices.Uom                                                       as UnitOfMeasure,
      Invoices.Uom,
      Invoices.AvailableQuantity,
      @Semantics.quantity.unitOfMeasure: 'ClearedUom'
      Invoices.ClearedQuantity,
      @Semantics.unitOfMeasure: true
      Invoices.ClearedUom,
      Invoices.QuantityToClear,
      Invoices.BlockedQuantity,
      Invoices.Unit,
      Invoices.Vendor,
      Invoices.InvoicePartner,
      _Partner.PartnerName                                               as InvoicePartnerName,
      Invoices.SettlementGroupId,
      Invoices.SettlementGroupYear,
      Invoices.InvoiceCompanyCode,
      Invoices.InvoiceCompanyCode                                        as CompanyCode, // alias para navigation
      Invoices.InvoiceDoc,
      Invoices.InvoiceDocYear,
      Invoices.InvoiceReference,
      Invoices.TextItem,
      Invoices.InvoiceDocYear                                            as FiscalYear, // alias para navigation
      cast( Invoices.InvoiceCreatedOn as udmo_create_time)               as InvoiceCreatedOn,
      Invoices.InvoiceDocType,
      Invoices.SettlementType2,
      Invoices.DocType,
      Invoices.Partner,
      Invoices.NetAmount,
      Invoices.GrossAmount,
      Invoices.Currency,

      @Semantics.amount.currencyCode: 'CompanyCurrency'
      Invoices.AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      Invoices.CompanyCurrency,

      @Semantics.amount.currencyCode: 'CompanyCurrency'
      cast(
        cast(
          division(
            Invoices.AmountInCompanyCurrency, Invoices.Quantity, 6) as abap.dec( 16, 6 ) ) *
              Invoices.QuantityToClear as zadode_grains_amount_to_clear) as AmountToClear,

      Invoices.AccountingPostingDate,
      Invoices.Assignment,
      Invoices.PaymentTerm,
      Invoices.BusinessPlace,
      Invoices.BaseDate,
      Invoices.BankPartnerType,

      @Semantics.quantity.unitOfMeasure: 'NfUom'
      Invoices.NfQuantity,
      @Semantics.quantity.unitOfMeasure: 'NfUom'
      Invoices.QuantityTrueUpDiff,
      Invoices.NfUom,
      Invoices.ApplicationDiffStatus,
      Invoices.ApplicationTrueUpGuid,

      @Semantics.quantity.unitOfMeasure: 'FixationUom'
      Invoices.FixationQuantity,
      Invoices.FixationUom,

      // Associations

      _AccTree
}

where
  Invoices.InvoiceDocType = 'IV'
