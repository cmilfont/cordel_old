Ext.onReady(function(){	
	
	Ext.ns('Cordel');
	
	/* Panels */
	Ext.define('Cordel.EditBookFormPanel', {
		alias: ['widget.editbookformpanel'],
		extend: 'Ext.form.Panel',
		config: {
			token : Ext.select("meta[name='csrf-token']").first().getAttribute('content'),
			upload : function(){
				var formPanel = this.up('form');
		        var form = formPanel.getForm();
		        if(form.isValid()){

		            
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
						typeAhead:true, 
						forceSelection:false,
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
			        }
				],
		        buttons: [
					{text: 'Save', handler: this.upload},
					{text: 'Reset', handler: this.reset}
				]

			});
			this.callParent(arguments);
			
		}
	});
	
	Ext.define('Cordel.EditBookWindow', {
		extend: 'Ext.window.Window',
		initComponent: function() {
			
			Ext.applyIf(this, {
			    title: 'Update book to your library',
			    width: 540,
			    layout: 'fit',
				items:  [{xtype: 'editbookformpanel'}]
			});
			
	        this.callParent();
	    }
	});
	
	Cordel.fieldsSearchBook = [
		{name: 'id',  type: 'int'},
		{name: 'title',  type: 'string'},
		{name: 'thumb_image_path',  type: 'string'},
		{name: 'user_id',  type: 'int'},
		{name: 'author', mapping:'author.name'}, 
		{name: 'text', convert:function(mixed, record){
			var highlights = "";
			if(record.data.title_highlighted && record.data.title_highlighted.trim().length > 0) 
				highlights += record.data.title_highlighted;
			if(record.data.author_highlighted && record.data.author_highlighted.trim().length > 0) 
				highlights += record.data.author_highlighted;
			if(record.data.pages_content_highlighted && record.data.pages_content_highlighted.trim().length > 0) 
				highlights += record.data.pages_content_highlighted;
			return highlights;
		}},
		'title_highlighted', 'author_highlighted', 'pages_content_highlighted'
	];
	
	Ext.define('Cordel.ViewSearchBookWindow', {
		extend: 'Ext.window.Window',
		initComponent: function() {
	
			Ext.applyIf(this, {
			    title: 'View Book',
			    width: 600,
			    layout: 'fit',
				items: Ext.create('Ext.view.View', {
					id: 'books-view',
					tpl: [
						'<tpl for=".">',
	                    	'<div class="thumb-wrap">',
							'{title}',
	                    	'<div class="thumb"><img src="{thumb_image_path}" title="{title}"></div>',
	                    	'<div class="x-editable">{text}</div></div>',
						'</tpl>',
		                '<div class="x-clear"></div>'
					],
					store: Ext.create('Ext.data.Store', {
						fields: Cordel.fieldsSearchBook,
						data: [ this.data.raw ],
						proxy: { type: 'memory', reader: { type: 'json'} }
					}),
					autoScroll: true,
					multiSelect: true,
					height: 400,
					trackOver: true,
					overItemCls: 'x-item-over',
					itemSelector: 'div.thumb-wrap',
					emptyText: 'No book to display',
					prepareData: function(data) {
						return data;
					}
				})
			});
			this.callParent();
		}
	});
	
	
	//*******************************
	
	Ext.define('Cordel.BookGridPanel', {
		alias: ['widget.bookgridpanel'],
		extend: 'Ext.grid.Panel',
		config: {
			search: function(query) {
				this.getStore().load({params: {query:query} })
			}
		},
		constructor: function(cfg) {  
			this.initConfig(cfg);
			this.callParent();
		},
		initComponent: function() {
			Ext.applyIf(this, {
				
				selModel: {
					mode: "MULTI"
				},
				
				viewConfig: {
					plugins: {
						ddGroup: 'ShelfBook',
						ptype: 'gridviewdragdrop',
						dragText: 'Drag and drop to reorganize'
					}
				},
				
				title: 'Books',
				autoScroll: true,
				height: 200,
				listeners: {
					itemdblclick: function(view, record) {
						var win = Ext.create(Cordel.ViewSearchBookWindow, {data: record });
						win.show();
					}
				},
			    store: Ext.create('Ext.data.Store', {
				    fields: Cordel.fieldsSearchBook,
				    proxy: {
						format: 'json', type  : 'rest', url: '/books/search', reader: { type: 'json' }
				    }
				}),
			    columns: [
			        { header: 'Title',  dataIndex: 'title' },
			        { header: 'Author', dataIndex: 'author',  },
			        { header: 'Text',   dataIndex: 'text', flex: 1 }
			    ]
			});
			this.callParent(arguments);
		}
	});
	
	Ext.define('Cordel.SearchBookFormPanel', {
		alias: ['widget.searchbookformpanel'],
		extend: 'Ext.form.Panel',
		config: {
			token : Ext.select("meta[name='csrf-token']").first().getAttribute('content'),
			search : function(){
				var formPanel = this.up('form');
				formPanel.gridPanel.search( formPanel.getForm().getValues().query );
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
			this.gridPanel = Ext.create('Cordel.BookGridPanel')
			Ext.applyIf(this, {
		        frame: true,
		        bodyPadding: '10 10 0',
		        defaults: {  allowBlank: true, msgTarget: 'side', labelWidth: 50,	xtype: 'textfield'},
		        items: [
					{fieldLabel: 'Search', name: 'query', anchor: '100%'},
					this.gridPanel
				],
		        buttons: [
					{text: 'Search', handler: this.search},
					{text: 'Reset', handler: this.reset}
				]
			});
			this.callParent(arguments);
		}
	});
	
	Cordel.addAuthor = function(link, id, name){
		var formPanel = Ext.getCmp(id);	
		var author = Ext.create('Author', {name:name});
		author.save({
			callback: function() {
				var store = Ext.data.StoreManager.lookup('authorStore');
				store.loadData(author);
				formPanel.down("combo").select(author);
				
				//console.log("setou o id?", formPanel.down("combo").getValue() );
				
				$(link).remove();
			}
		});
		return false;
	}
	
	
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
								'		<img alt="{title}" border="0" src="/assets/cover_thumb.png" title="{title}">',
								'	</a>',
								'</li>'
							];
							
							new Ext.XTemplate(template).append('books', JSON.parse(action.result.book));
							formPanel.up('window').destroy();
		                },
						failure: function(form, action){
							Ext.Msg.alert("Errors", "Tratar errors");
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
				        xtype: 'fieldcontainer',
				        fieldLabel: 'Author',
				       // labelWidth: 100,
				        layout: 'hbox',
				        items: [					{
						    store: Ext.create('Ext.data.Store', {
								listeners: {
									load: function(store, records, successful, operation, options) {
										if(records.length == 0) {											
											var author = formPanel.getForm().findField("book[author_id]");
											var value = author.getValue();
											var author_name = formPanel.down("#author_name");
											author_name.update("<a style='line-height: 22px;' href='#add_author' onclick='Cordel.addAuthor(this, \""+formPanel.id+"\", \""+value+"\")'> you want to add \"" + value + "\" as author?</a>");
										}
									}
								},
								storeId: 'authorStore',
							    fields: ['id', 'name'],
								proxy: {
						        	type: 'ajax', url : '/authors.json',
						        	reader: {
						            	type: 'json'//, root: 'authors'
						        	}
								}
							}),
							name: 'book[author_id]',
							typeAhead:true, 
							minChars: 3,
							typeAheadDelay: 0,
							forceSelection:false,
							allowBlank: false,
						    queryMode: 'remote',
						    displayField: 'name',
						    valueField: 'id',
						    xtype: 'combo',
							listeners: {
								blur: function(field) {
									//field.onLoad();
									field.doRawQuery();
								}
							}
						}, {
				            xtype: 'splitter'
				        },{
							xtype: 'container',
				            itemId: 'author_name',
				            flex: 1
				        }
				        ]
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
			this.callParent(arguments);
			
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
	
	
	Ext.define('Cordel.SearchBookWindow', {
		extend: 'Ext.window.Window',
		initComponent: function() {
			
			Ext.applyIf(this, {
			    title: 'Search books into your library',
			    width: 540,
			    layout: 'fit',
				items:  [{xtype: 'searchbookformpanel'}]
			});
			
	        this.callParent();
	    }
	});
		
});