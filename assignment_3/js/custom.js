// js

var globalDecimalCount = 0;
var mem = 0;
var equalIsPressed = false;


function allClear() {
	return (document.getElementById('number_area').value == null)||(document.getElementById('number_area').value == "") 
}

// key mapping
function keyIsDown (evt) {
	// console.log("Pressed: " + evt.keyCode);
	switch(evt.keyCode) {
    case 48:
    case 96:
        $("#zero").addClass("button-press");
        break;
    case 46:
    case 110:
        $("#decimal").addClass("button-press");
        break;
    case 13:
    case 187:
    	if (evt.shiftKey) $("#add").addClass("button-press");
    	else { $("#equal").css("background", "#ea5e57"); equalIsPressed = true; }
        break;
    case 49:
    case 97:
        $("#one").addClass("button-press");
        break;
    case 50:
    case 98:
        $("#two").addClass("button-press");
        break;
    case 51:
    case 99:
        $("#three").addClass("button-press");
        break;
    case 52:
    case 100:
        $("#four").addClass("button-press");
        break;
    case 53:
    case 101:
    	$("#five").addClass("button-press");
        break;
    case 54:
    case 102:
        $("#six").addClass("button-press");
        break;
    case 55:
    case 103:
        $("#seven").addClass("button-press");
        break;
    case 56:
    case 104:
    	if (evt.shiftKey) $("#multiply").addClass("button-press");
        else $("#eight").addClass("button-press");
        break;
    case 57:
    case 105:
        $("#nine").addClass("button-press");
        break;
    case 107:
        $("#add").addClass("button-press");
        break;
    case 189:
    case 109:
        $("#subtract").addClass("button-press");
        break;
    case 106:
        $("#multiply").addClass("button-press");
        break;
    case 191:
    case 111:
        $("#divide").addClass("button-press");
        break;
    case 8:
        $("#backspace").addClass("button-press");
        break;
    
    default:
        break;
	}
}

function keyIsUp (evt) {
	// console.log("Released: " + evt.keyCode);
	switch(evt.keyCode) {
    case 48:
    case 96:
        $("#zero").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('0'); equalIsPressed=false;}
        break;
    case 46:
    case 110:
        $("#decimal").removeClass("button-press");
        if (equalIsPressed) equalIsPressed=false;
        break;
    case 13:
        equalIsPressed = true;
        $("#equal").css("background", "#333333");
        if (!allClear()){
            if (globalDecimalCount>0) { 
                try { $("#number_area").val(eval($("#number_area").val().substring(0, $("#number_area").val().length)).toFixed(7)); globalDecimalCount--; }
                catch (err) {alert(err); $('#number_area').val("");}
            }
            else { 
                try { $("#number_area").val(eval($("#number_area").val().substring(0, $("#number_area").val().length))); }
                catch (err) {alert(err); $('#number_area').val("");}
            }
        }
        break;
    case 187:
    	if (evt.shiftKey) $("#add").removeClass("button-press"); 
    	else {
    		equalIsPressed = true;
    		$("#equal").css("background", "#333333");
	    	if (!allClear()){
				if (globalDecimalCount>0) { 
					try { $("#number_area").val(eval($("#number_area").val().substring(0, $("#number_area").val().length - 1)).toFixed(7)); globalDecimalCount--; }
					catch (err) {alert(err); $('#number_area').val("");}
				}
				else { 
					try { $("#number_area").val(eval($("#number_area").val().substring(0, $("#number_area").val().length - 1))); }
					catch (err) {alert(err); $('#number_area').val("");}
				}
			}
		}
        break;
    case 49:
    case 97:
        $("#one").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('1'); equalIsPressed=false;}
        break;
    case 50:
    case 98:
        $("#two").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('2'); equalIsPressed=false;}
        break;
    case 51:
    case 99:
        $("#three").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('3'); equalIsPressed=false;}
        break;
    case 52:
    case 100:
        $("#four").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('4'); equalIsPressed=false;}
        break;
    case 53:
    case 101:
    	$("#five").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('5'); equalIsPressed=false;}
        break;
    case 54:
    case 102:
        $("#six").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('6'); equalIsPressed=false;}
        break;
    case 55:
    case 103:
        $("#seven").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('7'); equalIsPressed=false;}
        break;
    case 56:
    case 104:
    	if (evt.shiftKey) $("#multiply").removeClass("button-press");
        else $("#eight").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('8'); equalIsPressed=false;}
        break;
    case 57:
    case 105:
        $("#nine").removeClass("button-press");
        if(equalIsPressed) { $("#number_area").val('9'); equalIsPressed=false;}
        break;
    case 107:
        $("#add").removeClass("button-press");
        if (equalIsPressed) equalIsPressed=false;
        break;
    case 189:
    case 109:
        $("#subtract").removeClass("button-press");
        if (equalIsPressed) equalIsPressed=false;
        break;
    case 42:
    case 106:
        $("#multiply").removeClass("button-press");
        if (equalIsPressed) equalIsPressed=false;
        break;
    case 191:
    case 111:
        $("#divide").removeClass("button-press");
        if (equalIsPressed) equalIsPressed=false;
        break;
    case 8:
        $("#backspace").removeClass("button-press");
        if ($('#number_area').val()==""||$('#number_area').val()==null)globalDecimalCount=0;
        break;
    default:
        break;
	}
}

function extraDecimal(evt) {
	if(allClear()) { globalDecimalCount=0; equalIsPressed=false; }
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode==46 || charCode==110) {
    	globalDecimalCount++;
    	// if (globalDecimalCount > 1 && !allClear()) return false;
    }
	return true;
}


