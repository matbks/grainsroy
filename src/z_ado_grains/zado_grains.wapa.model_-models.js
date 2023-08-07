sap.ui.define(["sap/ui/model/json/JSONModel","sap/ui/Device"],function(e,t){"use strict";return{createDeviceModel:function(){var i=new e(t);i.setDefaultBindingMode("OneWay");return i},createMessagesModel:function(){return new e({MessageBar:false,Messages+
:[]})},createFixation:function(){return new e({Contract:"",AvailableQuantity:"",Quantity:"",Unit:"KG",BagPrice:0,Currency:"BRL",ConversionsCurrency:"USD",BasisPrice:0,FuturePrice:0,DueCode:"",PaymentDate:"",Amount:0,BlockedQuantity:0})},createLineFixatio+
n:function(){return{Contract:"",AvailableQuantity:"",Quantity:"",Unit:"KG",BagPrice:0,Currency:"BRL",ConversionsCurrency:"USD",BasisPrice:0,FuturePrice:0,DueCode:"",PaymentDate:"",Amount:0,BlockedQuantity:0}},createConversionsModel:function(){return new +
e({DolarQuotation:0,CommodityFactor:0,RoyaltiesBlockPerc:0})},createApplicationModel:function(){return new e({})},createApplicationsPropertyModel:function(){return new e({})},createFixationBankModel:function(){return new e({items:[]})},createLineFixation+
BankModel:function(){return{Parcel:1,BankAccountId:"",Amount:0,Currency:"BRL",PaymentDate:"",Bank:"",BankAgency:"",BankAccount:"",BankHolder:""}},createViewConfigurationsModel:function(){return new e({})},createLineConfigurationsModel:function(){return{C+
reateFixation:false,ShowFixation:false,ShowInvoices:true,ShowAdjusts:false,ShowSalesBarter:false,ShowConsumedQuantity:false,ShowPartnerBlocks:true,ShowAmount:false}},createRoyaltiesBlocksModel:function(){return new e({items:[]})},createContractFlow:funct+
ion(){let t=new e({nodes:[{id:"1",lane:"0",title:"Sales Order 1",titleAbbreviation:"SO 1",children:[10],state:"Positive",stateText:"OK status",focused:true,highlighted:false,texts:["Sales Order Document Overdue long text for the wrap up all the aspects",+
"Not cleared"]},{id:"10",lane:"1",title:"Outbound Delivery 40",titleAbbreviation:"OD 40",children:[20],state:"Negative",stateText:"NOT OK",focused:false,highlighted:false,texts:["text 1","text 2"]},{id:"20",lane:"2",title:"Invoice 9",titleAbbreviation:"I+
 9",children:[30],state:"Positive",stateText:"OK status",focused:false,highlighted:false,texts:null},{id:"30",lane:"3",title:"Accounting Document 5",titleAbbreviation:"AD 5",children:[41],state:"Critical",stateText:"AD Issue",focused:false,highlighted:fa+
lse,texts:null},{id:"41",lane:"4",title:"Payment Document 75",titleAbbreviation:"PD 75",children:[51],state:"Positive",stateText:"OK status",focused:false,highlighted:false,texts:null},{id:"51",lane:"5",title:"Acceptance Letter 14",titleAbbreviation:"AL +
14",children:[61],state:"Positive",stateText:"OK status",focused:false,highlighted:false,texts:null},{id:"61",lane:"6",title:"Credit Voucher 67",titleAbbreviation:"CV 67",children:[71],state:"Positive",stateText:"OK status",focused:false,highlighted:fals+
e,texts:null},{id:"71",lane:"6",title:"Credit Return 77",titleAbbreviation:"CR 77",children:null,state:"Planned",stateText:"Planned status text",focused:false,highlighted:false,texts:null}],lanes:[{id:"0",icon:"sap-icon://order-status",label:"Order Proce+
ssing",position:0},{id:"1",icon:"sap-icon://monitor-payments",label:"Delivery Processing",position:1},{id:"2",icon:"sap-icon://payment-approval",label:"Invoicing",position:2},{id:"3",icon:"sap-icon://money-bills",label:"Accounting",position:3},{id:"4",ic+
on:"sap-icon://payment-approval",label:"Payment Processing",position:4},{id:"5",icon:"sap-icon://nurse",label:"Receipt Processing",position:5},{id:"6",icon:"sap-icon://retail-store",label:"Return Processing",position:6}]});return t}}});                   