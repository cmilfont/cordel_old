$(function(){
	
	var openShelf = function() {
		var id = $(this).attr("href").replace('#/shelves/', '');
		Ext.create(Cordel.ShelfWindow, {
			shelf_id: id,
			afterDestroy: function(shelf) {
				
			}
		}).show();
		return false;
	};
	
	$("a[href='#new']").click(function(){
		Ext.create('Cordel.NewBookWindow').show();
		return false;
	});
	
	$("a[href='#search']").click(function(){
		Ext.create('Cordel.SearchBookWindow').show();
		return false;
	});
	
	$("a[href='#create']").click(function(){
		Ext.create('Cordel.NewShelfWindow', {
			afterSave: function(shelf) {
				var link = $("<a href=\"#/shelves/" + shelf.get("id") + "\">" + shelf.get("name") + "</a>");
				$("#list_of_shelves").append( link.click(openShelf) );
			}
		}).show();
		return false;
	});
	
	$("a[href^='#/shelves/']").click(openShelf);

	Ext.onReady(function() {
		$(".book_list a img").each(function(index, img){
			var json = JSON.parse( $(img).attr("book") );
			new Ext.dd.DragSource(img, {
				ddGroup: 'ShelfBook',
				dragData: {
					records : [ Ext.create('Book', json) ]
				}
			});
		});		
	});
	
});