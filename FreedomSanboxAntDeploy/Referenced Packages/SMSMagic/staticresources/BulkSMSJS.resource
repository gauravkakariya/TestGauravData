function selectTemplate(elm, id, sessionId){
	if (elm.value== 'None') {
		var textAreaElm = document.getElementById(id);
		textAreaElm.innerHTML = '';
		return;
	}
	if (elm.value == 'NewTp'){
	 	window.location = '/apex/NewSMSTemplate' + '?retURL=/apex/screenmagic__SMSTemplates';
		return;
	}
	try{
	 	var callback = {
			onSuccess:  layoutResults,
			onFailure: queryFailed,
			source : {id: id}
			};
	    sforce.connection.sessionId = sessionId;
		sforce.connection.query("Select screenmagic__Name__c, screenmagic__Text__c From screenmagic__SMS_Template__c where id='"+elm.value+"'", callback);
	}catch(err){
		alert(err);
		}
}

function queryFailed(error) {
	alert("An error has occurred: " + error);
}

function layoutResults(queryResult, source) {
	var records = queryResult.getArray('records');
	var textAreaElm = document.getElementById(source.id);
	textAreaElm.innerHTML = records[0].screenmagic__Text__c;
}

function redirectTo(url,retURL){
   if(retURL) url = url + '?retURL='+retURL;
   parent.location = url;
   return false;    
}

function changeTemplateText(elm, templateTextId, ObjectTypeId, fieldNameId, mainObjectType) {
	var text = document.getElementById(templateTextId).value;
	
	var objectType = document.getElementById(ObjectTypeId).value;
	var objectsRelatedFieldName = document.getElementById(ObjectTypeId)[document.getElementById(ObjectTypeId).selectedIndex].innerHTML;
	var mainObjectType = document.getElementById(mainObjectType).value;
	var prefix = objectsRelatedFieldName.substring(0,1) ;
	var suffix = objectsRelatedFieldName.substring(objectsRelatedFieldName.length-3, objectsRelatedFieldName.length);
	if (mainObjectType != objectsRelatedFieldName && prefix != '$' && suffix == '__c' ){
		//objectsRelatedFieldName  = objectsRelatedFieldName.replace(/__c$/, "__r");
	}		
	var fieldName= document.getElementById(fieldNameId).value;
	if(fieldName == 'None') return false;
	document.getElementById(templateTextId).value = text + "{!"+objectsRelatedFieldName+"."+fieldName +"}";
	
    return false;
}