@AbapCatalog.sqlViewName: 'ZADOIGRAINSCAH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Histórico de Aprovação de Contratos'
define view ZADOI_GRAINS_CONTR_APPROV_HIST
  as select from C_ChangeDocuments

  association [0..1] to user_addr                   as _User                on  $projection.CreatedByUser = _User.bname

  association [0..1] to I_TradingContractStatusDesc as _NewStatusDescr      on  $projection.NewStatus    = _NewStatusDescr.ContractStatus
                                                                            and _NewStatusDescr.Language = $session.system_language

  association [0..1] to I_TradingContractStatusDesc as _PreviousStatusDescr on  $projection.PreviousStatus    = _PreviousStatusDescr.ContractStatus
                                                                            and _PreviousStatusDescr.Language = $session.system_language

{
  key cast(left(ChangeDocObject,10) as tkonn)                                 as TradingContractNumber,

  key cast(
        cast( case DatabaseTable
                when 'ZADOT_GRAINS_FIX' then right(ChangeDocTableKey,3) else '0' end
             as abap.numc( 3 ))
           as zadode_grains_origin_fix)                                       as IdentificationFix,


  key ChangeDocument,

      cast( case DatabaseTable
              when 'ZADOT_GRAINS_FIX' then 'Fixação' else 'Contrato' end
            as zadode_grains_approval_type)                                   as Type,

      right(ChangeDocObject,22)                                               as Guid,

      CreatedByUser,
      NAME_TEXTC                                                              as CreatedByUserName,
      concat(substring(_User.name_first,1,1), substring(_User.name_last,1,1)) as AuthorInitials,

      ChangeDocNewFieldValue                                                  as NewStatus,
      ChangeDocPreviousFieldValue                                             as PreviousStatus,


      cast(CreatedOn as timestamp)                                            as CreatedOn,


      case DatabaseTable
        when 'ZADOT_GRAINS_FIX' then
            case
              when ChangeDocNewFieldValue = 'T' and ChangeDocPreviousFieldValue = 'U' then '014'  // Fixação autorizada
              when ChangeDocNewFieldValue = 'U' and ChangeDocPreviousFieldValue = 'T' then '004'  // Autorização estornada.
              when ChangeDocNewFieldValue = 'S' and ChangeDocPreviousFieldValue = 'U' then '015'  // Fixação cancelada
              when ChangeDocNewFieldValue = 'S' and ChangeDocPreviousFieldValue = 'T' then '016'  // Fixação autorizada, e posteriormente cancelada
              when ChangeDocNewFieldValue = 'U' and ChangeDocPreviousFieldValue = 'S' then '006'  // Cancelamento estornado.
              when ChangeDocNewFieldValue = 'T' and ChangeDocPreviousFieldValue = 'S' then '006'  // Cancelamento estornado.
              else ''
            end
         else
            case
              when ChangeDocNewFieldValue = 'T' and ChangeDocPreviousFieldValue = 'U' then '002'  // Contrato autorizado
              when ChangeDocNewFieldValue = 'U' and ChangeDocPreviousFieldValue = 'T' then '004'  // Autorização estornada.
              when ChangeDocNewFieldValue = 'S' and ChangeDocPreviousFieldValue = 'S' then '003'  // Contrato cancelado.
              when ChangeDocNewFieldValue = 'S' and ChangeDocPreviousFieldValue = 'T' then '005'  // Contrato autorizado, e posteriormente cancelado.
              when ChangeDocNewFieldValue = 'U' and ChangeDocPreviousFieldValue = 'S' then '006'  // Cancelamento estornado.
              when ChangeDocNewFieldValue = 'T' and ChangeDocPreviousFieldValue = 'S' then '006'  // Cancelamento estornado.
              else ''
            end
         end                                                                  as MessageNumber,


      // Associations
      _NewStatusDescr,
      _PreviousStatusDescr

}

where
  (
    (
          ChangeDocObjectClass        = 'WBHK'
      and ChangeDocDatabaseTableField = 'BTBSTA'
      and DatabaseTable               = 'WBHK'
    )
    or(
          ChangeDocObjectClass        = 'ZADOCDGRAINSFIX'
      and ChangeDocDatabaseTableField = 'STATUS'
      and DatabaseTable               = 'ZADOT_GRAINS_FIX'
    )
  )



  and(
          ChangeDocNewFieldValue      = 'U'
    or    ChangeDocNewFieldValue      = 'T'
    or    ChangeDocNewFieldValue      = 'S'
  )
  and(
          ChangeDocPreviousFieldValue = 'U'
    or    ChangeDocPreviousFieldValue = 'T'
    or    ChangeDocPreviousFieldValue = 'S'
  )
