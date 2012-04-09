Ext.onReady(function(){
	
	Ext.Ajax.extraParams = {
		authenticity_token : Ext.select("meta[name='csrf-token']").first().getAttribute('content')
	}
	
	Ext.override(Ext.form.field.Picker, {
		
	    initEvents: function() {
	        var me = this;
	        me.callParent();

	        me.keyNav = Ext.create('Ext.util.KeyNav', me.inputEl, {
				pageDown: function() {
	                if (!me.isExpanded) { me.onTriggerClick(); }
	            },
	            esc: me.collapse,
	            scope: me,
	            forceKeyDown: true
	        });

	    }
	    
	});
	
	
	Ext.override(Ext.form.Panel, {

		findActivedInput : function() {
			
			return this.getForm().getFields().filterBy(function(object, key){
				return object.isVisible() ;
			});
			
		},
		previousFocus : function(component) {
			var collection = this.findActivedInput();
			var current = component;
			
			if (!current) {
				collection.each(function(input) {
					if (input.hasFocus) current = input;
				});
			}
			
			var previous = collection.getAt(collection.indexOf(current) - 1);
			
			if (current.beforeBlur) {
				current.beforeBlur();
			}
			if(previous) {
				if(previous.xtype === "radiogroup" || previous.xtype === "checkboxgroup") {
					previous.items.get(0).focus(false);
				} else {
					previous.focus(true);
				}
			}
		},
		nextFocus : function(component, event) {
			var collection = this.findActivedInput();
			var current = component;

			if (!current) {
				collection.each(function(input) {
					if (input.hasFocus) current = input;
				});
			}
			var next = collection.getAt(collection.indexOf(current) + 1);
			
			if (current.beforeBlur) {
				current.beforeBlur();
			}
			if(next) {
				if(next.xtype === "radiogroup" || next.xtype === "checkboxgroup") {
					next.items.get(0).focus(true);
				} else {
					next.focus(false);
				}
			}
		}
	});
	
	Ext.override(Ext.form.field.Base, {
		
		initComponent: function() {
			
			this.callOverridden(arguments);
			
		    this.addListener("afterrender", function(component) {
		    	if(this.inputType !== "radio") {
					var nav = new Ext.KeyNav(this.el, {
						'enter' : function(e) {
							if (!Ext.isIE) e.stopEvent();
							component.up("form").nextFocus(component, e);
						},
						'down' : function(e) {
							e.stopEvent();
							component.up("form").nextFocus(component, e);
						},
						'up' : function(e) {
							e.stopEvent();
							component.up("form").previousFocus(component);
						}
					});
		    	}
		    });	

		}
		
		
	});
	
	
});