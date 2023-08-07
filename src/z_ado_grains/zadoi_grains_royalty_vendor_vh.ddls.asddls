@AbapCatalog.sqlViewName: 'ZADOIGRAINSVHRV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Grains - Value Help - Fornecedores Royalties'
define view ZADOI_GRAINS_ROYALTY_VENDOR_VH
  as select distinct from /accgo/t_br_roya as RoyaltiesConfig
    inner join            I_Supplier       as Supplier on RoyaltiesConfig.vendor = Supplier.Supplier

{
  key vendor                as Vendor,
      Supplier.SupplierName as VendorName
}
