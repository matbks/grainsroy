@EndUserText.label: 'Grains - Valor unitário contrato fixo'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZADOTF_GRAINS_GET_FIX_CONT_PRC
  with parameters
    @Environment.systemField: #CLIENT
    p_client : abap.clnt
returns
{
  client   : abap.clnt;
  contract : tkonn;
  pr_cont  : wlf_pr_count;
  price    : zadode_grains_value_kg;

}
implemented by method
  zadocl_grains_get_fix_cont_prc=>get_data;
