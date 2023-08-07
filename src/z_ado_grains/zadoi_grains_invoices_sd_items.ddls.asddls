@AbapCatalog.sqlViewName: 'ZADOIGRAINSISI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Itens da Invoice SD ( Complementos )'
define view ZADOI_GRAINS_INVOICES_SD_ITEMS
  as select from    wb2_d_comsub                   as TradingContractSubItems

    left outer join /accgo/t_stlhead               as SettlementHeader      on  TradingContractSubItems.tkonn = SettlementHeader.tkonn
                                                                            and TradingContractSubItems.tposn = SettlementHeader.tposn

    left outer join /accgo/t_stlitem               as SettlementItem        on  SettlementHeader.stl_header_guid  = SettlementItem.stl_header_guid
                                                                            and TradingContractSubItems.tkonn     = SettlementItem.contract
                                                                            and TradingContractSubItems.tposn     = SettlementItem.contract_item
                                                                            and TradingContractSubItems.tposn_com = SettlementItem.commodity_item

    left outer join ZADOC_GRAINS_EDC_FROM_CONTRACT as EDC                   on  TradingContractSubItems.tkonn = EDC.ContractNum
                                                                            and SettlementItem.appldoc        = EDC.ApplicationDocNum
                                                                            and SettlementItem.uis_id         = EDC.EdcNum


    left outer join ZADOA_GRAINS_APP_CLEARED_QUANT as ClearedQuantity       on  TradingContractSubItems.tkonn = ClearedQuantity.ContractNum
                                                                            and SettlementItem.appldoc        = ClearedQuantity.ApplicationDoc
                                                                            and SettlementItem.appldoc_item   = ClearedQuantity.ApplicationDocItem
  //
  //    left outer join ZADOI_GRAINS_SETTL_LAST_PRICE as SettlementLastPricing on  SettlementItem.stl_item_guid      = SettlementLastPricing.SettlementItemGuid
  //                                                                           and SettlementLastPricing.PriceAspect = 'FBPR'
  //
  //    left outer join /accgo/t_stlprc               as SettlementPricing     on  SettlementLastPricing.SettlementItemGuid = SettlementPricing.stl_item_guid
  //                                                                           and SettlementLastPricing.PriceAspect        = SettlementPricing.pr_aspect


    left outer join /accgo/t_stlctnr               as SettlementContainer   on SettlementHeader.stl_header_guid = SettlementContainer.stl_header_guid

    left outer join /accgo/t_stlinv                as SettlementInvoices    on SettlementContainer.group_guid = SettlementInvoices.group_guid

    left outer join /accgo/t_grp_hdr               as SettlementGroupHeader on SettlementContainer.group_guid = SettlementGroupHeader.guid




  // Fixações

    left outer join ZADOI_GRAINS_SETTL_LAST_PRICE  as LastSettlementPrice   on SettlementItem.stl_item_guid = LastSettlementPrice.SettlementItemGuid


    left outer join /accgo/t_stlprc                as SettlementPrice       on  LastSettlementPrice.SettlementItemGuid = SettlementPrice.stl_item_guid
                                                                            and LastSettlementPrice.PriceCount         = SettlementPrice.pr_count

    left outer join /accgo/t_pr_asp                as PrincingAspects       on  TradingContractSubItems.tkonn     = PrincingAspects.tkonn
                                                                            and TradingContractSubItems.tposn     = PrincingAspects.tposn
                                                                            and TradingContractSubItems.side      = PrincingAspects.side
                                                                            and TradingContractSubItems.tposn_com = PrincingAspects.tposn_com
                                                                            and SettlementPrice.pr_aspect         = PrincingAspects.pr_aspect
                                                                            and SettlementPrice.pr_count          = PrincingAspects.pr_count

    left outer join zadot_grains_fix               as Fixation              on  TradingContractSubItems.tkonn = Fixation.contractnum
                                                                            and PrincingAspects.src_lt_id     = Fixation.fixation_id

  // Fim Fixações

  //    left outer join ZADOI_GRAINS_FIRST_FIX_BIL     as FirstFixationBil      on  Fixation.plant              = FirstFixationBil.Plant
  //                                                                            and Fixation.contractnum        = FirstFixationBil.Contractnum
  //                                                                            and Fixation.identification_fix = FirstFixationBil.IdentificationFix
  //
  //    left outer join zadot_grains_bil               as FixationBil           on  FirstFixationBil.Plant             = FixationBil.plant
  //                                                                            and FirstFixationBil.Contractnum       = FixationBil.contractnum
  //                                                                            and FirstFixationBil.IdentificationFix = FixationBil.identification_fix
  //
  //
  //
  //    left outer join rbkp                           as InvoiceHeader         on  SettlementInvoices.invoice_doc    = InvoiceHeader.belnr
  //                                                                            and SettlementInvoices.invoice_doc_yr = InvoiceHeader.gjahr

  //    left outer join ZADOC_GRAINS_VENDOR_ACC_DOCS   as AccountingDocument    on  InvoiceHeader.bukrs               = AccountingDocument.CompanyCode
  //                                                                            and SettlementInvoices.invoice_doc    = AccountingDocument.InvoiceDocument
  //                                                                            and SettlementInvoices.invoice_doc_yr = AccountingDocument.InvoiceDocumentYear

    left outer join I_ACMTradingContractData       as ContractData          on TradingContractSubItems.tkonn = ContractData.ContractNum

  association [0..1] to I_TrdgContrTypeDesc as _ContractTypeDesc on  $projection.TradingContractType = _ContractTypeDesc.TrdgContrReferenceDocumentType
                                                                 and _ContractTypeDesc.Language      = $session.system_language
{

  key TradingContractSubItems.tkonn                                  as TradingContract,
  key TradingContractSubItems.tposn                                  as TradingContractItem,
  key TradingContractSubItems.side                                   as Side,
  key TradingContractSubItems.tposn_com                              as TradingCommoditySubItem,
  key SettlementHeader.stl_header_guid                               as SettlementHeaderGuid,
  key SettlementItem.stl_item_guid                                   as SettlementItemGuid,
  key SettlementContainer.guid                                       as SettlementContainerGuid,
  key SettlementInvoices.guid                                        as SettlementInvoiceGuid,
  key SettlementGroupHeader.guid                                     as SettlementGroupHeaderGuid,
  key SettlementPrice.pr_count                                       as PriceCount,

      PrincingAspects.src_lt_id                                      as FixationId,
      Fixation.identification_fix                                    as IdentificationFix,

      @Semantics.quantity.unitOfMeasure: 'FixationUom'
      cast(PrincingAspects.tradeqty as zadode_grains_fixation_quant) as FixationQuantity,

      @Semantics.unitOfMeasure: true
      cast(PrincingAspects.tradeuom as zadode_grains_fixation_uom)   as FixationUom,
      Fixation.payment_date                                          as FixationPaymentDate,
      SettlementPrice.pr_date                                        as FixationCreatedAt,

      cast(
        cast(dats_days_between( SettlementPrice.pr_date, Fixation.payment_date ) - 1
          as abap.char( 20 ) )
            as dztage)                                               as FixationPaymentDays,

      ContractData.TradingContractType                               as TradingContractType,
      _ContractTypeDesc.TradingContractTypeName                      as TradingContractTypeName,
      SettlementHeader.settl_cat                                     as SettlementType, 
      SettlementHeader.wbeln                                         as AbdNumber,
      SettlementHeader.posnr                                         as AbdItem,
      SettlementHeader.appldoc                                       as ApplicationDoc,
      SettlementHeader.appldoc_item                                  as ApplicationDocItem,
      SettlementItem.uis_id                                          as EDC,

      @Semantics.quantity.unitOfMeasure: 'Uom'
      SettlementItem.unit_quantity                                   as Quantity,
      @Semantics.unitOfMeasure: true
      SettlementItem.unit_uom                                        as Uom,

      cast(EDC.AvailableQuantity as zadode_grains_available_quant)   as AvailableQuantity,
      cast(EDC.BlockedQuantity as zadode_grains_blocked_quant)       as BlockedQuantity,
      EDC.Unit,


      ClearedQuantity.ClearedQuantity,
      @Semantics.unitOfMeasure: true
      ClearedQuantity.Uom                                            as ClearedUom,

      cast( case
               when ClearedQuantity.ClearedQuantity is null and EDC.AvailableQuantity           is not null then
                 SettlementItem.unit_quantity - EDC.AvailableQuantity

               when EDC.AvailableQuantity           is null and ClearedQuantity.ClearedQuantity is not null then
                 SettlementItem.unit_quantity - ClearedQuantity.ClearedQuantity

               when EDC.AvailableQuantity           is null and ClearedQuantity.ClearedQuantity is null then
                 SettlementItem.unit_quantity

               else SettlementItem.unit_quantity -
                         ClearedQuantity.ClearedQuantity -
                         EDC.AvailableQuantity

               end   as zadode_grains_quant_to_clear )               as QuantityToClear,



      //      SettlementPricing.allocated_qty     as AllocatedQuantity,
      //      SettlementPricing.item_uom          as AllocatedUom,

      SettlementHeader.lifnr                                         as Vendor,
      SettlementHeader.invoicing_party                               as InvoicePartner,
      SettlementInvoices.group_id                                    as SettlementGroupId,
      SettlementInvoices.group_yr                                    as SettlementGroupYear,
//      InvoiceHeader.bukrs                                            as InvoiceCompanyCode,
      SettlementInvoices.invoice_doc                                 as InvoiceDoc,
      SettlementInvoices.invoice_doc_yr                              as InvoiceDocYear,
      SettlementInvoices.created_on                                  as InvoiceCreatedOn,
      SettlementInvoices.doc_type                                    as InvoiceDocType,
      SettlementGroupHeader.settl_type                               as SettlementType2,
      SettlementGroupHeader.doc_cat                                  as DocType,
      SettlementGroupHeader.counter_party                            as Partner,

      @Semantics.amount.currencyCode: 'Currency'
      SettlementItem.net_amount                                      as NetAmount,
      @Semantics.amount.currencyCode: 'Currency'
      SettlementItem.gross_amount                                    as GrossAmount,
      @Semantics.currencyCode: true
      SettlementItem.doc_curr                                        as Currency
      //
      //      AccountingDocument.Status                                      as AccountingDocumentStatus,
      //      AccountingDocument.CompanyCode                                 as AccountingDocumentCompanyCode,
      //      AccountingDocument.AccountingDocumentYear,
      //      AccountingDocument.AccountingDocument,
      //      AccountingDocument.AccountingItem,
      //
      //
      //      @Semantics.amount.currencyCode: 'CompanyCurrency'
      //      cast( case DebitCreditIndicator
      //              when 'H' then AccountingDocument.AmountInCompanyCurrency
      //              when 'S' then AccountingDocument.AmountInCompanyCurrency * -1
      //            end as dmbtrv)                                           as AmountInCompanyCurrency,
      //
      //      @Semantics.currencyCode: true
      //      AccountingDocument.Currency                                    as CompanyCurrency,
      //
      //      AccountingDocument.AccountingPostingDate,
      //      AccountingDocument.Assignment,
      //      AccountingDocument.PaymentTerm,
      //      AccountingDocument.BusinessPlace,
      //      AccountingDocument.BaseDate,
      //      AccountingDocument.BankPartnerType,
      //
      //      AccountingDocument.ClearingDocument,
      //      AccountingDocument.ClearingDocumentYear,
      //      AccountingDocument.ClearingDate



}

where
  SettlementInvoices.doc_type = 'SD'
