@AbapCatalog.sqlViewName: 'ZADOIGRAINSNFS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Notas fiscais'
define view ZADOI_GRAINS_NFS

  as select from ZADOA_GRAINS_GET_NF_FIRST_ITEM as NfeInvoiceFirstItem

    inner join   j_1bnfdoc                      as NfHeader on NfHeader.docnum = NfeInvoiceFirstItem.DocNum

    inner join   j_1bnflin                      as NfItem   on NfItem.docnum = NfHeader.docnum

{
  key NfHeader.docnum,
      NfHeader.nftype,
      NfHeader.credat,
      NfHeader.series,
      NfHeader.nfenum,
      NfHeader.natop,
      NfHeader.cancel,
      NfHeader.parid,
      NfItem.cfop,
      NfItem.menge,
      NfItem.nfpri,
      NfItem.nfnett,
      NfItem.refkey,
      NfItem.mwskz,
      NfItem.werks
}

where
  NfHeader.cancel = ''
