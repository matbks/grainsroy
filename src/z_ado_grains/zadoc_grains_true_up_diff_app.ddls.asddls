@AbapCatalog.sqlViewName: 'ZADOCGRAINSTUDA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Diferenças Quant NF x Quant Física'
define view ZADOC_GRAINS_TRUE_UP_DIFF_APP
  as select from    ZADOTF_GRAINS_TRUE_UP_DIFF_APP( p_clnt: $session.client ) as TrueUpApplication

    left outer join dd07t                                                     as ApplicationDiffStatusDescr on  TrueUpApplication.ApplicationDiffStatus = ApplicationDiffStatusDescr.domvalue_l
                                                                                                            and ApplicationDiffStatusDescr.domname      = '/ACCGO/D_BR_DIFF_STATUS'
                                                                                                            and ApplicationDiffStatusDescr.ddlanguage   = $session.system_language
                                                                                                            and ApplicationDiffStatusDescr.as4local     = 'A'

  association [0..*] to ZADOI_GRAINS_TRUE_UP_SUBS_DOCS as _SubsequentDocs on $projection.ApplicationTrueUpGuid = _SubsequentDocs.TrueUpGuid

{
  ApplicationTrueUpGuid,
  ApplicationDoc,
  ApplicationDocItem,
  Side,
  SubItem,
  ApplicationDiffStatus,
  ApplicationDiffStatusDescr.ddtext as ApplicationDiffStatusDescr,
  @Semantics.quantity.unitOfMeasure: 'NfUom'
  NfQuantity,
  NfUom,

  @Semantics.quantity.unitOfMeasure: 'ApplicationUom'
  ApplicationQuantity,
  ApplicationUom,

  @Semantics.quantity.unitOfMeasure: 'NfUom'
  QuantityTrueUpDiff,


  // Associations
  _SubsequentDocs
}
