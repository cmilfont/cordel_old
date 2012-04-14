Ext.onReady(function(){	
	
	Ext.ns('Cordel');

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
			Ext.applyIf(this, {
				bodyCls: 'shelfInter', 
				layout: 'hbox'
			});
			this.callParent(arguments);
		}
	});
	
	Ext.define('Cordel.ShelfPanel', {
		extend: 'Ext.panel.Panel',
		alias: ['widget.shelfpanel'],
		createBookContainer: function(book) {
			return {
				width: 82, 
				height: 120, 
				layout: 'fit',	
				style: "margin-right: 15px;",
				html: "<img src='" + book.data.thumb_image_path + "'/>"
			};
		},
		changePage: function( paging, pageData, eOpts ) {

			var panel = this,
				shelfinternalpanel1 = panel.items.get(0),
				shelfinternalpanel2 = panel.items.get(1),
				shelfinternalpanel3 = panel.items.get(2),
				pageData = paging.getPageData(),
				fromRecord = pageData.fromRecord - 1,
				store = paging.store;
				
			//console.log("changepage",  paging.store,  pageData);

			shelfinternalpanel1.removeAll(true);
			shelfinternalpanel2.removeAll(true);
			shelfinternalpanel3.removeAll(true);

			store.getRange(fromRecord, fromRecord + 6).forEach(function(book){
				if(book) shelfinternalpanel1.add( panel.createBookContainer(book) );
			});

			fromRecord = fromRecord + 6;
			if(fromRecord < pageData.toRecord) {
				store.getRange(fromRecord, fromRecord + 6).forEach(function(book){
					if(book) shelfinternalpanel2.add( panel.createBookContainer(book) );
				});
			}

			fromRecord = fromRecord + 6;
			if(fromRecord < pageData.toRecord) {
				store.getRange(fromRecord, fromRecord + 6).forEach(function(book){
					if(book) shelfinternalpanel3.add( panel.createBookContainer(book) );
				});
			}

		},
		setShelf: function(shelf) {
			this.updateBooks( shelf.books() );
			this.shelf = shelf;
		},
		updateBooks: function(books) {
			
			var panel = this;
			var lista = books.data.items.map(function(book){ return book.raw; });

			var store = Ext.create('Ext.data.Store', {
				pageSize: 18, 
				model: 'Book',
				data: { books: lista },
				proxy: { type: 'memory', reader:{ type: 'json', root: 'books' }	}
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
					change: {
						fn: this.changePage, 
						scope: this
					}
				}
			}]);
			
		},
		initComponent: function() {
			Ext.applyIf(this, {
			    width: 580,	
				height: 460,
			    layout: 'vbox',
				draggable: true,
				bodyCls: 'shelf'
				, items: [
					{xtype: 'shelfinternalpanel'},
					{xtype: 'shelfinternalpanel'},
					{xtype: 'shelfinternalpanel'}
				]
				, listeners: {
					afterrender: function(panel) {
						var panelDropTargetEl =  panel.body.dom;
						Ext.create('Ext.dd.DropTarget', panelDropTargetEl, {
					        ddGroup: 'ShelfBook',
					        notifyDrop  : function(ddSource, e, data){
					            var selectedRecord = ddSource.dragData.records[0],
									docked = panel.getDockedComponent(0),
									store = docked.store;
								
									console.log("shelf?", panel.shelf);
								
								store.proxy.data.books.push( selectedRecord.raw );
								docked.doRefresh();
					            ddSource.view.store.remove(selectedRecord);
					            return true;
					        }
					    });
						
					}
				}
				
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
						var shelfPanel = self.child('shelfpanel');
						self.setTitle( 'Shelf: ' + shelf.get('name'));
						shelfPanel.setShelf(shelf);
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

});
