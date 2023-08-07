sap.ui.define(["./BaseController","sap/ui/core/Fragment","sap/ui/model/json/JSONModel","../model/formatter","../model/models","sap/ui/model/Filter","sap/ui/model/FilterOperator","sap/m/MessageBox","sap/m/MessageToast","sap/ui/model/Sorter"],function(t,e,+
i,a,o,n,s,r,l,c){"use strict";return t.extend("grains.zadograinsacmcontrolling.controller.ContractFixation",{formatter:a,onInit:function(){this.initMessageProcessor();this.getRouter().attachRoutePatternMatched(this._onObjectMathed,this)},_onObjectMathed:+
function(t){this._Fixation=t.getParameter("arguments").Fixation;this._oModel=this.getModel();if(!this._Fixation){this._newFixation()}else{this._getFixation(this._Fixation)}},_newFixation:function(){this.getModel().read(this.getStorage("SelectedPath").Pat+
h,{success:function(t){this.getOwnerComponent().setModel(new i(t),"ContractDetailsModel");this.byId("ContractFixationCreationPage").setVisible(true);this.byId("ContractFixationDetailPage").setVisible(false)}.bind(this),error:function(){l.show("Falha ao o+
bter dados do contrato")}});this._applicationsListInitialization();this._refreshViewData()},_applicationsListInitialization:function(){this._oContext=new sap.ui.model.Context(this.getOwnerComponent().getModel(),this.getStorage("SelectedPath").Path);this.+
byId("ApplicationsSmartList").setBindingContext(this._oContext);this.byId("ApplicationsSmartList").getList().removeSelections()},_getFixation:function(t){this.byId("ContractFixationCreationPage").setVisible(false);this.byId("ContractFixationDetailPage").+
setVisible(true);this.getView().bindElement(this.getStorage("Fixation").sPath)},onSqueeze:function(){if(this.byId("SqueezeButton").getTooltip()=="Hide"){this.byId("ContractFixationCreationPage").setMode("HideMode");this.byId("SqueezeButton").setIcon("sap+
-icon://navigation-right-arrow");this.byId("SqueezeButton").setTooltip("Expand")}else{this.byId("ContractFixationCreationPage").setMode("ShowHideMode");this.byId("SqueezeButton").setIcon("sap-icon://nav-back");this.byId("SqueezeButton").setTooltip("Hide"+
)}},_getApplicationData:function(){return new Promise((t,e)=>{if(this._selectedApplication){this._oModel.read("/ZADOC_GRAINS_EDC_FROM_CONTRACT",{filters:[new n("Property",s.EQ,this._selectedApplication.Property),new n("ContractNum",s.EQ,this._selectedApp+
lication.ContractNum),new n("Transgenic",s.EQ,this._selectedApplication.IdRoyalties),new n("Plant",s.EQ,this._selectedApplication.Plant),new n("AvailableQuantity",s.GT,0),new n("NfeQuantity",s.GT,0)],success:function(i){try{this.getOwnerComponent().getMo+
del("ApplicationsProperty").setData(i);this.refreshModel("ApplicationsProperty");t()}catch{e("Falha ao obter documentos de aplicação da propriedade")}}.bind(this),error:function(){e("Falha ao obter documentos de aplicação da propriedade")}})}else{e("Sele+
cione uma propriedade válida para realizar a fixação")}})},_getCommodityData:function(){return new Promise((t,e)=>{this._oModel.read("/ZADOC_GRAINS_COMMODITY_DATA",{filters:[new n("CompanyCode",s.EQ,this.getOwnerComponent().getModel("ContractDetailsModel+
").getData().CompanyCode),new n("AppCode",s.EQ,"ACMCONTROL"),new n("Commodity",s.EQ,this.getOwnerComponent().getModel("ContractDetailsModel").getData().MaterialNum)],success:function(i){try{this.getOwnerComponent().getModel("ConversionsModel").oData.Comm+
odityFactor=i.results[0].ConversionFactor;this.getOwnerComponent().getModel("ConversionsModel").oData.RoyaltiesBlockPerc=i.results[0].RoyaltiesBlockPerc;t()}catch{e("Falha ao obter dados da commodity")}}.bind(this),error:function(t){e("Falha ao obter dad+
os da commodity")}})})},_getDolarQuotation:function(){return new Promise((t,e)=>{this._oModel.read("/ZADOC_GRAINS_DOLAR_QUOTATION",{success:function(i){try{this.getOwnerComponent().getModel("ConversionsModel").oData.DolarQuotation=i.results[0].Ukurs;this+
.refreshModel("ConversionsModel");t()}catch{e("Falha ao obter cotação do dólar")}}.bind(this),error:function(t){e("Falha ao obter cotação do dólar")}})})},_PaymentDateValidate:function(){return new Promise((t,e)=>{this._PaymentDate=this.getOwnerComponent+
().getModel("Fixation").getData().PaymentDate;this._NewPaymentDate=this._PaymentDate.split(".");this._NewPaymentDate=new Date(this._NewPaymentDate[2],this._NewPaymentDate[1]-1,this._NewPaymentDate[0],23,59,59);if(this._NewPaymentDate instanceof Date&&!is+
NaN(this._NewPaymentDate)&&this._NewPaymentDate>=new Date){let i={Action:"DATEVALID",Json:JSON.stringify([{PaymentDate:this._PaymentDate.replaceAll(".","")}]),StructureName:"ZADOS_GRAINS_PAYMENT_DATE"};this._oModel.create("/JsonCommunicationSet",i,{succe+
ss:function(e){t()},error:function(t){e("Selecione uma data válida")}})}else{e("Selecione uma data válida")}})},_getFuturePrice:function(){this._NewPaymentDate.setDate(this._NewPaymentDate.getDate()-1);return new Promise((t,e)=>{let i=new Date;this._oMod+
el.read("/ZADOC_GRAINS_FUTURE_PRICE",{filters:[new n("Commodity",s.EQ,this.getOwnerComponent().getModel("ContractDetailsModel").getData().MaterialNum),new n("Plant",s.EQ,this._selectedApplication.Plant),new n("CompanyCode",s.EQ,this.getOwnerComponent().g+
etModel("ContractDetailsModel").getData().CompanyCode),new n("DueDate",s.GE,this._NewPaymentDate),new n("PriceDate",s.EQ,i)],sorters:[new c("DueDate",false)],success:function(i){try{this.getOwnerComponent().getModel("Fixation").oData.FuturePrice=i.result+
s[0].Price;this.getOwnerComponent().getModel("Fixation").oData.DueCode=i.results[0].DueCode;this.getOwnerComponent().getModel("Fixation").oData.AvailableQuantity=this.getView().getModel("Application").getData().AvailableQuantity;this.refreshModel("Fixati+
on");this._NewPaymentDate.setDate(this._NewPaymentDate.getDate()+1);t()}catch{e("Falha ao obter preço futuro")}}.bind(this),error:function(t){this._NewPaymentDate.setDate(this._NewPaymentDate.getDate()+1);e("Falha ao obter preço futuro")}})})},_getRoyalt+
iesBlocks:function(){return new Promise((t,e)=>{var i=[];this.getOwnerComponent().getModel("ApplicationsProperty").getData().results.forEach(t=>{i.push(new n("EdcNum",s.EQ,t.EdcNum))});this._oModel.read("/ZADOC_GRAINS_ROYALTIES_BLOCK",{filters:i,success:+
function(i){try{this.getOwnerComponent().getModel("RoyaltiesBlocks").oData.items=i.results;this.refreshModel("RoyaltiesBlocks");t()}catch{e("Falha ao obter bloqueios de royalties")}}.bind(this),error:function(t){e("Falha ao obter bloqueios de royalties")+
}.bind(this)})})},onFixation:function(t){let e=this.getOwnerComponent().getModel("ContractDetailsModel").getData();if(this._selectedApplication.Plant!=undefined){let t={Company_Code:e.CompanyCode,Plant:this._selectedApplication.Plant,Authorization:"FIX_C+
RT"};this.authValidate(t).then(()=>{this._PaymentDateValidate().then(()=>{this._getDolarQuotation().then(()=>{this._getCommodityData().then(()=>{this._getApplicationData().then(()=>{this._getRoyaltiesBlocks().then(()=>{this._getFuturePrice().then(()=>{th+
is._fixationPopupPrepare()}).catch(t=>{r.show(t,{icon:r.Icon.INFORMATION,title:"Aviso"})})}).catch(t=>{r.show(t,{icon:r.Icon.INFORMATION,title:"Aviso"})})}).catch(t=>{r.show(t,{icon:r.Icon.INFORMATION,title:"Aviso"})})}).catch(t=>{r.show(t,{icon:r.Icon.I+
NFORMATION,title:"Aviso"})})}).catch(t=>{r.show(t,{icon:r.Icon.INFORMATION,title:"Aviso"})})}).catch(t=>{r.show(t,{icon:r.Icon.INFORMATION,title:"Aviso"})})}).catch(()=>{r.show("Usuário não possui permissão para realizar a fixação",{icon:r.Icon.INFORMATI+
ON,title:"Aviso"})})}else{r.show("Nenhuma aplicação foi selecionada",{icon:r.Icon.INFORMATION,title:"Aviso"})}},_fixationPopupPrepare:function(){if(this.getView().getModel("Application").getData().Quantity>0){if(this.getOwnerComponent().getModel("Convers+
ionsModel").getData().DolarQuotation>0){if(this.getOwnerComponent().getModel("Fixation").oData.FuturePrice>0){this._showFixationPopup()}else{r.show("Não foi possível estabelecer o preço futuro",{icon:r.Icon.INFORMATION,title:"Aviso"})}}else{r.show("Não f+
oi possível estabelecer a cotação do dólar",{icon:r.Icon.INFORMATION,title:"Aviso"})}}else{r.show("Selecione uma propriedade com saldo para realizar a fixação",{icon:r.Icon.INFORMATION,title:"Aviso"})}},_showFixationPopup:function(){if(!this._FixationFra+
gment){this._FixationFragment=e.load({id:this.getView().getId(),name:"grains.zadograinsacmcontrolling.view.fragments.Fixation",controller:this}).then(function(t){this.getView().addDependent(t);return t}.bind(this))}this._FixationFragment.then(function(t)+
{t.open()})},onCloseFixation:function(){this._getApplicationData();this.getOwnerComponent().getModel("BankData").oData.items=[];this.getOwnerComponent().getModel("Fixation").setData(o.createLineFixation());this.refreshModel("Fixation");this.refreshModel(+
"BankData");this.byId("MessageStrip").setVisible(false);this.byId("FixationDialog").close()},_toNumber:function(t){t=t.toString();return parseFloat(t.replace(",","."))},onSaveFixation:function(t){if(this._fixationPopUpValidate().isValid){this.byId("Messa+
geStrip").setVisible(false);let t=this.getOwnerComponent().getModel("Fixation").getData();this._updateApplicationsTable(t.Quantity);this._CommodityConversionFactor=this.getOwnerComponent().getModel("ConversionsModel").getData().CommodityFactor;this._Dola+
rQuotation=this.getOwnerComponent().getModel("ConversionsModel").getData().DolarQuotation;this._RoyaltiesBlockPerc=this.getOwnerComponent().getModel("ConversionsModel").getData().RoyaltiesBlockPerc;let e=o.createLineFixationBankModel();e.Amount=t.Amount=+
t.BagPrice[0]/60*t.Quantity-t.BlockedQuantity*(t.BagPrice[0]/60)*this._RoyaltiesBlockPerc;e.PaymentDate=this.getOwnerComponent().getModel("Fixation").getData().PaymentDate;t.BasisPrice=this._toNumber(t.BagPrice)/this._DolarQuotation/this._CommodityConver+
sionFactor-this._toNumber(t.FuturePrice);this.getOwnerComponent().getModel("BankData").oData.items=[e];this.getOwnerComponent().getModel("Fixation").setData(t);this.getOwnerComponent().getModel("BankData").refresh(true);this.getOwnerComponent().getModel(+
"Fixation").refresh(true);this.getOwnerComponent().getModel("ConversionsModel").refresh(true);this.byId("FixationDialog").close()}else{this.byId("MessageStrip").setType(this._fixationPopUpValidate().State);this.byId("MessageStrip").setText(this._fixation+
PopUpValidate().Message);this.byId("MessageStrip").setVisible(true)}},onChangeQuantity:function(t){let e=this.getOwnerComponent().getModel("Fixation").getData();this._updateApplicationsTable(e.Quantity)},_updateApplicationsTable:function(t){this._Blocked+
Quantity=0;this.getOwnerComponent().getModel("ApplicationsProperty").getData().results.forEach(t=>{t.FinalQuantity=t.AvailableQuantity});this.getOwnerComponent().getModel("ApplicationsProperty").getData().results.forEach(e=>{e.FinalQuantity=e.FinalQuanti+
ty-t;t=e.FinalQuantity<0?e.FinalQuantity*-1:"0";e.FinalQuantity=e.FinalQuantity>0?e.FinalQuantity:"0";this._BlockedQuantity=e.FinalQuantity>=e.BlockedQuantity?this._BlockedQuantity:(e.FinalQuantity-e.BlockedQuantity)*-1+this._BlockedQuantity});this.getOw+
nerComponent().getModel("Fixation").getData().BlockedQuantity=this._BlockedQuantity;this.refreshModel("ApplicationsProperty");this.refreshModel("Fixation")},_fixationPopUpValidate:function(){let t=this.getOwnerComponent().getModel("Fixation").getData();l+
et e=this.getOwnerComponent().getModel("ContractDetailsModel").getData().PartnerBlockQuantity;let i=this.getOwnerComponent().getModel("ContractDetailsModel").getData().ApplicationQuantity;let a=parseFloat(i)-parseFloat(e);let o=true;let n="";let s="";if(+
t.BagPrice<1||t.Quantity<1){o=false;n="Error";s="Quantidade ou preço fornecido é inválido"}else if(parseFloat(t.Quantity)>parseFloat(t.AvailableQuantity)){o=false;n="Error";s="Quantidade fornecida é superior ao saldo disponível para propriedade"}else if(+
a<parseFloat(t.Quantity)){let e=(a-parseFloat(t.Quantity))*-1;o=false;n="Error";s="Existem "+e+" KG bloqueados para o parceiro"}return{isValid:o,State:n,Message:s}},onAddLineFixation:function(t){var e=1;this.getOwnerComponent().getModel("BankData").oData+
.items.push(o.createLineFixationBankModel());this.getOwnerComponent().getModel("BankData").oData.items.forEach(t=>{t.Parcel=e;t.PaymentDate=this._PaymentDate;e++});this.refreshModel("BankData")},onDeleteLineFixation:function(t){var e=1;this.byId("BankDat+
aPopupTable")._aSelectedPaths.forEach(t=>{this.getOwnerComponent().getModel("BankData").oData.items.splice(t.substr(7),1)});this.getOwnerComponent().getModel("BankData").oData.items.forEach(t=>{t.Parcel=e;e++});this.refreshModel("BankData")},_onSendFixat+
ion:function(){let t=this.getView().getModel("ContractDetailsModel").getData();let e={Company_Code:t.CompanyCode,Plant:this._selectedApplication.Plant,Authorization:"FIX_CRT"};this.authValidate(e).then(()=>{r.show("A fixação será enviada para aprovação, +
deseja continuar?",{title:"Confirmação",icon:r.Icon.INFORMATION,actions:[r.Action.YES,r.Action.NO],emphasizedAction:r.Action.YES,onClose:function(t){if(t=="YES"){this._getFixationData()}}.bind(this)})}).catch(()=>{r.show("Usuário não possui permissão par+
a realizar a fixação",{icon:r.Icon.INFORMATION,title:"Aviso"})})},FixationDataValidate:function(){this._FixationData=this.getOwnerComponent().getModel("Fixation").getData();this._BankData=this.getOwnerComponent().getModel("BankData").getData();this._Appl+
icationsProperty=this.getOwnerComponent().getModel("ApplicationsProperty").getData();this._Valid=true;try{if(this._selectedApplication==undefined){throw"Nenhuma aplicação foi selecionada"}this._Valid=this._FixationData.Amount>0?this._Valid:false;this._Va+
lid=this._FixationData.Quantity>0?this._Valid:false;this._Valid=this._FixationData.PaymentDate!=""?this._Valid:false;let t=this.getOwnerComponent().getModel("ContractDetailsModel").getData().PartnerBlockQuantity;let e=this.getOwnerComponent().getModel("C+
ontractDetailsModel").getData().ApplicationQuantity;let i=parseFloat(e)-parseFloat(t);if(i<parseFloat(this._FixationData.Quantity)){let t=(i-parseFloat(this._FixationData.Quantity))*-1;let e="Existem "+t+" KG bloqueados para o parceiro";throw e}if(!this.+
_BankData.items)throw"Dados da conta bancária incompletos";this._BankData.items.forEach(t=>{Object.keys(t).forEach(e=>{if(t.BankAccountId==""){throw"Dados da conta bancária incompletos"}})});if(!this._ApplicationsProperty.results)throw"Dados das aplicaçõ+
es consumidas incompletos";if(this._Valid){this._onSendFixation()}else throw"Dados da fixação incompletos"}catch(t){r.show(t,{icon:r.Icon.INFORMATION,title:"Erro"})}},_getFixationData:function(){this._FixationData=this.getOwnerComponent().getModel("Fixat+
ion").getData();this._BankData=this.getOwnerComponent().getModel("BankData").getData();this._ApplicationsProperty=this.getOwnerComponent().getModel("ApplicationsProperty").getData();this._ContractData=this.getView().getModel("ContractDetailsModel").getDa+
ta();var t=[];var e=[];try{this._ApplicationsProperty.results.forEach(e=>{t.push({ApplicationDoc:e.ApplicationDocNum,EdcNum:e.EdcNum,EdcType:e.EdcType,Property:e.Property,NfeNum:e.NfeNum,ApplicationQuantity:e.AvailableQuantity-e.FinalQuantity,IdRoyalties+
:e.IdRoyalties,Measure:"KG"})});this._BankData.items.forEach(t=>{e.push({Installment:t.Parcel,Amount:t.Amount[0],Currency:"BRL",Quantity:this._getInstallmentQuantity(this._FixationData.Amount,this._FixationData.Quantity,t.Amount[0]),Unit:"KG",PaymentDate+
:this.getOwnerComponent().getModel("Fixation").getData().PaymentDate.replaceAll(".",""),Bank:t.Bank,BankAgency:t.BankAgency,BankAccount:t.BankAccount,BankHolder:t.BankHolder,BankAccountId:t.BankAccountId})});this._FixationObject=JSON.stringify([{Plant:th+
is._selectedApplication.Plant,Contract:this._ContractData.ContractNum,Identification:this._ContractData.IdentificationFix,Quantity:this._FixationData.Quantity,Unit:"KG",Material:this._ContractData.Material,MaterialNum:this._ContractData.MaterialNum,BagPr+
ice:this._FixationData.BagPrice[0],Currency:this._FixationData.Currency,BasisPrice:this._FixationData.BasisPrice,FuturePrice:this._FixationData.FuturePrice,Amount:this._FixationData.Amount,KeydateCode:this._FixationData.DueCode,DolarQuotation:this._Dolar+
Quotation,BankData:e,ApplicationData:t,BlockedQuantity:this._FixationData.BlockedQuantity}]);this._Send({Action:"FIXCREATE",Json:this._FixationObject,StructureName:"ZADOS_GRAINS_CREATE_FIXATION"})}catch{r.show("Dados da fixação incompletos",{icon:r.Icon.+
INFORMATION,title:"Aviso"})}},_Send:function(t){sap.ui.core.BusyIndicator.show();this.clearMessageManager();this._oModel.create("/JsonCommunicationSet",t,{success:function(){let t=this.fillMessagesModel();this.MessageBarChangeVisible(true);this._refreshV+
iewData();sap.ui.core.BusyIndicator.hide();if(t){l.show("Aconteceram erros no processo, visualizar mensagens")}else{l.show("Processo executado com sucesso!");setTimeout(function(){this.getRouter().navTo("RouteContractDetails",{Contract:this.getOwnerCompo+
nent().getModel("ContractDetailsModel").getData().ContractNum})}.bind(this),1e3)}}.bind(this),error:function(){let t=this.fillMessagesModel();this.MessageBarChangeVisible(true);this._refreshViewData();sap.ui.core.BusyIndicator.hide();l.show("Houve um err+
o interno")}.bind(this)})},_refreshViewData:function(){this.getOwnerComponent().getModel("ApplicationsProperty").setData({});this.getOwnerComponent().getModel("BankData").oData.items=[];this.getOwnerComponent().getModel("Fixation").oData=o.createLineFixa+
tion();this.getOwnerComponent().getModel("Application").setData({});this.refreshModel("BankData");this.refreshModel("ApplicationsProperty");this.refreshModel("Fixation");this.refreshModel("Application")},_getInstallmentQuantity:function(t,e,i){return i/(+
t/e)},onSelectApplication:function(t){if(this.getOwnerComponent().getModel("Fixation").getData().Quantity>0){var e=t.oSource._aSelectedPaths[0];r.show("Ao alterar a propriedade os dados da fixação serão perdidos, deseja continuar?",{title:"Confirmação",i+
con:r.Icon.INFORMATION,actions:[r.Action.YES,r.Action.NO],emphasizedAction:r.Action.YES,onClose:function(t){if(t=="YES"){this._selectedApplication=this.getOwnerComponent().getModel().getData(e);this.getOwnerComponent().getModel("ApplicationsProperty").se+
tData({});this.getOwnerComponent().getModel("BankData").oData.items=[];this.getOwnerComponent().getModel("Fixation").oData=o.createLineFixation();this.getOwnerComponent().getModel("Application").setData(this._selectedApplication);this._getApplicationData+
().then(()=>{this._getRoyaltiesBlocks()});this.refreshModel("BankData");this.refreshModel("ApplicationsProperty");this.refreshModel("Fixation");this.refreshModel("Application");this._selectedApplicationId=this.byId("ApplicationsList").getSelectedItem().s+
Id;if(this._selectedApplication.AvailableQuantity<1){r.show("Propriedade não possui saldo disponível para fixação",{icon:r.Icon.INFORMATION,title:"Aviso"});this._selectedApplication=undefined;this.byId("ApplicationsList").removeSelections()}}else{this.by+
Id("ApplicationsList").setSelectedItemById(this._selectedApplicationId,true)}}.bind(this)})}else{this._selectedApplication=this.getOwnerComponent().getModel().getData(t.oSource._aSelectedPaths[0]);this.getOwnerComponent().getModel("Application").setData(+
this._selectedApplication);this._getApplicationData();this._selectedApplicationId=this.byId("ApplicationsList").getSelectedItem().sId;if(this._selectedApplication.AvailableQuantity<1){r.show("Propriedade não possui saldo disponível para fixação",{icon:r.+
Icon.INFORMATION,title:"Aviso"});this._selectedApplication=undefined;this.byId("ApplicationsList").removeSelections()}}},onBankData:function(){let t=this.getOwnerComponent().getModel("ContractDetailsModel").oData.Partner;this._oModel.read("/ZADOC_GRAINS_+
PRICING_BANK_DATA",{filters:[new n("Partner",s.EQ,t)],success:function(t){this.getView().setModel(new i(t),"BankAccountData");this._ShowBankDataPopup()}.bind(this),error:function(t){}})},_ShowBankDataPopup:function(){if(!this._BankDataFragment){this._Ban+
kDataFragment=e.load({id:this.getView().getId(),name:"grains.zadograinsacmcontrolling.view.fragments.BankData",controller:this}).then(function(t){this.getView().addDependent(t);return t}.bind(this))}this._BankDataFragment.then(function(t){t.open()})},onS+
aveBankData:function(){let t=this._bankDataValidate();if(t.isValid){this.byId("MessageStripBank").setVisible(false);this.byId("BankDataDialog").close()}else{this.byId("MessageStripBank").setText(t.Message);this.byId("MessageStripBank").setVisible(true)}}+
,onCloseBankData:function(){this.byId("BankDataDialog").close();this.byId("MessageStripBank").setVisible(false);this.getOwnerComponent().getModel("BankData").oData.items=[];let t=o.createLineFixationBankModel();t.PaymentDate=this._PaymentDate;this.getOwn+
erComponent().getModel("BankData").oData.items.push(t);this.getOwnerComponent().getModel("BankData").refresh(true)},_bankDataValidate:function(){let t="";let e=true;let i=this.getView().getModel("BankData").getData().items;let a=this.getOwnerComponent().+
getModel("Fixation").getData();var o=0;i.forEach(t=>{o=o+t.Amount[0]});if(a.Amount.toFixed(2)-o.toFixed(2)!==0){t="Valor informado para recebimento é diferente do valor total da fixação";e=false}return{isValid:e,Message:t}},onPressBankData:function(t){le+
t e=sap.ui.getCore().byId(t.getSource().getParent().sId).oBindingContexts.BankData.sPath;let i=this.getOwnerComponent().getModel("BankData").getProperty(e);let a=this.getView().getModel("BankAccountData").getProperty(t.getSource().getSelectedItem().oBind+
ingContexts.BankAccountData.sPath);i.BankAccountId=a.BankAccountId;i.BankId=a.BankId;i.BankAgency=a.BankAgency;i.BankAccount=a.BankAccount;i.BankCity=a.BankCity;i.BankHolder=a.BankHolder;i.Bank=a.Bank;this.getOwnerComponent().getModel("BankData").setProp+
erty(e,i);this.refreshModel("BankData")},onKeyDateChange:function(){if(this.getOwnerComponent().getModel("Fixation").getData().Quantity>0){r.show("Ao alterar a data os dados da fixação serão perdidos, deseja continuar?",{title:"Confirmação",icon:r.Icon.I+
NFORMATION,actions:[r.Action.YES,r.Action.NO],emphasizedAction:r.Action.YES,onClose:function(t){if(t=="YES"){this._PaymentDate=this.getOwnerComponent().getModel("Fixation").oData.PaymentDate;this.getOwnerComponent().getModel("ApplicationsProperty").setDa+
ta({});this.getOwnerComponent().getModel("BankData").oData.items=[];this.getOwnerComponent().getModel("Fixation").oData=o.createLineFixation();this.getOwnerComponent().getModel("Fixation").oData.PaymentDate=this._PaymentDate;this.refreshModel("BankData")+
;this.refreshModel("ApplicationsProperty");this.refreshModel("Fixation")}else{this.getOwnerComponent().getModel("Fixation").oData.PaymentDate=this._PaymentDate;this.refreshModel("Fixation")}}.bind(this)})}},onRebindBlocksTable:function(){let t=this.getSt+
orage("SelectedPath");this._oContext=new sap.ui.model.Context(this.getOwnerComponent().getModel(),t.Path);this.byId("SmartTableBlocks").setBindingContext(this._oContext)},onBlockPress:function(t){this._ContextBlockPath=new sap.ui.model.Context(this.getOw+
nerComponent().getModel(),t.getSource().getSelectedContexts()[0].sPath);this.byId("TableBlocks").removeSelections();if(!this._UnlocksFragment){this._UnlocksFragment=e.load({id:this.getView().getId(),name:"grains.zadograinsacmcontrolling.view.fragments.Pa+
rtnerUnlocks",controller:this}).then(function(t){this.getView().addDependent(t);return t}.bind(this))}this._UnlocksFragment.then(function(t){this.byId("UnlocksList").rebindList(true);t.open()}.bind(this))},onRebindUnlocks:function(){this.byId("UnlocksLis+
t").setBindingContext(this._ContextBlockPath)},onLiquidation:function(t){let e=t.getSource().getBindingContext().getObject();let i={Company_Code:e.CompanyCode,Plant:e.Plant,Authorization:"FIX_LIQ"};this.authValidate(i).then(()=>{try{let t=this.getView().+
getObjectBinding().getPath();let e=this.getView().getModel().getData(t);if(e.FixationStatus!=="T")throw"Não é possível realizar a liquidação, fixação não aprovada";sap.ui.core.BusyIndicator.show();this._sendLiquidation(e).then(t=>{let e=this.fillMessages+
Model();this.MessageBarChangeVisible(true);sap.ui.core.BusyIndicator.hide();if(e){l.show("Aconteceram erros no processo, visualizar mensagens")}else{l.show("Processo executado com sucesso!")}}).catch(t=>{let e=this.fillMessagesModel();this.MessageBarChan+
geVisible(true);sap.ui.core.BusyIndicator.hide();l.show("Houve um erro interno")})}catch(t){l.show("Falha ao efetuar a liquidação")}}).catch(()=>{r.show("Usuário não possui permissão para realizar a liquidação",{icon:r.Icon.INFORMATION,title:"Aviso"})})}+
,_sendLiquidation:function(t){return new Promise((e,i)=>{try{var a={Action:"LIQUIDATE",Json:JSON.stringify([{Contract:t.ContractNum,Identification:t.FixationId}]),StructureName:"ZADOS_GRAINS_CREATE_FIXATION"}}catch{i()}this.clearMessageManager();this._oM+
odel.create("/JsonCommunicationSet",a,{success:function(t){e()}.bind(this),error:function(t){i()}.bind(this)})})},onPrintForm:function(t){let e=this.getView().getModel().getData(this.getStorage("Fixation").sPath);this._PreviewSmartform(this.getView(),"ZA+
DOSF_GRAINS_BOL_FIX",{contract_num:e.ContractNum,plant_nr:e.Plant,idnum:e.FixationId})},onInvoicePost:function(t){let e=t.getSource().getBindingContext().getObject();let i={Company_Code:e.CompanyCode,Plant:e.Plant,Authorization:"FIX_LIQ"};this.authValida+
te(i).then(()=>{sap.ui.core.BusyIndicator.show();this.getModel().create("/JsonCommunicationSet",{Action:"INVOICEPST",Json:JSON.stringify([{settlement_group_id:e.SettlementGroupId,settlement_doc_year:e.SettlementDocYear}]),StructureName:"ZADOS_GRAINS_SETT+
LEMENT_GROUP"},{success:function(t){let e=this.fillMessagesModel();this.MessageBarChangeVisible(true);l.show("Processo executado com sucesso!");sap.ui.core.BusyIndicator.hide()}.bind(this),error:function(){let t=this.fillMessagesModel();this.MessageBarCh+
angeVisible(true);l.show("Aconteceram erros no processo, visualizar mensagens");sap.ui.core.BusyIndicator.hide()}.bind(this)})}).catch(()=>{r.show("Usuário não possui permissão para realizar o registro da fatura",{icon:r.Icon.INFORMATION,title:"Aviso"})}+
)},onInvoicePostManually:function(t){debugger;let e=t.getSource().getBindingContext().getObject();let i={Company_Code:e.CompanyCode,Plant:e.Plant,Authorization:"FIX_LIQ"};this.authValidate(i).then(()=>{this.callTransaction("SupplierInvoice","displayAdvan+
ced",{SupplierInvoice:e.InvoiceDoc,FiscalYear:e.InvoiceDocYear})}).catch(()=>{r.show("Usuário não possui permissão para realizar o registro da fatura",{icon:r.Icon.INFORMATION,title:"Aviso"})})},onGoToClearing:function(t){var e=t.getSource().getBindingCo+
ntext().getObject();var i="&/Invoice/"+e.ContractNum+"-"+e.AbdNumber;this.callTransactionWithAdditionalURL("ZOILACMTRANSEMUL","zacmmntcontragricinvoicescomp",i)},onGoToApprove:function(t){var e=t.getSource().getBindingContext().getObject();var i="&/Fixaç+
ão/"+e.ContractNum+"-"+e.IdentificationFix;this.callTransactionWithAdditionalURL("ZOILACMTRANSEMUL","zacmmntcontragricaprov",i)}})});                                                                                                                          