@EndUserText.label: 'Grains - Quantidade devolvida da aplicação'
define table function ZADOTF_GRAINS_RETURNED_QUAN
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt : abap.clnt
returns
{
  Client   : abap.clnt;
  Edc      : /accgo/e_uis_id;
  Quantity : zadode_grains_quantity;
}
implemented by method
  zadocl_grains_returned_quan=>get_data;
