@AbapCatalog.sqlViewName: 'ZADOCGRAINSINVO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório de notas fiscais'
define view ZADOC_GRAINS_INVOICES

  as select from    ZADOI_GRAINS_INVOICES     as Invoices

    inner join      ZADOI_GRAINS_NFS          as Nfs         on Nfs.refkey = Invoices.refkey

    left outer join ZADOI_GRAINS_ADD_INVOICES as AddInvoices on AddInvoices.Contract = Invoices.Contract

    left outer join but000                    as Partner     on Partner.partner = Nfs.parid
{

  key    Invoices.Contract                                   as ContractNum,

  key    Invoices.group_id                                   as GroupId,

  key    Nfs.docnum                                          as DocNum,

         Invoices.group_yr                                   as GroupYear,

         Invoices.invoice_doc                                as InvoiceDoc,

         Invoices.invoice_doc_yr                             as InvoiceDocYear,

         Invoices.doc_type                                   as DocType,

         Invoices.uis_id                                     as UisId,


         Nfs.nftype                                          as NfType,

         Nfs.credat                                          as CreDat,

         Nfs.series                                          as Series,

         Nfs.nfenum                                          as NfeNum,

         Nfs.natop                                           as NaTop,

         Nfs.cfop                                            as CfOp,

         @EndUserText.label: 'UMB'
         cast('KG' as abap.unit( 2 ) )                       as Measure,

         @EndUserText.label: 'Quantidade'
         @Semantics.quantity: {
             unitOfMeasure: 'Measure'
         }
         cast( Nfs.menge        as zadode_grains_quantity  ) as Menge,

         @EndUserText.label: 'Moeda'
         cast('BRL' as abap.cuky( 5 ) )                      as Currency,

         @EndUserText.label: 'Valor liquido unitário'
         @Semantics.amount.currencyCode: 'Currency'
         cast( Nfs.nfpri as abap.curr( 16, 2 ) )             as NfPri,

         @EndUserText.label: 'Valor líquido'
         @Semantics.amount.currencyCode: 'Currency'
         cast(  Nfs.nfnett as abap.curr( 16, 2 ) )           as NfNett,

         Nfs.werks                                           as Werks,

         @EndUserText.label: 'Parceiro'
         Partner.partner                                     as Partner,

         @EndUserText.label: 'Nome parceiro'
         concat(Partner.name_first, Partner.name_last)       as PartnerName,

         Invoices.pterm

}
