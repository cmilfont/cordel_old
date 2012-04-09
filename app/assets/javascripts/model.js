Ext.onReady(function(){	
	
	Ext.define('Author', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'id',  type: 'int'},
			{name: 'name',  type: 'string'}
		],
	    validations: [
	        {type: 'presence',  field: 'name'}
	    ]
		, proxy: {
	        type: 'rest', format: 'json', url : '/authors'
	    }
	});

	Ext.define('User', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'id',  type: 'int'},
			{name: 'email',  type: 'string'}
		]
	});
	
	Ext.define('Book', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'id',  type: 'int'},
			{name: 'title',  type: 'string'},
			{name: 'thumb_image_path',  type: 'string'},
			{name: 'user_id',  type: 'int'}
		],
		belongsTo: 'User'
	});
	
	
	Ext.define('Shelf', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'id',  type: 'int'},
	        {name: 'name',  type: 'string'},
	        {name: 'user_id',  type: 'int'}
	    ],
	    validations: [
	        {type: 'presence',  field: 'name'}
	    ]
		, proxy: {
	        type: 'rest', format: 'json', url : '/shelves'
	    }
	    , hasMany  : {model: 'Book', name: 'books'}
	});

});