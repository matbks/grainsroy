@AbapCatalog.sqlViewName: 'ZADOCGRAINSCAH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Histórico de Aprovação de Contratos'
define view ZADOC_GRAINS_CONTR_APPROV_HIST
  as select from    ZADOI_GRAINS_CONTR_APPROV_HIST as LogList

    left outer join t100                           as Messages on  LogList.MessageNumber = Messages.msgnr
                                                               and Messages.sprsl        = $session.system_language
                                                               and Messages.arbgb        = 'ZADO_GRAINS'


{


  key LogList.TradingContractNumber,
  key LogList.IdentificationFix,
  key LogList.ChangeDocument,
      Type,
      Guid,
      @ObjectModel.text.element: ['CreatedByUserName']
      CreatedByUser,
      @Semantics.text: true
      CreatedByUserName,
      AuthorInitials,

      @ObjectModel.text.element: ['NewStatusDescr']
      NewStatus,
      @Semantics.text: true
      LogList._NewStatusDescr.TrdgContrApplStsName      as NewStatusDescr,

      @ObjectModel.text.element: ['PreviousStatusDescr']
      PreviousStatus,
      @Semantics.text: true
      LogList._PreviousStatusDescr.TrdgContrApplStsName as PreviousStatusDescr,

      @Semantics.systemDateTime.createdAt: true
      CreatedOn,

      case MessageNumber
        when '002' then 'Low'
        when '014' then 'Low'
        when '004' then 'Medium'
        when '003' then 'High'
        when '015' then 'High'
        when '005' then 'High'
        when '016' then 'High'
        when '006' then 'Medium'
      end                                               as Priority,


      MessageNumber,
      Messages.text                                     as StepDescription
}
