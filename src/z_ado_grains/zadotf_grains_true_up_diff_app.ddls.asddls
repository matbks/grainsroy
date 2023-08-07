@EndUserText.label: 'Grains - Table Function - Diferenças Quant NF x Quant Física'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZADOTF_GRAINS_TRUE_UP_DIFF_APP
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt : abap.clnt

returns
{
  Client                : abap.clnt;
  ApplicationTrueUpGuid : /accgo/e_br_trp_guid;
  ApplicationDoc        : /accgo/e_appldoc;
  ApplicationDocItem    : /accgo/e_appldoc_item_num;
  Side                  : wlf_pr_side;
  SubItem               : /accgo/e_appldoc_item_num;
  ApplicationDiffStatus : /accgo/e_br_diff_status;
  NfQuantity            : zadode_grains_nf_quantity;
  NfUom                 : meins;
  ApplicationQuantity   : zadode_grains_app_quantity;
  ApplicationUom        : meins;
  QuantityTrueUpDiff    : zadode_grains_qtd_true_up_diff;



}
implemented by method
  zadocl_grains_true_up_diff_app=>get_data;