// jQuery

$(function() {
	globalDecimalCount=0;
	$("#number_area").keypress(function() {
		if ($("#number_area").val().indexOf('.')==-1) globalDecimalCount=0;
	  	console.log( equalIsPressed );
	});

	$.fn.restrictInputs = function(){
	    var targets = $(this);

	    // The characters inside this pattern are accepted
	    // and everything else will be 'cleaned'
	    // For example 'ABCdEfGhI5' become 'ABCEGI5'
	    var pattern = /[^0-9\+\-\*\/\.]*/g; // default pattern

	    var restrictHandler = function(){
	        var val = $(this).val();
	        var newVal = val.replace(pattern, '');

	        // This condition is to prevent selection and keyboard navigation issues
	        if (val !== newVal) {
	            $(this).val(newVal);
	        }
	    };

	    targets.on('keypress', restrictHandler);
	    targets.on('keydown', restrictHandler);
	    targets.on('keyup', restrictHandler);
	    targets.on('paste', restrictHandler);
	    targets.on('change', restrictHandler);
	};

	$('#number_area').restrictInputs();

	// button press event

	$('#zero').on('click',function(){ 
		$("#number_area").val($("#number_area").val() + '0'); 
	});
	$('#one').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('1'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '1'); 
	});	
	$('#two').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('2'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '2'); });
	$('#three').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('3'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '3'); });
	$('#four').on('click',function(){
		if(equalIsPressed) { $("#number_area").val('4'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '4'); });
	$('#five').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('5'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '5'); });
	$('#six').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('6'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '6'); });
	$('#seven').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('7'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '7'); });
	$('#eight').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('8'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '8'); });
	$('#nine').on('click',function(){ 
		if(equalIsPressed) { $("#number_area").val('9'); equalIsPressed=false;}
		else $("#number_area").val($("#number_area").val() + '9'); });
	$('#decimal').on('click',function(){ 
		$("#number_area").val($("#number_area").val() + '.'); globalDecimalCount++; 
	 });
	$('#equal').on('click',function(){
		equalIsPressed = true;
		if (!allClear()){
			if (globalDecimalCount > 0) { 
				try { $("#number_area").val(eval($("#number_area").val()).toFixed(7)); globalDecimalCount--;}
				catch (err) { alert(err); $('#number_area').val("");}
			}
			else { 
					try { $("#number_area").val(eval($("#number_area").val()));}
					catch (err) {alert(err); $('#number_area').val("");}
			 }
		} 
	});
	$('#add').on('click',function(){ $("#number_area").val($("#number_area").val() + '+'); if (equalIsPressed) equalIsPressed=false; });
	$('#subtract').on('click',function(){ $("#number_area").val($("#number_area").val() + '-'); if (equalIsPressed) equalIsPressed=false; });
	$('#multiply').on('click',function(){ $("#number_area").val($("#number_area").val() + '*'); if (equalIsPressed) equalIsPressed=false; });
	$('#divide').on('click',function(){ $("#number_area").val($("#number_area").val() + '/'); if (equalIsPressed) equalIsPressed=false; });
	$('#percent').on('click',function(){
		equalIsPressed = true; 
		if ($("#number_area").val().indexOf('*')>=0) {
			try {$("#number_area").val(eval($("#number_area").val())/100); }
			catch (err){ alert(err); $('#number_area').val("");}
		}
	});
	$('#backspace').on('click',function(){ 
		$("#number_area").val($("#number_area").val().substring(0, $("#number_area").val().length - 1)); 
		if ($('#number_area').val()==""||$('#number_area').val()==null) { globalDecimalCount=0;equalIsPressed=false;} 
		if ($("#number_area").val().indexOf('.')==-1) globalDecimalCount=0;
	});
	$('#inverse').on('click',function(){
		equalIsPressed = true; 
		if (eval($("#number_area").val())!=0) {
			try { $("#number_area").val((1/eval($("#number_area").val())).toFixed(7)); }
			catch (err){alert(err); $('#number_area').val("");}
		}
	 });
	$('#allcancel').on('click',function(){ $("#number_area").val(""); globalDecimalCount=0; equalIsPressed=false;});
	$('#errorcancel').on('click',function(){ 
		$("#number_area").val($("#number_area").val().substring(0, $("#number_area").val().length - 1)); 
		if ($('#number_area').val()==""||$('#number_area').val()==null) { globalDecimalCount=0; equalIsPressed=false; }
		if ($("#number_area").val().indexOf('.')==-1) globalDecimalCount=0;
	 });
	$('#plusminus').on('click',function(){ $("#number_area").val(eval($("#number_area").val())*-1); });
	$('#sqroot').on('click',function(){
		equalIsPressed = true; 
		try { $("#number_area").val(Math.sqrt(eval($("#number_area").val())).toFixed(7)); }
		catch (err) {alert(err); $('#number_area').val("");}
	});
	$('#memadd').on('click',function(){ mem += eval($("#number_area").val()); if (equalIsPressed) equalIsPressed=false; });
	$('#memsub').on('click',function(){ mem -= eval($("#number_area").val()); if (equalIsPressed) equalIsPressed=false; });
	$('#memset').on('click',function(){ mem = eval($("#number_area").val()); if (equalIsPressed) equalIsPressed=false; });	
	$('#memclr').on('click',function(){ mem = 0; if (equalIsPressed) equalIsPressed=false; });
	$('#memret').on('click',function(){ $("#number_area").val(mem); if (equalIsPressed) equalIsPressed=false; });
});
