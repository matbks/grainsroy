*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


TYPES: BEGIN OF ty_residual_acc_docs,
         include         TYPE zadoi_grains_contract_invoices,
         residual_amount TYPE wrbtr,
       END OF ty_residual_acc_docs.
