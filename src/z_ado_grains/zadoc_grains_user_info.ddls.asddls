@AbapCatalog.sqlViewName: 'ZADOCGRAINSUI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - User Info'
define view ZADOC_GRAINS_USER_INFO
  as select from user_addr
{
  key bname as Username,
      name_textc
}
