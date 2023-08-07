@EndUserText.label: 'Grains - Saldos disponíveis para fixações de venda'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZADOTF_GRAINS_BALANCES_SALES
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt : abap.clnt

returns
{
  Client         : abap.clnt;
  ApplicationDoc : /accgo/e_appldoc;
  Quantity       : zadode_grains_quantity;

}
implemented by method
  zadocl_grains_balance_sales=>get_data;
