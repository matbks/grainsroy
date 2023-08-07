sap.ui.define(["grains/zadograinsacmcontrollingclearingacc/model/models"],function(e){"use strict";QUnit.module("createDeviceModel",{afterEach:function(){this.oDeviceModel.destroy()}});function i(i,t){this.stub(sap.ui.Device,"system",{phone:t});this.oDev+
iceModel=e.createDeviceModel();i.strictEqual(this.oDeviceModel.getData().system.phone,t,"IsPhone property is correct")}QUnit.test("Should initialize a device model for desktop",function(e){i.call(this,e,false)});QUnit.test("Should initialize a device mod+
el for phone",function(e){i.call(this,e,true)});function t(i,t){this.stub(sap.ui.Device,"support",{touch:t});this.oDeviceModel=e.createDeviceModel();i.strictEqual(this.oDeviceModel.getData().support.touch,t,"IsTouch property is correct")}QUnit.test("Shou+
ld initialize a device model for non touch devices",function(e){t.call(this,e,false)});QUnit.test("Should initialize a device model for touch devices",function(e){t.call(this,e,true)});QUnit.test("The binding mode of the device model should be one way",f+
unction(i){this.oDeviceModel=e.createDeviceModel();i.strictEqual(this.oDeviceModel.getDefaultBindingMode(),"OneWay","Binding mode is correct")})});                                                                                                            