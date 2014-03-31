/*
	quitar:  	2:tag_rmv:Ventas
				1:tag_rmv:Compras
*/
function loadTagsActions(picklist, tags, agregar) {
	
	var optsExistentes = [];
	var optsRmvTag = [];
	var tagsNamesRmv = [];
	// 1ro guardo todos los opt de remove aca, para ordenarlos alfab. antes de meterlos en el picklist
	var unsortOpts = [];
		
	// cargo todas las Opts existentes: Removes x un lado y el resto x otro
	for(var i=0; i < picklist.options.length ; i++) {
	
		var opt = new Option(picklist.options[i].text, picklist.options[i].value);
		opt.disabled = picklist.options[i].disabled;
		
		if(opt.value.indexOf(QUIT_TAG_ACTION) == -1) {
			optsExistentes.push( opt );
		} else {
			if(opt.value != QUIT_TAG_ACTION) {
				optsRmvTag.push( opt );
			}
		}
		
	}
	
	// reinicio picklist
	picklist.length = 0;
	
	// agrego los que existían MENOS las acciones de remove tag
	var j = 0;
	for(var i=0; i < optsExistentes.length ; i++) {
		picklist.options[j++] = optsExistentes[i];
	}
	
	if(agregar) {

		// Agrego la ETIQUETA de remove tag - Si hay tags de Remove
		if(optsRmvTag.length > 0 || tags.length > 0) {
			var opt = new Option(QUIT_TAG_LBL_TEXT, QUIT_TAG_ACTION);
			opt.disabled = true;
			picklist.options[j++] = opt;
		}
				
		// Agrego los Tags remove
		for(var i=0; i < optsRmvTag.length ; i++) {
			var tagName = parseTagName(optsRmvTag[i].value);
			tagsNamesRmv.push(tagName);
			
			// si el Tag no esta entre los del Email seleccionado
			if( !buscarTag(tagName, tags) ) {
				// agrego la accion tal cual está
				unsortOpts.push( optsRmvTag[i] );
				
			} else {
				// sumo en 1 la cantidad de Emails seleccionados que tienen este tag
				unsortOpts.push( new Option(optsRmvTag[i].text, agregarMismoTag(optsRmvTag[i].value)) );
			}
		}
		
		// agrego los Tags remove que no estaban hasta el momento
		for(var i=0; i < tags.length ; i++) {
			if( !buscarTag(tags[i], tagsNamesRmv) ) {;
				unsortOpts.push( new Option(tags[i], '1:' + QUIT_TAG_ACTION + tags[i]) );
			}
		}
		
	} else {
		
		// itero los Tags remove que estaban hasta el momento
		for(var i=0; i < optsRmvTag.length ; i++) {
			var tagName = parseTagName(optsRmvTag[i].value);
			
			// si el Tag remove no está entre los que hay q borrar
			if( !buscarTag(tagName, tags) ) {
				// agrego la accion tal cual está
				unsortOpts.push( optsRmvTag[i] );
			} else {
				// si quedan Emails con el mismo Tag, vuelvo a agregar la acción de remove tag
				var value = quitarMismoTag(optsRmvTag[i].value);
				if(value != '') {
					unsortOpts.push( new Option(optsRmvTag[i].text, value) );
				}
			}
			
		}
		
		// Agrego la ETIQUETA de remove tag - Si hay tags de Remove
		if(unsortOpts.length > 0) {
			var opt = new Option(QUIT_TAG_LBL_TEXT, QUIT_TAG_ACTION);
			opt.disabled = true;
			picklist.options[j++] = opt;
		}
		
	}
	
	// ordeno opts
	unsortOpts.sort(function(a,b) {
			if(a.text > b.text) return 1;
			if(a.text < b.text) return -1;
			return 0;
		});
		
	for(var i=0; i < unsortOpts.length ; i++) {
		picklist.options[j++] = unsortOpts[i];
	}
		
	picklist.options.selectedIndex = 0;
}

/*
	Ej:  	tag_add:Ventas
			1:tag_rmv:Ventas
*/
function parseTagName(value) {
	if(value.lastIndexOf(':')+1 > 0) {
		var first = value.lastIndexOf(':') + 1;
		var last = value.length;
		return value.substring(first, last);
	}
	return '';
}

function buscarTag(tagName, tags) {
	for(var i=0; i < tags.length ; i++) {
		if(tags[i] == tagName) {
			return true;
		}
	}
	return false;
}

function agregarMismoTag(tagValue) {
	var parts = tagValue.split(':');
	
	var cant = parseInt(parts[0]) + 1;
	var action = parts[1];
	var tagName = parts[2];
	
	return cant + ':' + action + ':' + tagName;
}

function quitarMismoTag(tagValue) {
	var parts = tagValue.split(':');
	
	var cant = parseInt(parts[0]) - 1;
	var action = parts[1];
	var tagName = parts[2];
	
	if(cant <= 0) {
		return '';
	} else {
		return cant + ':' + action + ':' + tagName;
	}
}

function parseActionAndTagName(value) {
	var first = value.indexOf(':');
	var last = value.lastIndexOf(':');
	
	// si es del tipo tag_add:Ventas
	if(first == last) {
		return value;
	} else {
		// si es del tipo 2:tag_add:Ventas
		return value.substring(first+1, value.length);
	}
	
}

function resetActions(picklist, hiddenid, msg) {
	var resultOpt = [];
	
	var hidden = document.getElementById(hiddenid);
	hidden.value = parseActionAndTagName(picklist.value);
		
	// cargo todas las Opts existentes: Removes x un lado y el resto x otro
	for(var i=0; i < picklist.options.length ; i++) {
		var opt = new Option(picklist.options[i].text, picklist.options[i].value);
		opt.disabled = picklist.options[i].disabled;
		
		if(opt.value.indexOf(QUIT_TAG_ACTION) == -1) {
			resultOpt.push( opt );
		}
	}
	
	// reinicio picklist
	picklist.length = 0;
	
	// agrego los que existían MENOS las acciones de remove tag
	var j = 0;
	for(var i=0; i < resultOpt.length ; i++) {
		picklist.options[j++] = resultOpt[i];
	}
	
	// Crear New Tag
	if(hidden.value.indexOf(NEW_TAG_ACTION) >= 0) {
		var newTagName = prompt(msg,"");
		if(newTagName != null && newTagName != '') {
			hidden.value = NEW_TAG_ACTION + newTagName;
		} else {
			hidden.value = '';
		}
	}
}
