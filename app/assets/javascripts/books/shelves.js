Ext.onReady(function(){	
	
	Ext.ns('Cordel');

	/**
	* Shelves
	*/
	Cordel.shelfPanelTemplate = new Ext.XTemplate(
		'<div class="shelfBorderBottom"></div>',
		'<div id="{id}-body" class="{baseCls}-body<tpl if="bodyCls"> {bodyCls}</tpl>',
            ' {baseCls}-body-{ui}<tpl if="uiCls">',
                '<tpl for="uiCls"> {parent.baseCls}-body-{parent.ui}-{.}</tpl>',
            '</tpl>"<tpl if="bodyStyle"> style="{bodyStyle}"</tpl>>',
        '</div>'
	);
	
	Ext.define('Cordel.ShelfInternalPanel', {
		extend: 'Ext.panel.Panel',
		alias: ['widget.shelfinternalpanel'],
		initComponent: function() {
			this.renderTpl = Cordel.shelfPanelTemplate;
			Ext.applyIf(this, { bodyCls: 'shelfInter', layout: 'hbox'});
			this.callParent(arguments);
		}
	});
	
	Ext.define('Cordel.ShelfPanel', {
		extend: 'Ext.panel.Panel',
		alias: ['widget.shelfpanel'],
		createBookContainer: function(book) {
			return {
				width: 82, height: 120, layout: 'fit',	style: "margin-right: 15px;",
				html: "<img src='" + book.data.thumb_image_path + "'/>"
			};
		},
		updateBooks: function(books) {
			
			var panel = this;
			var lista = books.data.items.map(function(book){ 
				return book.raw;
			}) ;

			var store = Ext.create('Ext.data.Store', {
				model: 'Book',
				data: {
					books: lista
				},
				proxy: {
					type: 'memory',
					reader:{
						type: 'json',
						root: 'books'
					}
				}
			});

/*
			books.setProxy(Ext.create('Ext.data.proxy.Memory', {
				data: lista
			}));*/



			this.addDocked([{
			    xtype: 'pagingtoolbar', 
				dock: 'bottom', baseCls: 'sheltoolbar',
				layout : {	align: 'middle', type : 'hbox',	pack : 'center'	},
				renderTpl : Cordel.shelfPanelTemplate,
				store: store,
				listeners: {
					change: function( paging, pageData, eOpts ){
						paging.store.getRange(0, paging.store.getTotalCount() ).forEach(function(book){
							panel.items.get(0).add( panel.createBookContainer(book) );
						});						
					}
				}
			}]);
			
		},
		initComponent: function() {
			Ext.applyIf(this, {
			    width: 580,	
				height: 460,
			    layout: 'vbox',	
				bodyCls: 'shelf'
				, items: [
					{xtype: 'shelfinternalpanel'},
					{xtype: 'shelfinternalpanel'},
					{xtype: 'shelfinternalpanel'}
				]
			});
			this.callParent(arguments);
		}
	});
	
	Ext.define('Cordel.ShelfWindow', {
		extend: 'Ext.window.Window',
		loadShelf: function(component) {
			var self = this;
			if( this.shelf_id ) {
				Shelf.load(this.shelf_id, {
					callback: function(shelf) {
						self.setTitle( 'Shelf: ' + shelf.get('name'));
						self.child('shelfpanel').updateBooks( shelf.books() );
					}
				});
			}
		},
		initComponent: function() {
			Ext.applyIf(this, {
			    title: 'Shelf: ',
				frame: true,
				border: "0 0 0 0",	padding: "0 0 0 0",
				bodyBorder: false,
				bodyStyle: { 'background': '#859A89', "border-color": '#CEAE91' },
			    layout: 'fit'
				, items:  [{xtype: 'shelfpanel'}]
				, listeners: {
					afterrender: this.loadShelf
				}
			});
			this.resizable = false;
	        this.callParent();
	    }
	});
	
	//Ext.create(Cordel.ShelfWindow, { shelf_id: 1 }).show();

});