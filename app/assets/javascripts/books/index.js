$(function(){
	
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
				$("#list_of_shelves").append("<a href=\"#/shelves/" + shelf.get("id")  + "\"> " + shelf.get("name") + " </a>");
			}
		}).show();
		return false;
	});
	
	$("a[href^='#/shelves/']").click(function(){
		var id = $(this).attr("href").replace('#/shelves/', "");
		Ext.create(Cordel.ShelfWindow, { shelf_id: id }).show();
		return false;
	});
	
	Ext.onReady(function(){

		$(".book_list a img").each(function(index, img){
			var json = JSON.parse( $(img).attr("book") );
			new Ext.dd.DragSource(img, {
				ddGroup: 'ShelfBook'
				, dragData: {
					records: [ Ext.create('Book', json ) ]
				}
			})
		});
		
	});
	
})
