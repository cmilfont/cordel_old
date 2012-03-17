Ext.onReady(function(){
	Ext.ns('Cordel');
	
	Ext.define('Cordel.BookFormPanel', {
		alias: ['widget.bookformpanel'],
		extend: 'Ext.form.Panel',
		config: {
			token : Ext.select("meta[name='csrf-token']").first().getAttribute('content'),
			upload : function(){
				var formPanel = this.up('form');
		        var form = formPanel.getForm();
		        if(form.isValid()){
		            form.submit({
		                url: '/books',
						params: { 'authenticity_token': formPanel.token },
		                waitMsg: 'Uploading your book...',
		                success: function(fp, action) {

							var template = [
								'<li>',
								'	<a href="/books/{id}">',
								'	<img alt="{title}" border="0" src="/assets/cover_thumb.png" title="{title}">',
								'	</a>',
								'</li>'
							];

							new Ext.XTemplate(template).append('books', action.result.book);
							formPanel.up('window').destroy();
		                }
		            });
		        }
		    },
			reset : function() { 
				this.up('form').getForm().reset(); 
			}
		},
		constructor: function(cfg) {  
			this.initConfig(cfg);
			this.callParent();
		},
		initComponent: function() {
			
			var formPanel = this;
			
			Ext.applyIf(this, {
		        frame: true,
		        bodyPadding: '10 10 0',
		        defaults: {  allowBlank: false, msgTarget: 'side', labelWidth: 50,	xtype: 'textfield'},
		        items: [
					{xtype: 'hidden', name: 'book[user_id]', value: current_user.id},
					{fieldLabel: 'Title', name: 'book[title]', anchor: '100%'},
					{
					    fieldLabel: 'Author',
					    store: Ext.create('Ext.data.Store', {
						    fields: ['id', 'name'],
							proxy: {
					        	type: 'ajax', url : '/authors.json',
					        	reader: {
					            	type: 'json', root: 'authors'
					        }
							}
						}),
						name: 'book[author_id]',
						typeAhead:false, 
						forceSelection:true,
						allowBlank: true,
					    queryMode: 'remote',
					    displayField: 'name',
					    valueField: 'id',
					    xtype: 'combo'
					},
					{
			            xtype: 'container',
			            anchor: '100%',
			            layout:'column',
			            items:[{
			                xtype: 'container',
			                columnWidth:.5,
			                layout: 'anchor',
						  	defaults: {labelWidth: 50,	xtype: 'textfield'},
			                items: [{anchor: '95%',fieldLabel: 'Publisher', name: 'book[publisher]', allowBlank: true,	xtype: 'textfield'}]
			            },{
			                xtype: 'container',
			                columnWidth:.3,
			                layout: 'anchor',
							defaults: {labelWidth: 50,	xtype: 'textfield'},
			                items: [{anchor: '90%',fieldLabel: 'Edition', name: 'book[edition]', allowBlank: true,	xtype: 'textfield'}]
			            },{
			                xtype: 'container',
			                columnWidth:.1,
			                layout: 'anchor',
							defaults: {labelWidth: 30,	xtype: 'textfield'},
			                items: [
								{ xtype: 'datefield', fieldLabel: 'Year', name: 'book[year]', allowBlank: true, hideTrigger: true, width: 100, format: 'Y'}
							]
			            }]
			        },

					{xtype: 'filefield', emptyText: 'Select an book', fieldLabel: 'Book', name: 'book[file]', buttonText: 'choose', anchor: '100%'}
				],
		        buttons: [
					{text: 'Save', handler: this.upload},
					{text: 'Reset', handler: this.reset}
				]

			});
			this.callParent();
			
		}
	});
	
	Ext.define('Cordel.NewBookWindow', {
		extend: 'Ext.window.Window',
		initComponent: function() {
			
			Ext.applyIf(this, {
			    title: 'Add book to your library',
			    width: 540,
			    layout: 'fit',
				items:  [{xtype: 'bookformpanel'}]
			});
			
	        this.callParent();
	    }
	});
});



$(function(){
	
	$("a[href='#new']").click(function(){
		Ext.create('Cordel.NewBookWindow').show();
		return false;
	});
	
	
})