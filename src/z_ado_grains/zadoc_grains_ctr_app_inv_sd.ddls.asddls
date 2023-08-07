@AbapCatalog.sqlViewName: 'ZADOCGRAINSCAIS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Invoices de Débitos subsequentes - Fixação'
define view ZADOC_GRAINS_CTR_APP_INV_SD
  as select distinct from ZADOI_GRAINS_CONTRACT_INVOICES as Invoices

  association [0..*] to ZADOA_GRAINS_ACC_AMOUNT     as _AccAmount          on  $projection.AccountingDocument     = _AccAmount.AccountingDocument
                                                                           and $projection.InvoiceCompanyCode     = _AccAmount.CompanyCode
                                                                           and $projection.AccountingDocumentYear = _AccAmount.AccountingDocumentYear

  association [0..*] to ZADOC_GRAINS_CTR_APP_INV_IV as _InvoiceAplications on  $projection.TradingContract = _InvoiceAplications.TradingContract
                                                                           and $projection.AbdNumber       = _InvoiceAplications.AbdNumber

  association [0..1] to ZI_PARTNERS                 as _Partner            on  $projection.InvoicePartner = _Partner.Partner

  association [0..1] to I_CompanyCode               as _CompanyCode        on  $projection.InvoiceCompanyCode = _CompanyCode.CompanyCode


{
  key TradingContract,
  key AbdNumber,
      TradingContractType,
      TradingContractTypeName,
      SettlementType,
      InvoiceDocType,
      cast(InvoiceCreatedOn as udmo_create_time) as InvoiceCreatedOn,
      SettlementGroupId,
      SettlementGroupYear,

      AccountingDocumentStatus,
      AccountingDocumentCompanyCode,
      AccountingDocumentYear,
      AccountingDocument,

      @Semantics.amount.currencyCode: 'CompanyCurrency'
      _AccAmount.AmountInCompanyCurrency,
      @Semantics.currencyCode: true
      _AccAmount.Currency                        as CompanyCurrency,
      //      AccountingItem,
      //      AmountInCompanyCurrency,
      //      CompanyCurrency,
      AccountingPostingDate,
      InvoiceCompanyCode,
      _CompanyCode.CompanyCodeName,


      InvoicePartner,
      _Partner.PartnerName                       as InvoicePartnerName,

      ClearingDocument,
      ClearingDocumentYear,
      ClearingDate,

      Assignment,
//      ApplicationDoc,

      InvoiceDoc,
      InvoiceDocYear,
      InvoiceReference, 
      FixationId,
      FixationIdFromZTable,
      IdentificationFix,
      //      FixationQuantity,
      //      FixationUom,
      FixationCreatedAt,
      FixationPaymentDate,
      FixationPaymentDays,
      
      @Semantics.quantity.unitOfMeasure: 'FixationUom'
      FixationQuantity, 
      FixationUom,
      


      //      EDC,
      //      Quantity,
      //      Uom,
      //      AvailableQuantity,
      //      FinalQuantity,
      //      BlockedQuantity,
      //      Unit,
      //      Vendor,

      //      SettlementGroupId,
      //      SettlementGroupYear,
      //      InvoiceCompanyCode,
      //      _CompanyCode.CompanyCodeName,
      //      InvoiceDoc,
      //      InvoiceDocYear,
      //      InvoiceDocType,
      //      SettlementType2,
      //      DocType,
      //      Partner,
      //      NetAmount,
      //      GrossAmount,
      //      Currency,

      //      Assignment,
      //      PaymentTerm,
      //      BusinessPlace,
      //      BaseDate,
      //      BankPartnerType,


      // Associations
      _InvoiceAplications
}

where
      Invoices.InvoiceDocType           = 'SD'
  and Invoices.AccountingDocumentStatus is not initial
