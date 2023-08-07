@AbapCatalog.sqlViewName: 'ZADOCROYMONIT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor de Royalties'

@UI.headerInfo: {
    typeName: 'Connection' , typeNamePlural: 'Connections'
}
define view ZADOC_ROYALTIES_MONITOR

  as select from    /accgo/t_uisevnt               as EventDetails
    inner join      /accgo/t_cas_cai               as ApplicationDocItem  on  ApplicationDocItem.uis_guid = EventDetails.parent_key
                                                                          and ApplicationDocItem.shd_type = 'ZA'

    inner join      ZADOI_GRAINS_EDC_DOCS          as EDCdocs             on  EDCdocs.Tkonn = EventDetails.tc_id
                                                                          and EDCdocs.UisId = ApplicationDocItem.uis_id

    inner join      ZADOI_GRAINS_ROMANEIO_TICKET   as LinkRomaneioTicket  on  LinkRomaneioTicket.Romaneio = EDCdocs.Romaneio
                                                                          and LinkRomaneioTicket.Werks    = EventDetails.evnt_loc

    inner join      zadot_grains_021               as Materials           on  ApplicationDocItem.matnr = Materials.material
                                                                          and Materials.company_code   = LinkRomaneioTicket.Bukrs

  //    inner join      zadot_royal_mat                as Materials           on LinkRomaneioTicket.Bukrs = Materials.company_code

    left outer join ZADOI_GRAINS_BALANCA_QM        as QualityData         on  QualityData.Ticket = LinkRomaneioTicket.TicketId
                                                                          and QualityData.Werks  = EventDetails.evnt_loc
                                                                          and (
                                                                             QualityData.Code    = 'TID' // transgenica
                                                                             or QualityData.Code = 'TIT'
                                                                           ) // transgenica

    left outer join ZADOI_GRAINS_BALANCA_TICKET    as TicketData          on  TicketData.Ticket = LinkRomaneioTicket.TicketId
                                                                          and TicketData.Werks  = EventDetails.evnt_loc
                                                                          and TicketData.Bukrs  = LinkRomaneioTicket.Bukrs


    left outer join dfkkbptaxnum                   as FiscalId            on FiscalId.partner   = TicketData.Partner
                                                                          and(
                                                                            FiscalId.taxtype    = 'BR1'
                                                                            or FiscalId.taxtype = 'BR2'
                                                                          )

    left outer join dfkkbptaxnum                   as VendorFiscalId      on  VendorFiscalId.partner = EventDetails./accgo/vendor
                                                                          and VendorFiscalId.taxtype = 'BR1'


    left outer join zipartners                     as BPData              on BPData.partner = EDCdocs.CodPro

    left outer join zipartners                     as VendorData          on VendorData.partner = EventDetails./accgo/vendor

    left outer join but000                         as BP                  on BP.partner = EDCdocs.CodPro

    left outer join zipartners                     as PartnerData         on PartnerData.partner = TicketData.Partner

    left outer join makt                           as MaterialDescription on  MaterialDescription.matnr = ApplicationDocItem.matnr
                                                                          and MaterialDescription.spras = $session.system_language

    left outer join ZADOC_ROYALTIES_DISCHARGES_TOT as Discharges          on Discharges.EdcNumber = ApplicationDocItem.uis_id

  association [0..*] to ZADOC_ROYALTIES_LOG as _RoyaltiesLog on $projection.EdcNum = _RoyaltiesLog.EdcNumber




{

  key    ApplicationDocItem.uis_id                                                                                                             as EdcNum,
         @UI.connectedFields: [{label: 'Contract'}]
         EventDetails.tc_id                                                                                                                    as ContractNum,
         ApplicationDocItem.appldoc                                                                                                            as ApplicationDocNum,
         ApplicationDocItem.uis_type                                                                                                           as EdcType,
         cast( EDCdocs.CodPro  as zadode_grains_property )                                                                                     as Property,
         ApplicationDocItem.matnr                                                                                                              as Material,
         MaterialDescription.maktx                                                                                                             as MaterialDescription,
         cast( ApplicationDocItem.adjusted_qty_dec as zed_royalty_netqty )                                                                     as ApplicationQuantity,
         LinkRomaneioTicket.TicketId                                                                                                           as Ticket,
         ApplicationDocItem.created_by                                                                                                         as CreatedBy,
         cast( ApplicationDocItem.created_on as cfx_changed_on )                                                                               as CreatedOn,
         ApplicationDocItem.changed_by                                                                                                         as ChangedBy,
         cast( ApplicationDocItem.changed_on as cfx_changed_on )                                                                               as ChangedOn,
         cast( EDCdocs.Romaneio   as zed_royalty_romaneio )                                                                                    as Romaneio,
         cast( TicketData.CreatedAt as zadode_royalties_criado_em )                                                                            as TicketDate,
         cast( TicketData.Partner as zed_royalty_partner )                                                                                     as Partner,
         FiscalId.taxnum                                                                                                                       as PartnerId,
         cast( BP.title_let as zed_royalty_property_name )                                                                                     as PropertyDescription,
         cast( PartnerData.partnername as zadoed_royalties_partner_name )                                                                      as PartnerDescription,
         TicketData.Safra                                                                                                                      as Safra,
         QualityData.Werks                                                                                                                     as Plant,
         QualityData.Code                                                                                                                      as Transgenia,
         case when Discharges.Discharges is null then cast( ApplicationDocItem.adjusted_qty_dec as zed_royalty_netqty )
         else cast(  cast( ApplicationDocItem.adjusted_qty_dec as zed_royalty_netqty ) - Discharges.Discharges as zed_royalty_discharges ) end as Discharges,
         PartnerData.cnpj_cpf                                                                                                                  as CpfCnpj,
         cast( EventDetails./accgo/royalties_id  as zed_royalty_roydescrip )                                                                   as TechVendor,
         cast( VendorFiscalId.taxnum  as zed_royalty_vendorcnpj )                                                                              as VendorCnpj,
         cast( VendorData.partnername  as zed_royalty_vendor )                                                                                 as VendorDescription,
         _RoyaltiesLog





}
where
       ApplicationDocItem.adjusted_qty_dec is not initial
  and  EventDetails.evnt_loc_typ           = 'PLNT'
  and(
       EventDetails./accgo/royalties_id    = 'TID' // transgenica
    or EventDetails./accgo/royalties_id    = 'TIT'
  )
