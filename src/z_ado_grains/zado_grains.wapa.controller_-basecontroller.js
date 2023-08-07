sap.ui.define(["sap/ui/core/mvc/Controller","sap/ui/core/UIComponent","grains/zadograinsacmcontrolling/model/models","sap/ui/core/routing/History","sap/m/PDFViewer"],function(e,t,a,o,s){"use strict";return e.extend("grains.zadograinsacmcontrolling.contro+
ller.BaseController",{getRouter:function(){return t.getRouterFor(this)},getModel:function(){return new sap.ui.model.odata.v2.ODataModel("/sap/opu/odata/sap/ZADOP_GRAINS_SRV")},getStorage:function(e){return jQuery.sap.storage(jQuery.sap.storage.Type.local+
).get(e)},putStorage:function(e,t){jQuery.sap.storage(jQuery.sap.storage.Type.local).put(e,t)},refreshModel:function(e){this.getOwnerComponent().getModel(e).refresh(true)},onNavBack:function(){if(!o.getInstance().getPreviousHash()){window.history.go(-1)}+
},MessageBarChangeVisible:function(e){this.getOwnerComponent().getModel("MessagesModel").oData.MessageBar=e;this.refreshModel("MessagesModel")},initMessageProcessor:function(){let e=new sap.ui.core.message.ControlMessageProcessor;this._oMessageManager=sa+
p.ui.getCore().getMessageManager();this._oMessageManager.registerMessageProcessor(e)},fillMessagesModel:function(){let e=false;this._oMessageManager.getMessageModel().getData().forEach(t=>{if(t.message!=""){e=t.type=="Error"?true:e;this.getOwnerComponent+
().getModel("MessagesModel").getData().Messages.push(t)}});return e},clearMessageManager:function(){this._oMessageManager.removeAllMessages()},_PreviewSmartform:function(e,t,a){var o=new s;e.addDependent(o);let r=this.getModel();let n=r.createKey("/Print+
_SmartformSet",{FormName:t,FormParams:JSON.stringify(a)});let i=e.getModel().sServiceUrl+n+"/$value";o.setShowDownloadButton(false);o.setSource(i);o.setTitle("Boletim");o.open()},authValidate:function(e){return new Promise((t,a)=>{this.getModel().create(+
"/JsonCommunicationSet",{Action:"CHECK_AUTH",Json:JSON.stringify([e]),StructureName:"ZADOS_GRAINS_AUTH"},{success:function(e){t(e)}.bind(this),error:function(e){a(e)}.bind(this)})})},callTransactionWithAdditionalURL(e,t,a){sap.ushell.Container.getService+
Async("CrossApplicationNavigation").then(function(o){var s=o.hrefForExternal({target:{semanticObject:e,action:t}});s=s+a;var r=window.location.href.split("#")[0]+s;sap.m.URLHelper.redirect(r,false)})},callTransaction(e,t,a){var o=sap.ushell.Container.get+
Service("CrossApplicationNavigation");var s=o.hrefForExternal({target:{semanticObject:e,action:t},params:a});window.location.href=s}})});                                                                                                                      