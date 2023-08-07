sap.ui.define(["./BaseController","sap/ui/model/json/JSONModel","sap/ui/model/Filter","sap/ui/model/Sorter","sap/ui/model/FilterOperator","sap/m/GroupHeaderListItem","sap/ui/Device","sap/ui/core/Fragment","../model/formatter"],function(t,e,i,s,o,r,n,a,l)+
{"use strict";return t.extend("grains.zadograinsacmcontrollingapproval.controller.List",{formatter:l,onInit:function(){var t=this.byId("list"),e=this._createViewModel(),i=t.getBusyIndicatorDelay();this._oList=t;this._oListFilterState={aFilter:[],aSearch:+
[]};this.setModel(e,"listView");t.attachEventOnce("updateFinished",function(){e.setProperty("/delay",i)});this.getView().addEventDelegate({onBeforeFirstShow:function(){this.getOwnerComponent().oListSelector.setBoundMasterList(t)}.bind(this)});this.getRou+
ter().getRoute("list").attachPatternMatched(this._onMasterMatched,this);this.getRouter().attachBypassed(this.onBypassed,this);this._getUserInfo().then(function(t){e.setProperty("/user",t.results[0])}.bind(this))},_getUserInfo:function(){return new Promis+
e(function(t,e){var i=this.getOwnerComponent().getModel();i.read("/ZADOC_GRAINS_USER_INFO",{success:function(e,i){t(e)}.bind(this),error:function(t){e(t)}.bind(this)})}.bind(this))},onUpdateFinished:function(t){this._updateListItemCount(t.getParameter("t+
otal"))},onSearch:function(t){if(t.getParameters().refreshButtonPressed){this.onRefresh();return}this.oCombinedFilter=[];var e=new sap.ui.model.Filter({filters:[],and:true});var s=this.byId("segmentedButtonType");var r=s.getSelectedKey();switch(r){case"C+
ontrato":e.aFilters.push(new i("Type",o.EQ,"Contrato"));break;case"Fixação":e.aFilters.push(new i("Type",o.NE,"Contrato"));break;default:break}var n=this.byId("segmentedButtonStatus");var a=n.getSelectedKey();if(a=="U"){e.aFilters.push(new i("Status",o.E+
Q,"U"))}var l=t.getParameter("query");if(!l){var l=this.byId("searchField").getValue()}if(l){var u=new i("TradingContractNumber",o.Contains,l);var h=new i("Title",o.Contains,l);this.oCombinedFilter=new sap.ui.model.Filter({filters:[u,h],and:false});if(e.+
aFilters.length>0){this.oCombinedFilter=new sap.ui.model.Filter({filters:[this.oCombinedFilter,e],and:true})}this._oListFilterState.aSearch=this.oCombinedFilter}else{this.oCombinedFilter=e;this._oListFilterState.aSearch=[]}this._applyFilterSearch()},onRe+
fresh:function(){this._oList.getBinding("items").refresh()},onOpenViewSettings:function(t){var e="filter";if(t.getSource()instanceof sap.m.Button){var i=t.getSource().getId();if(i.match("sort")){e="sort"}else if(i.match("group")){e="group"}}if(!this.byId+
("viewSettingsDialog")){a.load({id:this.getView().getId(),name:"grains.zadograinsacmcontrollingapproval.view.ViewSettingsDialog",controller:this}).then(function(t){this.getView().addDependent(t);t.addStyleClass(this.getOwnerComponent().getContentDensityC+
lass());t.open(e)}.bind(this))}else{this.byId("viewSettingsDialog").open(e)}},onConfirmViewSettingsDialog:function(t){this._applySortGroup(t)},onPressReportButton:function(t){this.getModel("appView").setProperty("/actionButtonsInfo/midColumn/fullScreen",+
false);var e=this.getOwnerComponent().oListSelector;e.clearMasterListSelection();this.navTo("list",{},false);this.navTo("report",{},false)},_applySortGroup:function(t){var e=t.getParameters(),i,o,r=[];i=e.sortItem.getKey();o=e.sortDescending;r.push(new s+
(i,o));this._oList.getBinding("items").sort(r)},onSelectionChange:function(t){var e=t.getSource(),i=t.getParameter("selected");if(!(e.getMode()==="MultiSelect"&&!i)){this._showDetail(t.getParameter("listItem")||t.getSource())}},onBypassed:function(){this+
._oList.removeSelections(true)},createGroupHeader:function(t){return new r({title:t.text,upperCase:false})},onNavBack:function(){history.go(-1)},_createViewModel:function(){return new e({isFilterBarVisible:false,filterBarLabel:"",delay:0,title:this.getRe+
sourceBundle().getText("listTitleCount",[0]),noDataText:this.getResourceBundle().getText("listListNoDataText"),sortBy:"TradingContractNumber",groupBy:"None",switchStatus:"U"})},_onMasterMatched:function(){this.getModel("appView").setProperty("/layout","O+
neColumn")},_showDetail:function(t){var e=t.getBindingContext().getObject();var i=e.TradingContractNumber;var s=e.IdentificationFix;var o=!n.system.phone;this.getModel("appView").setProperty("/layout","TwoColumnsMidExpanded");if(t.getFirstStatus().getTex+
t()==="Contrato"){this.getRouter().navTo("object",{objectId:i,objectFixation:s},o)}else if(t.getFirstStatus().getText()==="Fixação"){this.getRouter().navTo("objectFixation",{objectId:i,objectFixation:s},o)}},_updateListItemCount:function(t){var e;if(this+
._oList.getBinding("items").isLengthFinal()){e=this.getResourceBundle().getText("listTitleCount",[t]);this.getModel("listView").setProperty("/title",e)}},_applyFilterSearch:function(){var t=this._oListFilterState.aSearch,e=this.getModel("listView");this.+
_oList.getBinding("items").filter(this.oCombinedFilter,"Application");if(t.length!==0){e.setProperty("/noDataText",this.getResourceBundle().getText("listListNoDataWithFilterOrSearchText"))}else if(this._oListFilterState.aSearch.length>0){e.setProperty("/+
noDataText",this.getResourceBundle().getText("listListNoDataText"))}},_updateFilterBar:function(t){var e=this.getModel("listView");e.setProperty("/isFilterBarVisible",this._oListFilterState.aFilter.length>0);e.setProperty("/filterBarLabel",this.getResour+
ceBundle().getText("listFilterBarText",[t]))}})});                                                                                                                                                                                                             