@AbapCatalog.sqlViewName: 'ZADOGSRETIDO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Saldo Retido'
define view ZADOC_GRAINS_SALDO_RETIDO 

as select from wbhd
inner join wbhi on wbhd.tkonn = wbhd.tkonn
inner join zadogcredblock as creditBlocks on creditBlocks.product = wbhi.matnr
                                         and creditBlocks.originpartner = wbhd.elifn
{

wbhd.tkonn as Contract,
wbhd.elifn as Vendor,
wbhi.matnr as Material,
creditBlocks.balance
    
}
