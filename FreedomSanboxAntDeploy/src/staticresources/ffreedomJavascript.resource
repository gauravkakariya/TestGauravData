/** BatchInsertDefaultEmergencyFundGoal class is One time run script.
	It creates Goal records for Entities which does not contains Goal_Type__c = 'Emergency Fund'
    and whose Parent_Entity__c =NULL.
*
* Author:  Manasi Ranade 
*
* Revision History:
*   Version     Version Author     Date       		 Comments
*   1.0        		 --				--		   		 Initial Draft
	2.0			Manasi Ranade	   23 May 2011		 Commented code from schemeJS function.
													 It was not working properly.
													  
*
*/
function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode
         if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

         return true;
      }

function schemeJS(input,index){     
                               
           
             /*var schemeList = document.getElementById ('myPage:j_id1:j_id4:myForm:investmentAssetPage:tableInvest:' + index + ':scheme');       
             alert(index);                              
            //schemeList.remove(schemeList.selectedIndex);
            schemeList.innerHTML = '';
             alert('Eternus'); 
            schemeAF(input,index);*/  
           	
           	/** Eternus Solutions      **/
			/** Author  : Manasi Ranade*/
			/** Issue Id: F0011      **/
			/** Date    : 23/05/2011 **/
			/** Purpose : Commented above code ,because issue is-
               " document.getElementById ('myPage:j_id1:j_id4:myForm:investmentAssetPage:tableInvest:' + index + ':scheme'); "
               this statement is returning null.
               And we are filling scheme's dropDownList on every selected index changed event of AMC.
               Hence no need to set schemeList.innerHTML = '';  **/
			/****************************************************/
           
            schemeAF(input,index);
                                 
        }

function showTotal(index,price,unit){
            var total=document.getElementById('myPage:j_id1:j_id4:myForm:investmentAssetPage:tableInvest:'+index+':totalfield')
            if(price!=null && unit!=null){
                total.innerHTML='INR '+Number(unit*price);
            }
            else{
                total.innerHTML='INR '+Number(0);
            }    
        }
function yearLength(flds){
    var val = flds.value.length;
    if (val != '0' && val != '4'){
        alert('Year must have exactly four digits');
        setTimeout(function(){flds.focus()}, 10);
    }
}
