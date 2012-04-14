$(function(){
	
	$("a[href='#new']").click(function(){
		Ext.create('Cordel.NewBookWindow').show();
		return false;
	});
	
	$("a[href='#search']").click(function(){
		Ext.create('Cordel.SearchBookWindow').show();
		return false;
	});
	
	$("a[href^='#/shelves/']").click(function(){
		var id = $(this).attr("href").replace('#/shelves/', "");
//		console.log( id.replace('#/shelves/', ""));
		Ext.create(Cordel.ShelfWindow, { shelf_id: id }).show();
		return false;
	});
	
})
