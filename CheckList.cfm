<!---	filter:progid:DXImageTransform.Microsoft.BasicImage(rotation=1); --->
<CFSCRIPT>
    this.PageName = "Checklist.cfm";
    this.PlanId = 0;
    this.FlightId = 0;
    this.DepartureDate = now();
    this.DepartureHH = hour(this.DepartureDate) + 1;
    this.DepartureMM = Minute(this.DepartureDate);
    
    this.flAirportDepart = "CYXD";
    this.flAirportArrive = "CYXD";
    
    this.ArrivalDate = now();
    this.ArrivalHH = 0;  this.ArrivalMM = 0;
    
    this.flATISWith = "A";
      
   this.flSquawk1 = 1;  this.flSquawk2 = 2;   this.flSquawk3 = 0;   this.flSquawk4 = 0;
          
   this.flWindDirection = 270;  this.flWindSpeed = 10;
   
   this.Variation = "-20";
          
   this.flTemperature = 15;
   this.flDewpoint = 10;
         
   this.flPressureA = 29;  this.flPressureB = 92;     
   this.flHoldShort = 30;  this.flActiveRunway = 30;
      
    
   this.flHobbsStart = 0;   this.flHobbsEnd = 0;
   this.flTachStart = 0;   this.flTachEnd = 0;

    this.flTBINextService = 0;   this.flTBILastService = 0;  this.flTBIRecentHours = 0;  this.flTBI = 0;
    
    this.Mode = "VIEW";
    if ( IsDefined("URL.Mode") ) {
       this.Mode = URL.Mode;
    }
    
    if ( IsDefined("URL.PLANID") ) {
       this.PlanId = URL.PlanId;
    }
    if ( IsDefined("URL.FLIGHTID") ) {
       this.FlightId = URL.FlightId;
    }
</CFSCRIPT>

<CFIF IsDefined("CrewLogin") EQ FALSE>
   <CFLOCATION URL="#Application.Pagelogin#">
</CFIF>

<!--- ----------------------------------------------------------------------------
      SQL
----------------------------------------------------------------------------- --->
<CFIF this.Mode EQ "EDITPOST">


   <CFQUERY NAME="PlanUpdate" DATASOURCE="#Application.DSN#">
      <CFIF this.FlightId GT 0>       
       UPDATE 
          dbo.tbl_FlightLog
          
       SET
          flDepartureDt = '#DateFormat(now(),"YYYY-MM-DD")# #form.flDepartureHH#:#form.flDepartureMM#:00',
          flArrivalDt = '#DateFormat(now(),"YYYY-MM-DD")# #form.flArrivalHH#:#form.flArrivalMM#:00',
          flHobbsStart = #val(form.flHobbsStart)#,
          flHobbsEnd = #val(form.flHobbsEnd)#,
          flTachStart = #val(form.flTachStart)#,   
          flTachEnd = #val(form.flTachEnd)#,
          
          flATISWith = '#form.flATISWITH#',
          flSquawk = '#form.flSquawk1##form.flSquawk2##form.flSquawk3##form.flSquawk4#',
          
          flWindDirection =  #val(form.flWindDirection)#,
          flWindSpeed = #val(form.flWindSpeed)#,
          
          flTemperature = #val(form.flTemperature)#,
          flDewpoint = #val(form.flDewPoint)#,
          
          flPressure = '#form.flPressureA#.#form.flPressureB#',
          flHoldShort = #val(form.flHoldShort)#,
          flActiveRunway =  #val(form.flActiveRunway)#,
                             
          flTBINextService = #val(form.flTBINextService)#,
          flTBILastService = #val(form.flTBILastService)#,
          flTBIRecentHours = #val(form.flTBIRecentHours)#,
          flTBI = #val(form.flTBI)#,
          
          flNotes = '#form.flNotes#',
          
          WBBEW = #val(form.WBBEW)#,
          WBPilot = #val(form.WBPilot)#,
          WBFrontPassenger = #val(form.WBFrontPassenger)#,
          WBRearPassengers = #val(form.WBRearPassengers)#,
          WBCargo = #val(form.WBCargo)#,
          WBZeroFuelWeight = #val(form.WBZeroFuelWeight)#,
          WBFuelQuantity = #val(form.WBFuelQuantity)#,
          WBFuelWeightPerUnit = #val(form.WBFuelWeightPerUnit)#,
          WBFuelWeight = #val(form.WBFuelWeight)#,

          WBAllUpWeight = #val(form.WBAllUpWeight)#,
          WBPreTakeOffBurn = #val(form.WBPreTakeOffBurn)#,
          WBTakeOffWeight = #val(form.WBTakeOffWeight)#

       WHERE
          flId = #this.FlightId#
       </CFIF>      

      <CFIF this.PlanId GT 0>  
       UPDATE dbo.tblFlightPlan SET DepartDateTime = '#DateFormat(now(),"YYYY-MM-DD")# #form.flDepartureHH#:#form.flDepartureMM#:00'
       WHERE
          PlanId = #this.PlanId#
      </CFIF>         
         
   </CFQUERY>
   <!--- <CFLOCATION URL="#this.PageName#?MODE=View" > --->
</CFIF>


<CFQUERY NAME="rsPlan" DATASOURCE="#Application.DSN#">
       SELECT TOP 1 * FROM dbo.tblFlightPlan 
       <CFIF val(this.PlanId) GT 0>
          WHERE PlanId = #this.PlanId#
       </CFIF>
       ORDER BY PlanId Desc
</CFQUERY>

<CFQUERY NAME="rsFlight" DATASOURCE="#Application.DSN#">
       SELECT TOP 1 * FROM dbo.tbl_FlightLog 
       <CFIF val(this.FlightId) GT 0>
          WHERE flId = #this.FlightId#
       </CFIF>
       ORDER BY flId Desc
</CFQUERY>

<CFSCRIPT>
   this.FlightId = rsFlight.flId;
   
   
   this.flAirportDepart = rsFlight.flAirportDepart;
   this.flAirportArrive = rsFlight.flAirportArrive;
   
   
   if ( rsFlight.flDepartureDt GT "" ) {
      this.DepartureHH = hour(rsFlight.flDepartureDt); 
      this.DepartureMM = right("00" & Minute(rsFlight.flDepartureDt), 2);

   }
   if ( rsFlight.flArrivalDt GT "" ) {
      this.ArrivalHH = hour(rsFlight.flArrivalDt); 
      this.ArrivalMM = right("00" & Minute(rsFlight.flArrivalDt), 2);
   }
   this.flHobbsStart = rsFlight.flHobbsStart;
   this.flHobbsEnd = rsFlight.flHobbsEnd;
   this.flTachStart = rsFlight.flTachStart;
   this.flTachEnd = rsFlight.flTachEnd;
   
   
   this.flATISWith = rsFlight.flATISWITH;
      
   this.flSquawk1 = left(rsFlight.flSquawk,1);
   this.flSquawk2 = Mid(rsFlight.flSquawk,2,1);
   this.flSquawk3 = Mid(rsFlight.flSquawk,3,1);
   this.flSquawk4 = Mid(rsFlight.flSquawk,4,1);
          
   this.flWindDirection =  rsFlight.flWindDirection;
   this.flWindSpeed = rsFlight.flWindSpeed;
          
   this.flTemperature = rsFlight.flTemperature;
   this.flDewpoint = rsFlight.flDewPoint;
         
   this.flPressureA = left(rsFlight.flPressure,2);
   this.flPressureB = right(rsFlight.flPressure,2);     
   this.flHoldShort = rsFlight.flHoldShort;
   
   if ( val(this.flHoldShort) EQ 0 ) {
      this.flHoldShort = 30;
   }
   
   this.flActiveRunway =  rsFlight.flActiveRunway;
   
   if ( val(this.flActiveRunway) EQ 0 ) {
      this.flActiveRunway = 30;
   }
     

   this.flTBINextService = rsFlight.flTBINextService;
   this.flTBILastService = rsFlight.flTBILastService;
   this.flTBIRecentHours = rsFlight.flTBIRecentHours;
   this.flTBI = rsFlight.flTBI;

   this.WBBEW = rsFlight.WBBEW;
   this.WBPilot = rsFlight.WBPilot;
   this.WBFrontPassenger = rsFlight.WBFrontPassenger;
   this.WBRearPassengers = rsFlight.WBRearPassengers;
   this.WBCargo = rsFlight.WBCargo;
   this.WBZeroFuelWeight = rsFlight.WBZeroFuelWeight;
   this.WBFuelQuantity = rsFlight.WBFuelQuantity;
   if ( this.WBFuelQuantity EQ 0 ) {
      this.WBFuelQuantity = 38;
   }
   this.WBFuelWeightPerUnit = rsFlight.WBFuelWeightPerUnit;
   this.WBFuelWeight = rsFlight.WBFuelWeight;
   
   this.WBAllUpWeight = rsFlight.WBAllUpWeight;
   this.WBPreTakeOffBurn = rsFlight.WBPreTakeOffBurn;
   this.WBTakeOffWeight = rsFlight.WBTakeOffWeight;

</CFSCRIPT>
   
<CFSET this.PlanId = rsPlan.PlanId>


<!--- --------------------------------------------------------------------------
      Javascript
 -------------------------------------------------------------------------- --->
<CFOUTPUT>
<CFINCLUDE TEMPLATE="jsRight.cfm">
<SCRIPT LANGUAGE="Javascript">

function fnDepart() {
   frm = document.forms[0];

   var Depart = new Date()
  
   frm.flDepartureHH.value = Depart.getHours();
   frm.flDepartureMM.value = right("00" + Depart.getMinutes() + "", 2);
   
   fnDepartUpdate();
}


function fnArrive() {
   frm = document.forms[0];

   var Arrive = new Date()
  
   frm.flArrivalHH.value = Arrive.getHours();
   frm.flArrivalMM.value = right("00" + Arrive.getMinutes() + "", 2);

   fnArriveUpdate();
}


function showClock() {
  objClock = document.getElementById("clock");

  var Digital = new Date()
  var UTC = new Date (Digital);
  
  var hours=Digital.getHours();
  var minutes=Digital.getMinutes();
  var seconds=Digital.getSeconds();
  var ctime=hours + ":" + right("00" + minutes,2) + ":" + right("00" + seconds,2) + " ";
  clock24.innerHTML= "&nbsp;<B>" + ctime + "</B>";
    
  var dn="AM";
  if ( hours > 12 ) { dn="PM"; hours=hours-12; }
  if ( hours == 0 ) { hours=12; }
  if ( minutes <= 9 ) { minutes="0"+minutes; }
  if ( seconds <= 9 ) { seconds = "0"+seconds; }
  var ctime=hours+":"+minutes+":"+seconds+" "+dn;
  objClock.innerHTML= " &nbsp;" + ctime;
    
  UTC.setHours ( Digital.getHours() + 6 );

  var hours=UTC.getHours();
  var minutes=UTC.getMinutes();
  var seconds=UTC.getSeconds();
  var ctime=hours + ":" + right("00" + minutes,2) + ":" + right("00" + seconds,2) +" ";
  clockUTC.innerHTML= "&nbsp;UTC:&nbsp;<B>" + ctime + "</B>&nbsp;";
  
  setTimeout("showClock()",1000);
}

function fnGoPlan() {
   parent.location = "FlightPlan.cfm?PLANID=#this.PlanId#";
}

function fnGoFlight() {
   parent.location = "FlightEdit.cfm?MODE=EDITINIT&FLID=#this.FlightId#";
}

function fnAllShow() {
   fnWeightShow();    fnStartupShow();   fnATISShow();   fnDepartShow();  fnTakeOffShow();   fnCruiseShow();
   fnArriveShow();   fnCircuitShow();   fnBriefShow();   fnSpeedsShow();   fnATISShow();
}

function fnAllHide() {
   fnWeightHide();   fnStartupHide();   fnATISHide();   fnTakeOffHide();   fnDepartHide();
   fnCruiseHide();   fnArriveHide();   fnCircuitHide();   fnBriefHide();   fnSpeedsHide();
}

function fnStartupFocus() { fnAllHide();  fnStartupShow(); }

function fnATISFocus() { fnAllHide();  fnATISShow(); }

function fnDepartFocus() { fnAllHide();  fnDepartShow(); }

function fnTakeOffFocus() {  fnAllHide();  fnTakeOffShow(); }

function fnCruiseFocus() { fnAllHide();  fnCruiseShow(); }

function fnArriveFocus() { fnAllHide();  fnArriveShow(); }

function fnCircuitFocus() { fnAllHide();  fnCircuitShow(); }

function fnWeightFocus() { fnAllHide();  fnWeightShow(); }

function fnBriefFocus() {  fnAllHide();  fnBriefShow(); }

function fnSpeedsFocus() { fnAllHide();  fnSpeedsShow(); }


function fnStartupShow() {  oBlock = document.getElementById("DivStartup");    oBlock.style.display = "block"; }
function fnStartupHide() {  oBlock = document.getElementById("DivStartup");    oBlock.style.display = "none"; }
function fnATISShow() {     oBlock = document.getElementById("DivATIS");       oBlock.style.display = "block"; }
function fnATISHide() {     oBlock = document.getElementById("DivATIS");       oBlock.style.display = "none"; }
function fnTakeOffShow() {  oBlock = document.getElementById("DivTakeOff");    oBlock.style.display = "block"; }
function fnTakeOffHide() {  oBlock = document.getElementById("DivTakeOff");    oBlock.style.display = "none"; }
function fnCruiseShow() {   oBlock = document.getElementById("DivCruise");     oBlock.style.display = "block"; }
function fnCruiseHide() {   oBlock = document.getElementById("DivCruise");     oBlock.style.display = "none"; }
function fnDepartShow() {   oBlock = document.getElementById("DivDepart");     oBlock.style.display = "block"; }
function fnDepartHide() {   oBlock = document.getElementById("DivDepart");     oBlock.style.display = "none"; }
function fnArriveShow() {   oBlock = document.getElementById("DivArrive");     oBlock.style.display = "block"; }
function fnArriveHide() {   oBlock = document.getElementById("DivArrive");     oBlock.style.display = "none"; }
function fnWeightShow() {   oBlock = document.getElementById("DivWeight");     oBlock.style.display = "block"; }
function fnWeightHide() {   oBlock = document.getElementById("DivWeight");     oBlock.style.display = "none"; }
function fnCircuitShow() {  oBlock = document.getElementById("DivCircuit");    oBlock.style.display = "block";}
function fnCircuitHide() { oBlock = document.getElementById("DivCircuit");    oBlock.style.display = "none"; }
function fnBriefShow() { oBlock = document.getElementById("DivBrief");  oBlock.style.display = "block"; }
function fnBriefHide() { oBlock = document.getElementById("DivBrief"); oBlock.style.display = "none"; }
function fnSpeedsShow() { oBlock = document.getElementById("DivSpeeds");   oBlock.style.display = "block"; }
function fnSpeedsHide() {  oBlock = document.getElementById("DivSpeeds");   oBlock.style.display = "none"; }


function fnSave() {
   frm = document.forms[0];
   
   frm.btnSave.caption = "Please Wait...";
   frm.submit();
   return false;
}


function fnXWind() {
    frm = document.forms[0];
    
    if (
        frm.flActiveRunway.value == ""  || 
        frm.flWindDirection.value == "" ||
        frm.flWindSpeed.value == "") {
      // alert("Runway heading, Wind direction and Speed are required")
      return false;
    }
    
    
 d = "";
 g = "";
 l = frm.flActiveRunway.value;
		n = frm.flWindDirection.value;
		k = frm.flWindSpeed.value;
		
		n = n / 10;  
				
		o = Math.abs(n - l);
		oo = (n - l); //determine left or right relative wind
		p = .0174*o;
		q = Math.abs(k*(Math.sin(p)));
		m = Math.abs(k*(Math.cos(p)));
		
		frm.flXWind.value = eval(Math.round(q));
		
		// flHeadWind
		
		frm.cwresultloss.value = eval(Math.round(m));
  
		if (oo < 0){
			d = "left";
			frm.d.value=d;
		}
		if (oo > 0){
			d = "right";
			frm.d.value=d;
		}
		if (oo == 0){
			d = "none";
			frm.d.value=d;
		}
		if (oo == 360){
			d = "none";
			frm.d.value=d;
		}
		if (oo == 180){
			d = "none";
			frm.d.value=d;
		}

		//gain wind is behind and helping -- loss wind is from ahead and hurting
		 if (o > 90){
				g = "gain";
				frm.g.value=g;
		}
		if (o < 90.0000000000000001){
				g = "loss";
				frm.g.value=g;
		}
		if (o > 270){
				g = "loss";
				frm.g.value=g;
		}
}


function fnHumidity() {
  frm = document.forms[0];
  var t, dew, humidity;
  
  t = parseInt(frm.flTemperature.value);
  dew = (frm.flDewPoint.value);

  dew = parseInt(dew);
  humidity = Math.exp(17.27*(dew/(dew+237.3)-t/(t+237.3)))*100;
  
  frm.flHumidity.value = (Math.round(humidity));
}


function fnParseFloat(cValue) {
 
  var nValue = parseFloat(cValue);
  if ( nValue - 0 == cValue ) { return nValue; } else { return 0; }
  
}

</SCRIPT>
</CFOUTPUT>  

<CFOUTPUT>  
<!--- <cfajaxproxy cfc="FlightUpdate" jsclassname="clsFlightUpdate"> --->

<script type="text/javascript">
    _cf_loadingtexthtml="<img alt=' ' src='CFIDE/scripts/ajax/resources/cf/images/loading.gif'/>";
    _cf_contextpath="";
    _cf_ajaxscriptsrc="CFIDE/scripts/ajax";
    _cf_jsonprefix='//';
</script>
<script type="text/javascript" src="CFIDE/scripts/ajax/messages/cfmessage.js"></script>
<script type="text/javascript" src="CFIDE/scripts/ajax/package/cfajax.js"></script>

<script type="text/javascript">
	ColdFusion.Ajax.importTag('CFAJAXPROXY');
</script>

<script type="text/javascript">
	var _cf_DepartUpdate=ColdFusion.AjaxProxy.init('FlightUpdate.cfc','clsFlightUpdate');
	_cf_DepartUpdate.prototype.DepartUpdate=function(PlanId,FlightId,DepartTime) 
     { return ColdFusion.AjaxProxy.invoke(this, "DepartUpdate", {PlanId:#this.PlanId#, FlightId:#this.FlightId#, DepartTime:'#DATEFORMAT(now(),"YYYY-MM-DD")# ' + frm.flDepartureHH.value  + ':' + frm.flDepartureMM.value } ); };

	var _cf_ArriveUpdate=ColdFusion.AjaxProxy.init('FlightUpdate.cfc','clsFlightUpdate');
	_cf_ArriveUpdate.prototype.ArriveUpdate=function(PlanId,FlightId,ArriveTime) 
     { return ColdFusion.AjaxProxy.invoke(this, "ArriveUpdate", {PlanId:#this.PlanId#,FlightId:#this.FlightId#, ArriveTime:'#DATEFORMAT(now(),"YYYY-MM-DD")# ' + frm.flArrivalHH.value  + ':' + frm.flArrivalMM.value } ); };
     

	var _cf_fnHobbsStartUpdate=ColdFusion.AjaxProxy.init('FlightUpdate.cfc','clsFlightUpdate');
	_cf_fnHobbsStartUpdate.prototype.fnHobbsStartUpdate=function(PlanId,FlightId,ArriveTime) 
     { return ColdFusion.AjaxProxy.invoke(this, "fnHobbsStartUpdate", {PlanId:#this.PlanId#,FlightId:#this.FlightId#,HobbsTime:HobbsTime} ); };

	var _cf_fnHobbsEndUpdate=ColdFusion.AjaxProxy.init('FlightUpdate.cfc','clsFlightUpdate');
	_cf_fnHobbsEndUpdate.prototype.fnHobbsEndUpdate=function(PlanId,FlightId,ArriveTime) 
     { return ColdFusion.AjaxProxy.invoke(this, "fnHobbsEndUpdate", {PlanId:#this.PlanId#,FlightId:#this.FlightId#,HobbsTime:HobbsTime} ); };
</script>
 
     
 <SCRIPT LANGUAGE="Javascript">
   <!--
      frm = document.forms[0];
      
      var FlightCFC = new clsFlightUpdate(); 
      var nReturnCode = 0;
      var nErrorCount = 0;

      function fnDepartUpdate() {
           FlightCFC.setCallbackHandler(fnUpdateComplete); 
           FlightCFC.setErrorHandler(fnErrorHandlerJS);
           dtFlight = "#DATEFORMAT(now(),'YYYY-MM-DD')# " + frm.flDepartureHH.value + ":" + frm.flDepartureMM.value + ":00" 
           //alert(dtFlight);
           //FlightCFC.DepartUpdate( PlanId=#this.PlanId#, FlightId=#this.FlightId#, DepartTime=dtFlight );
		}
        
       function fnArriveUpdate() {
           FlightCFC.setCallbackHandler(fnUpdateComplete); 
           FlightCFC.setErrorHandler(fnErrorHandlerJS);
           dtFlight = "#DATEFORMAT(now(),'YYYY-MM-DD')# " + frm.flArrivalHH.value + ":" + frm.flArrivalMM.value + ":00" 
           //alert(dtFlight);
           //FlightCFC.ArriveUpdate( PlanId=#this.PlanId#, FlightId=#this.FlightId#, ArriveTime=dtFlight );
		}

       function fnHobbsStartUpdate() {
           FlightCFC.setCallbackHandler(fnUpdateComplete); 
           FlightCFC.setErrorHandler(fnErrorHandlerJS);
           FlightCFC.fnHobbsStartUpdate( PlanId=#this.PlanId#, FlightId=#this.FlightId#,  HobbsTime="9999.1");
		}
        
       function fnHobbsEndUpdate() {
           FlightCFC.setCallbackHandler(fnUpdateComplete); 
           FlightCFC.setErrorHandler(fnErrorHandlerJS);
           FlightCFC.fnHobbsEndUpdate( PlanId=#this.PlanId#, FlightId=#this.FlightId#, HobbsTime="9999.1");
		}
      
      function fnUpdateComplete(objCFCReturn) {
          // nFlightId = parseInt(objCFCReturn.FLIGHTID,RETCODE,10);
      }

      function fnErrorHandlerJS(statusCode, statusMsg) {
          alert('Status: ' + statusCode + ', ' + statusMsg );
          if ( statusCode > 4 ) {
          }
      }
   -->
   </SCRIPT>
</CFOUTPUT> 


   
<CFOUTPUT>   
<HTML>
<HEAD>
	<LINK REL=STYLESHEET HREF="C172StylesF.css" TYPE="text/css">
	<LINK REL=STYLESHEET HREF="#Application.css#" TYPE="text/css">
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE>CheckList</TITLE>
</HEAD>
<STYLE>
  INPUT.btn 
  { 
    border-radius: 7pt;
    border-style: 2pt outset solid AA55BB;
    font-size: 48;
  }
  
  INPUT.text { font-size: 48; background-color: AABBCC; }
  
  INPUT.textTBI  {  font-size: 48;  background-color: CCDDEE; Padding-Right: 8 }
  
  INPUT.textWB {  font-size: 48;  background-color: CCDDEE; Padding-Right: 8 }
  
  INPUT.text48 { font-size: 48; background-color: AABBCC; Padding-Right: 3; Padding-Left: 3}
  
  
</STYLE>

<BODY OnLoad="showClock();" BGCOLOR="##AAAAAA" >


<DIV OnClick="parent.location='Cessna911.htm'">
<!--- Clock ------------------------------------------------------------------->
<TABLE WIDTH=100% BGCOLOR="##FFEEEE" CELLSPACING=5>
  <TR>
      
    <TD ALIGN=CENTER NOWRAP>
       <span id=clock24 STYLE="color: DarkBlue; font-family: Arial; font-size: 52pt" > #TimeFormat(now(),"HH:MM:SS")# </span>

    <TD NOWRAP>
       <span id=clock STYLE="color: Grey; font-family: Arial; font-size: 36pt" > </span>
       
    <TD ALIGN=RIGHT NOWRAP>
       <span id=clockUTC STYLE="background-color: Black; color: yellow; font-family: Arial; font-size: 52pt" > </span>
</TABLE>


<!--- PANICS ------------------------------------------------------------------->
<TABLE CELLSPACING=1 WIDTH=100% CELLPADDING=1 BGCOLOR=##BBBBBB>
   <TR>
       <TD WIDTH=30% CLASS=TITLE>Cessna 172M / 152  
       <TD CLASS=Panics><SPAN CLASS=E1>A</SPAN>viate  
       <TD CLASS=Panics><SPAN CLASS=E1>N</SPAN>avigate
       <TD CLASS=Panics><SPAN CLASS=E1>I</SPAN>nvestigate 
       <TD CLASS=Panics><SPAN CLASS=E1>C</SPAN>ommunicate 
       <TD CLASS=Panics><SPAN CLASS=E1>S</SPAN>ecure 
 </TABLE>
 </DIV>


<!--- BUTTONS ------------------------------------------------------------------->
<FORM NAME="myForm" ACTION="#this.PageName#?MODE=EDITPOST&FLightId=#this.FlightId#&PLANID=#this.PlanId#" METHOD=POST>


<TABLE WIDTH=100% CELLPADDING=5 CELLSPACING=5 > 

<TR> 
<TD ALIGN=RIGHT>
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnAllShow" VALUE=" ALL " OnClick="fnAllShow();" Style="text-align: center; background-color: BLACK; COLOR: white; font-size: 64"> &nbsp; &nbsp; &nbsp;
<INPUT class=btn TYPE="BUTTON" NAME="btnMenu" VALUE="&nbsp; MENU &nbsp;"    OnClick="parent.location='menu.cfm'"  STYLE="background-color: green; color: white; font-size: 64 " > &nbsp; &nbsp; &nbsp;
<INPUT CLASS=btn TYPE="SUBMIT" NAME="btnSave" VALUE=" SAVE " STYLE="background-color: green; color: white; font-size: 64" > &nbsp; &nbsp; &nbsp;

<TR><TD ALIGN=CENTER>
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnStartup" VALUE="&nbsp; START &nbsp;" OnClick="fnStartupFocus();" >   &nbsp; &nbsp; &nbsp;
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnDepart1" VALUE="DEPAR&uArr;" OnClick="fnDepartFocus();"  Style="font-size: 64 " > &nbsp; &nbsp; &nbsp;
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnArrive" VALUE="ARR&dArr;VE " OnClick="fnArriveFocus();" Style="font-size: 64 " > &nbsp; &nbsp; &nbsp;


<TR><TD ALIGN=CENTER>
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnWeight" VALUE="W&B,TBI" OnClick="fnWeightFocus();"  >  &nbsp; &nbsp; &nbsp;
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnBrief" VALUE="&nbsp; BRIEF &nbsp;" OnClick="fnBriefFocus();"  >  &nbsp; &nbsp; &nbsp;
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnATIS" VALUE="ATIS" OnClick="fnATISFocus();"  >  

<TR>
<TD ALIGN=CENTER>
<INPUT class=btn TYPE="BUTTON" NAME="btnPlan" VALUE="&nbsp; PLAN: #this.PlanId# &nbsp;"    OnClick="fnGoPlan();"  Style="font-size: 48 " >  &nbsp; &nbsp; &nbsp;
<INPUT class=btn TYPE="BUTTON" NAME="btnFlight" VALUE="&nbsp; FLIGHT: #this.FlightId# &nbsp;"  OnClick="fnGoFlight();"  Style="font-size: 48 " > 

<TR><TD ALIGN=CENTER>
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnCircuit" VALUE="&nbsp; CIRCUIT &nbsp;" OnClick="fnCircuitFocus();"  >  &nbsp; &nbsp; &nbsp;
<INPUT CLASS=btn TYPE="BUTTON" NAME="btnSpeeds" VALUE="&nbsp; SPEEDS &nbsp;" OnClick="fnSpeedsFocus();"  >&nbsp; &nbsp; &nbsp; 
<INPUT CLASS=btn TYPE="BUTTON" Style="text-align: center; background-color: RED" VALUE="&nbsp;&nbsp;&nbsp; 911 &nbsp;&nbsp;&nbsp;" OnClick="parent.location='Cessna911.htm'" >  &nbsp; &nbsp; &nbsp;

</TABLE><BR><BR>

#fnStart()#
#fnATIS()#
#fnDepart()#
#fnTakeOff()#

<DIV ID="DivCruise">
<TABLE bgcolor=##EEDDDD BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=100%>
   #fnCruise()#
      
</TABLE>
</DIV>

#fnArrive()#
#fnSpeeds()#
#fnCircuit()#
#fnBrief()#
#fnWeight()#


<TABLE WIDTH=100%>
<TR>
<TD>
<TEXTAREA STYLE="font-size: 32; font-weight: Bold" NAME="flNotes" COLS=50 ROWS=10>#rsFlight.flNotes#</TEXTAREA>
<TR>
 <TD ALIGN=RIGHT>
 <INPUT CLASS=btn TYPE="SUBMIT" NAME="btnSave" VALUE=" SAVE " STYLE="background-color: green; color: white; font-size: 64" > &nbsp; &nbsp; &nbsp;
</TABLE>




<SCRIPT LANGUAGE="Javascript">
   fnXWind();
   fnHumidity();
  
</SCRIPT>

</BODY>




</HTML>
</CFOUTPUT>


<!--- Start ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnStart" OUTPUT=TRUE>
 
<DIV ID="DivStartup">
<TABLE bgcolor="##EEDDDD" BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=100%>
  <TR>	    
     <TD CLASS=SecHeading COLSPAN=3>PRE-ENGINE START
     
  <!---  <TR><TD CLASS=ListNum>1<TD CLASS=ListItemTime>Hobbs, Tach              <TD CLASS=ListTaskTime>RECORD --->
  <TR><TD CLASS=ListNum>1
      <TD CLASS=ListItemTime COLSPAN=2 STYLE="Padding-bottom: 10 " ALIGN=RIGHT>HOBBs:&nbsp;
        <INPUT TYPE="TEXT" SIZE=6 NAME="flHobbsStart"  STYLE="font-size: 64"
           <CFIF this.flHobbsStart GT 0>
             VALUE="#this.flHobbsStart#" 
           </CFIF>
           STYLE="Text-ALign: right"> 
           
        TACH:&nbsp;
        <INPUT TYPE="TEXT" SIZE=6 NAME="flTachStart" STYLE="font-size: 64"
           <CFIF this.flTachStart GT 0>
             VALUE="#this.flTachStart#" 
           </CFIF>
           STYLE="Text-ALign: right"> &nbsp;&nbsp;&nbsp;
           
  <!---
  <TR><TD CLASS=ListNum>
      <TD CLASS=ListItemTime COLSPAN=2 STYLE="Padding-bottom: 10 " ALIGN=RIGHT>
       
  <TR><TD>&nbsp; --->
        
  <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>TowBar, Chalks, Ties  <TD CLASS=ListTask>REMOVED 
  <TR><TD CLASS=ListNum>3<TD CLASS=ListItem Style="Border: none">Pass. Brief          <TD Style="Border: none" CLASS=ListTask>COMPLETE 
                                    
  <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Seats &amp; Belts    <TD CLASS=ListTask>SECURE 
  <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Brake Press.         <TD CLASS=ListTask>CHK     
  <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Park Brake           <TD CLASS=ListTask>SET 
  <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Circuit Breakrs      <TD CLASS=ListTask>CHK IN 
  <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Radios, Elecs        <TD CLASS=ListTask>OFF 
  <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Avionics Mast.       <TD CLASS=ListTask>OFF 
  <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Fuel Select         <TD CLASS=ListTask>LEFT <FONT COLOR=##AAAAAA> / ON C152
  <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Controls            <TD CLASS=ListTask>FREE &amp; CORR.
  <TR><TD>&nbsp;

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>ENGINE START 
 <TR>
    <TD CLASS=ListNum>1<TD CLASS=ListItem>Mixture                  <TD CLASS=ListTask>RICH 
	    <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Carb Heat          <TD CLASS=ListTask>COLD 
	    <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Mast. Switch       <TD CLASS=ListTask>ON 
	    <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Lights             <TD CLASS=ListTask>ON / AS REQ. *Beacon
	    <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Throttle           <TD CLASS=ListTask>&frac14;" <FONT COLOR=##AAAAAA>/ 1/8" C152
	    <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Prime              <TD CLASS=ListTask>AS REQ. 
	    <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Prop. Area         <TD CLASS=ListTask>CHK, CALL CLEAR 
	    <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Ignition           <TD CLASS=ListTask>START <FONT COLOR=##AAAAAA>Hand-On-Throttle
	    <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Throttle           <TD CLASS=ListTask>SET 1000 RPM 
	    <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Oil Press.        <TD CLASS=ListTask>CHK <FONT COLOR=##00AA00>(Green)
	    <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Mixture           <TD CLASS=ListTask>LEAN  1" @ 2000'
	    <TR><TD CLASS=ListNum>12<TD CLASS=ListItem>Lights            <TD CLASS=ListTask>AS REQ.
	    <TR><TD CLASS=ListNum>13<TD CLASS=ListItem><B>Fuel Select    <TD CLASS=ListTask>LEFT <FONT COLOR=##AAAAAA> / ON C152

<!--- <TR>	    
		 <TD CLASS=SecHeading2 COLSPAN=3>FLOODED START 
		 
	     <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Mast. Sw.               <TD CLASS=ListTask>ON 
		     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Throttle               <TD CLASS=ListTask>FULL OPEN 
		     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Mixture               <TD CLASS=ListTask>IDLE CUT OFF 
		     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Ignition               <TD CLASS=ListTask>ENGAGE 
		     <TR><TD CLASS=ListNum>5<TD CLASS=ListItem COLSPAN=2>*When engine fires advance mixture, retard throttle* 
         <TR><TD>&nbsp; --->

<!---
 <TR>	    
	 <TD CLASS=SecHeading2 COLSPAN=3>START: COLD WX  WITHOUT PREHEAT  
	      <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Prime             <TD CLASS=ListTask>6-10 STROKES 
	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Primer             <TD CLASS=ListTask>LEAVE OPEN 
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Prop Area             <TD CLASS=ListTask>CLEAR 
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Avionics Master             <TD CLASS=ListTask>OFF 
	     <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Master Switch             <TD CLASS=ListTask>ON 
	     <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Mixture             <TD CLASS=ListTask>FULL RICH 
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Beacon             <TD CLASS=ListTask>ON 
	     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Ignition             <TD CLASS=ListTask>START 
	     <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Throttle             <TD CLASS=ListTask>PUMP TWICE RAPIDLY
	     <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Throttle             <TD CLASS=ListTask>Return to 1/8 inch
	     <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Throttle             <TD CLASS=ListTask>OPEN 
	     <TR><TD CLASS=ListNum>12<TD CLASS=ListItem>Prime             <TD CLASS=ListTask>CONTINUE 
	     <TR><TD CLASS=ListNum>13<TD CLASS=ListItem COLSPAN=2>   <FONT COLOR=Grey>Until engine is running smoothly 
	     
	     <TR><TD CLASS=ListNum>14<TD CLASS=ListItem>Oil Pressure                <TD CLASS=ListTask>CHK 
	     <TR><TD CLASS=ListNum>15<TD CLASS=ListItem>Carburetor Heat                <TD CLASS=ListTask>ON 
	     <TR><TD CLASS=ListNum>16<TD CLASS=ListItem>Primer                <TD CLASS=ListTask>LOCK  --->


	 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>PRE-TAXI
	 		  <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Flaps                  <TD CLASS=ListTask>RETRACT

	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Circuit Breakrs      <TD CLASS=ListTask>ALL IN 
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Avionics Mast.       <TD CLASS=ListTask>ON 
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem STYLE="Border: none">Radio Freq.  
	                   <TD CLASS=ListTask STYLE="Border: none">ATIS, GND - WITH, RWY, ALT, WINDS, &deg; 
	     <TR><TD CLASS=ListNum><TD CLASS=ListItem STYLE="Border: none" COLSPAN=2>
	       <FONT COLOR=BLUE> ATIS CZVL: 128.35,<BR> CYXD 125.4<BR>     GND CZVL: 120.8,<BR>CYXD: 121.9

     		     
	     <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>X-ponder          <TD CLASS=ListTask>TEST -> STBY 1200
	     <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Altimeter     <TD CLASS=ListTask>SET
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Attitude       <TD CLASS=ListTask>SET HORIZON
	     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Compass             <TD CLASS=ListTask>CHK	
	     <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Heading       <TD CLASS=ListTask>SLAVE
	     <TR><TD CLASS=ListNum>10<TD CLASS=ListItem STYLE="Border: none">VOR / ADF  
	             <TD CLASS=ListTask STYLE="Border: none">CROSS-CHK, FLAGS OFF
	     <TR><TD CLASS=ListNum>11<TD CLASS=ListItem COLSPAN=2>
	         <FONT COLOR=BLUE>Nav YEG: 117.6, XD 266
	     
	     <TR><TD CLASS=ListNum>12<TD CLASS=ListItem>Instruments       <TD CLASS=ListTask>SCAN ALL
	     <TR><TD CLASS=ListNum>13<TD CLASS=ListItem><B>Fuel Valve     <TD CLASS=ListTask>RIGHT <FONT COLOR=##AAAAAA> / ON C152
	     <TR><TD CLASS=ListNum>14<TD CLASS=ListItem>Brake Press.      <TD CLASS=ListTask>CHK
       <TR><TD CLASS=ListNum>15<TD CLASS=ListItem>Controls          <TD CLASS=ListTask>PER WINDS
	     <TR><TD CLASS=ListNum>16<TD CLASS=ListItem>Park Brake        <TD CLASS=ListTask>RELEASE
	     <TR><TD CLASS=ListNum>17<TD CLASS=ListItem>Brakes            <TD CLASS=ListTask>ROLL CHK
	     <TR><TD>&nbsp;
</TABLE>             
</DIV>

</CFFUNCTION>



<!--- Brief ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnBrief" OUTPUT=TRUE>

<DIV ID="DivBrief">
   
<TABLE WIDTH=100% >

  <TR>  
    <TD VALIGN=TOP CLASS=SecHeading COLSPAN=4>PASSENGER CONCISE BRIEF
   <TR>
     <TD CLASS=ListItem COLSPAN=4 STYLE="font-size: 64">
       <FONT COLOR=GREY>
       No Smoking<BR>
        Hands &amp; Feet off controls<BR>
        Doors & Wins Shut<BR>
        Emerg. Exits, ELT, Egress<BR>
        First Aid, Survival Kit, Fire Ext.<BR>
        Radio Silence<BR>

   <TR>  
    <TD VALIGN=TOP CLASS=SecHeading COLSPAN=4>PASSENGER BRIEF   
         
   <TR>
    <TD CLASS=FormLabel STYLE="font-size: 32"> 
			<BR><BR><STRONG>1. SEATBELTS - use of seat belts</STRONG><BR>
			            Keep your seatbelt fastened for the duration of the flight 
				in the air and on the ground.
			         
			<BR><BR><STRONG>2. SMOKING - limitations</STRONG><BR>
			            There is No smoking at any period in the aircraft.    
			                                     
			<BR><BR><STRONG>3. EMERGENCY LANDING - action to take in the event of </STRONG><BR>
			            In the case of an emergency landing, stow any sharp objects 
				including glasses, pens.
			
			            Place soft items, such as a coat in front of your chest and face.
			            
			            Unlatch your door just prior to touchdown.
			            I'll prompt you to unlatch your door then "brace for impact".
			            
			            Brace by crossing your arms or grasp your seat-belt firmly.  
			           
			<BR><BR><STRONG>4. ELT - emergency locator transmitter,</STRONG><BR> 
			             The ELT is a beacon for search and rescue, 
			             In case I can't get to it in an emergency, 
				Set the ELT Switch to the ON position if we need help.
			
			<BR><BR><STRONG>5. EVACUATION - Passenger considerations for aircraft evacuation;</STRONG><BR>
			            On my command or if I'm incapacitated, turn on the ELT, 
				then exit the craft immediately to the rear and away.
			            The fuel is in the wings. 
			
			<BR><BR><STRONG>6. EXITS - the location and use of emergency exits</STRONG><BR>
			            Your door is your emergency exit.  
			            Pull back on the handle all the way and Push the door outward to open. 
			
			<BR><BR><STRONG>7. FIRE EXTINGUISHER</STRONG><BR>
			             In case of fire, the extinguisher is located here. 
			             Activate the extinguisher by... 
			                          
			<BR><BR><STRONG>8. OTHER EMERGENCY ITEMS - other items for use in an emergency.</STRONG><BR>
			            The first aid kit is located x.  And the survival kit is located x.
			 
			<BR><BR><STRONG>9. SPECIFIC ITEMS - items specific to the aeroplane type being used.</STRONG><BR>
			 Avoid the controls (yoke and rudder pedals at your feet), 
			especially in emergencies.
				
			<BR><BR><STRONG>10. CELL	Turn off your cell phone.</STRONG><BR><BR><BR>

</TABLE>
            
   <!---<TD Valign=top COLSPAn=3 WIDTH=50%>	--->
   
 <table WIDTH=100% BORDER=0>
   <TR>  
    <TD VALIGN=TOP CLASS=SecHeading COLSPAN=4>CREW PRE-TAKE OFF BRIEF
	 <TR>
	   <TD COLSPAN=4 CLASS=FormLabel STYLE="font-size: 36">			
				<BR><B><FONT SIZE=+1>ENGINE-FAILURE</FONT></B><BR>
				<B>DURING TAKE-OFF ROLL</B><BR>
				1) Throttle -- CLOSE<BR>
				2) Brakes -- APPLY HEAVY<BR>
				3) Yoke -- FULL AFT<BR><BR>
				
				<B>SUFFICIENT RWY REMAINING</B><BR>
				1) Pitch -- NOSE DOWN FOR BEST GLIDE<BR>
				2) Land -- ON REMAINING RWY<BR>
				3) Brakes -- HEAVY<BR>
				4) Yoke -- FULL AFT<BR><BR>
				
				<B>BELOW 1000' AGL</B><BR>
				1) Pitch -- NOSE DOWN<BR>
				2) Carb Heat -- HOT<BR>
				3) Heading -- STRAIGHT <BR>
				4) Flaps - AS REQUIRED<BR><BR>
				ENGINE & ELECTRICS OFF<BR>
				5) Mixture -- IDLE CUT-OFF<BR>
				6) Fuel Valve -- OFF<BR>
				7) Magnetos -- OFF<BR>
				8) Master -- OFF<BR><BR>
				
				<B>ABOVE 1000' AGL</B><BR>
				1) Pitch -- NOSE DOWN for BEST GLIDE<BR>
				2) Carb Heat -- HOT - CAUSE Attmpt Re-start<BR>
				3) Landing -- SELECT RWY IF FEASIBLE<BR>
				ENGINE & ELECTRICS OFF<BR>
				4) Mixture -- Idle Cut-off<BR>
				5) Fuel Valve -- OFF<BR>
				6) Magnetos -- OFF<BR>
				7) Flaps -- AS REQUIRED<BR>
				8) Master -- OFF<BR>
				
				<BR><B><FONT SIZE=+1>DEPARTURE</FONT></B><BR>
				1) Anticipate: TURN, ALTITUDE<BR>
				2) Departure: PROCEDURES<BR>
				<BR>
		</TABLE>
 </TABLE>
</DIV>
 
</CFFUNCTION>


<!--- ATIS ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnATIS" OUTPUT=TRUE>
 
 <DIV ID="DivATIS">

 <CFIF this.flAirportDepart GT "">
 <TABLE WIDTH=100%>
   <TR>
     <TD VALIGN=TOP>
     
     <CFSCRIPT>
         objMETAR = CreateObject("component","METAR");
         
         if ( this.flAirportDepart EQ "") {
             this.flAirportDepart = "CYXD";
         }
                     
         if ( objMETAR.Retrieve(cICAO=this.flAirportDepart, nHours=2, nTimeout=3) GT 0 ) {
         
             objMETAR.Display();
      
             if ( IsDefined("objMETAR.Temperature") ) {

		             this.flTemperature = objMETAR.Temperature;
		             this.flDewpoint = objMETAR.Dewpoint;
		             this.flWindDirection = objMETAR.WindDirection + this.Variation;
		             this.flWindSpeed = objMETAR.WindSpeed;
		             this.flPressureA = left(objMETAR.Altimeter,2);
		             this.flPressureB = Right(objMETAR.Altimeter,2);
		
		             if ( this.flWindDirection GTE 31 AND this.flWindDirection LTE 209 ) {
		                this.flActiveRunway = 12;
		             }
		             else {
		                this.flActiveRunway = 30;
		             }
		             this.HoldShort = this.flActiveRunway;
                          
             }
                                              
         }

        WriteOutput("<TD VALIGN=TOP>");   
         
         objTAF = CreateObject("component","TAF");
         if ( objTAF.Retrieve(cICAO=this.flAirportDepart, nHours=2, nTimeout=2) GT 0 ) {
             
             //objTAF.XMLDump();
             objTAF.Display();
                                             
         }  
         

 		     if ( this.flAirportDepart NEQ this.flAirportArrive AND this.flAirportArrive GT "" ) {
	 	        if ( objTAF.Retrieve(cICAO=this.flAirportArrive, nHours=2, nTimeout=2) GT 0 ) {
	 	        
	 	             WriteOutput("<TR><TD VALIGN=TOP>"); 
                 objTAF.Display(); 
             }
         }
     </CFSCRIPT>
     
				
</TABLE>
</CFIF>
 
 
<TABLE WIDTH="100%" bgcolor=DDEEFF BORDER=1 CELLPADDING=1 CELLSPACING=0 >
 
 
    <CFIF IsDefined("objMETAR.flMETARRaw") >
    	 <TR>
			   <TD CLASS=ListNum>
			   <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "> <B>METAR:</B>  
			   <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">#objMETAR.flMETARRaw#
        
    </CFIF>

	     <TR>
			     <TD CLASS=ListNum>
			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "> <B>ATIS WITH:</B>  
			     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
				       <SELECT NAME="flATISWith">
				            <OPTION VALUE="A" <CFIF this.flATISWith EQ "A" > SELECTED </CFIF> >A - Alpha</OPTION>
			              <OPTION VALUE="B" <CFIF this.flATISWith EQ "B" > SELECTED </CFIF> >B - Bravo</OPTION>
			              <OPTION VALUE="C" <CFIF this.flATISWith EQ "C" > SELECTED </CFIF> >C - Charlie</OPTION>
			              <OPTION VALUE="D" <CFIF this.flATISWith EQ "D" > SELECTED </CFIF> >D - Deta</OPTION>				 
			              <OPTION VALUE="E" <CFIF this.flATISWith EQ "E" > SELECTED </CFIF> >E - Echo</OPTION>
			              <OPTION VALUE="F" <CFIF this.flATISWith EQ "F" > SELECTED </CFIF> >F - FoxTrot</OPTION>
			              <OPTION VALUE="G" <CFIF this.flATISWith EQ "G" > SELECTED </CFIF> >G - Golf</OPTION>
			              <OPTION VALUE="H" <CFIF this.flATISWith EQ "H" > SELECTED </CFIF> >H - Hotel</OPTION>
			              <OPTION VALUE="I" <CFIF this.flATISWith EQ "I" > SELECTED </CFIF> >I - India</OPTION>
			              <OPTION VALUE="J" <CFIF this.flATISWith EQ "J" > SELECTED </CFIF> >J - Juliett</OPTION>
			              <OPTION VALUE="K" <CFIF this.flATISWith EQ "K" > SELECTED </CFIF> >K - Kilo</OPTION>
			              <OPTION VALUE="L" <CFIF this.flATISWith EQ "L" > SELECTED </CFIF> >L - Lima</OPTION>				 
			              <OPTION VALUE="M" <CFIF this.flATISWith EQ "M" > SELECTED </CFIF> >M - Mike</OPTION>
			              <OPTION VALUE="N" <CFIF this.flATISWith EQ "N" > SELECTED </CFIF> >N - November</OPTION>
			              <OPTION VALUE="O" <CFIF this.flATISWith EQ "O" > SELECTED </CFIF> >O - Oscar</OPTION>
			              <OPTION VALUE="P" <CFIF this.flATISWith EQ "P" > SELECTED </CFIF> >P - Papa</OPTION>       
			              <OPTION VALUE="Q" <CFIF this.flATISWith EQ "Q" > SELECTED </CFIF> >Q - Quebec</OPTION>
			              <OPTION VALUE="R" <CFIF this.flATISWith EQ "R" > SELECTED </CFIF> >R - Romeo</OPTION>
			              <OPTION VALUE="S" <CFIF this.flATISWith EQ "S" > SELECTED </CFIF> >S - Sierra</OPTION>
			              <OPTION VALUE="T" <CFIF this.flATISWith EQ "T" > SELECTED </CFIF> >T - Tango</OPTION>				 
			              <OPTION VALUE="U" <CFIF this.flATISWith EQ "U" > SELECTED </CFIF> >U - Uniform</OPTION>
			              <OPTION VALUE="V" <CFIF this.flATISWith EQ "V" > SELECTED </CFIF> >V - Victor</OPTION>
			              <OPTION VALUE="W" <CFIF this.flATISWith EQ "W" > SELECTED </CFIF> >W - Whiskey</OPTION>
			              <OPTION VALUE="X" <CFIF this.flATISWith EQ "X" > SELECTED </CFIF> >X - XRay</OPTION>
			              <OPTION VALUE="Y" <CFIF this.flATISWith EQ "Y" > SELECTED </CFIF> >Y - Yankee</OPTION>
			              <OPTION VALUE="Z" <CFIF this.flATISWith EQ "Z" > SELECTED </CFIF> >Z - Zulu</OPTION>
				       </SELECT>
      <TR>
        <TD>&nbsp;

			   <TR>
			     <TD CLASS=ListNum>
			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 ">SURFACE <B>WINDS</B>
			     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
			   	   	<SELECT NAME="flWindDirection"  OnChange="fnXWind()" >
	     				   <CFLOOP INDEX=n FROM=0 TO=360 STEP=10>
			   			   		<OPTION VALUE="#n#" <CFIF this.flWindDirection EQ n > SELECTED </CFIF> >#Right("000" & n,3)#</OPTION>
			   			   </CFLOOP>
			        </SELECT>&deg; Magnetic @
			       	<INPUT STYLE="font-size: 64"  TYPE=TEXT NAME="flWindSpeed" VALUE="#this.flWindSpeed#" SIZE=3 MAXLENGTH=3  OnChange="fnXWind()"> Knots
	        
		  <TR>
		     <TD CLASS=ListNum>
			   <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "><B>ACTIVE</B> Runway:
			   <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
			   	   	<SELECT NAME="flActiveRunway" OnChange="fnXWind()">
	     				   <CFLOOP INDEX=n FROM=0 TO=36>
			   			   		<OPTION VALUE="#n#"  <CFIF this.flActiveRunway EQ n > SELECTED </CFIF> >#Right("00" & n,2)#</OPTION>
			   			   </CFLOOP>
			        </SELECT>
                    
		 <TR>
		     <TD CLASS=ListNum>
		     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 ">

             <INPUT CLASS=btn TYPE="BUTTON" VALUE="X-Wind:" STYLE="font-size: 36" OnClick="fnXWind()">
        
 
		     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 " COLSPAN=3>
            
             <INPUT CLASS=text48 TYPE=TEXT NAME="flXWind" VALUE="" SIZE=2 MAXLENGTH=2 DISABLED > Knots &nbsp;
               From: <INPUT size=5 name=d value=ahead DISABLED >	
 
 	     <TR>
			     <TD CLASS=ListNum>
			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "> <B>HOLD SHORT:</B>  
			     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
	       	   	<SELECT NAME="flHoldShort">
	     				   <CFLOOP INDEX=n FROM=0 TO=36>
			   			   		<OPTION VALUE="#n#" <CFIF this.flHoldShort EQ n > SELECTED </CFIF> >#Right("00" & n,2)#</OPTION>
			   			   </CFLOOP>
			        </SELECT>

      <TR>
        <TD COLSPAN=3>&nbsp;<HR> 

      <TR>
        <TD>&nbsp;
        
			   <TR>
			     <TD CLASS=ListNum>
 			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "> TEMP / DEWpoint 
			     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
			       
	        <SELECT NAME="flTemperature" OnChange="fnHumidity()">
			           <CFLOOP INDEX=n FROM=-40 TO=40 >
			   			   		<OPTION VALUE="#n#" <CFIF this.flTemperature EQ n > SELECTED </CFIF> >#n#</OPTION>
			   			   </CFLOOP>
			   			</SELECT>&deg; C: &nbsp;	/	&nbsp;
	        <SELECT NAME="flDewPoint" OnChange="fnHumidity()">
			           <CFLOOP INDEX=n FROM=-40 TO=40 >
			   			   		<OPTION VALUE="#n#" <CFIF this.flDewPoint EQ n > SELECTED </CFIF> >#n#</OPTION>
			   			   </CFLOOP>
			   			</SELECT>&deg; C:
		 <TR>
			     <TD CLASS=ListNum>
 			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 ">

            <INPUT CLASS=btn TYPE="BUTTON" VALUE="Humidity:" STYLE="font-size: 36" OnClick="fnHumidity()">
            <TD COLSPAN=3>
            <INPUT CLASS=text48 TYPE=TEXT NAME="flHumidity" VALUE="" STYLE="text-align: right; background-color: ##EEEEEE" SIZE=3 MAXLENGTH=3  READONLY DISABLED>
          
			 
       <TR>
        <TD>&nbsp;
			   <TR>
			     <TD CLASS=ListNum>
			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 ">Altimeter: 
			     <!--- #this.flPressureA#.#this.flPressureB# --->
			     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
			        
			   				<SELECT NAME="flPressureA">
				           <OPTION VALUE="29" <CFIF this.flPressureA EQ 29 > SELECTED </CFIF> >29</OPTION>
				           <OPTION VALUE="30" <CFIF this.flPressureA EQ 30 > SELECTED </CFIF> >30</OPTION>
				           <OPTION VALUE="31" <CFIF this.flPressureA EQ 31 > SELECTED </CFIF> >31</OPTION>
				        </SELECT>
			   				<SELECT NAME="flPressureB">
			   				   <CFLOOP INDEX=nPressure FROM=1 TO=99>
			   				   		<OPTION VALUE="#Right("00" & nPressure,2)#" <CFIF val(this.flPressureB) EQ val(nPressure) > SELECTED </CFIF> >#Right("00" & nPressure,2)#</OPTION>
			   				   </CFLOOP>
				        </SELECT>
				        <FONT COLOR=GREY><I> Verify Against Field Elevation </I></FONT>
				       
       <TR>
        <TD>&nbsp;    			 
		    <TR>
		       <TD CLASS=ListNum>
		       <TD CLASS=ListItem STYLE="Padding-bottom: 10 ">TAXI:
		       <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">       
			       	<INPUT CLASS=text48 TYPE=TEXT NAME="flTaxiProgression" VALUE="" SIZE=20 MAXLENGTH=20>

       <TR>
        <TD COLSPAN=3>&nbsp;<HR> 
	      <TR>
			     <TD CLASS=ListNum>
			     <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "> <B>SQUAWK:</B> 
			     <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
	     		   	  <SELECT NAME="flSquawk1">
	     			   	   <CFLOOP INDEX=n FROM=0 TO=7><OPTION VALUE="#n#" <CFIF this.flSquawk1 EQ n > SELECTED </CFIF> >#n#</OPTION></CFLOOP>
			   		   </SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
	     		   		<SELECT NAME="flSquawk2">
	     			   	   <CFLOOP INDEX=n FROM=0 TO=7><OPTION VALUE="#n#" <CFIF this.flSquawk2 EQ n > SELECTED </CFIF> >#n#</OPTION></CFLOOP>
			   		   </SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
	     		   		<SELECT NAME="flSquawk3">
	     			   	   <CFLOOP INDEX=n FROM=0 TO=7>
			   				   		<OPTION VALUE="#n#" <CFIF this.flSquawk3 EQ n > SELECTED </CFIF> >#n#</OPTION></CFLOOP>
			   				</SELECT>&nbsp;&nbsp;&nbsp;&nbsp;
	     			   	<SELECT NAME="flSquawk4">
	     			   	   <CFLOOP INDEX=n FROM=0 TO=7><OPTION VALUE="#n#" <CFIF this.flSquawk4 EQ n > SELECTED </CFIF> >#n#</OPTION></CFLOOP>
			   		   </SELECT>
			     <TR STYLE="Display: none">
		     <TD CLASS=ListNum>
		      <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "><FONT COLOR=GREY><B>Forward Ground Speed</B>
			    <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
	 						<INPUT CLASS=text48 size="2" name="cwresultloss" readonly DISABLED><FONT COLOR=GREY> Knots
			       	<INPUT CLASS=text48 size=5 name=g value=loss DISABLED>  
		 <!--- <TR>
		     <TD CLASS=ListNum>
			   <TD CLASS=ListItem STYLE="Border: none" STYLE="Padding-bottom: 7 "><B>Headwind</B>:
			   <TD CLASS=ListTask STYLE="Border: none" STYLE="Padding-bottom: 7 ">
			       	<INPUT TYPE=TEXT NAME="flHeadWind" VALUE="" SIZE=4 MAXLENGTH=4 DISABLED> --->
			       	
</TABLE>       
</DIV>


</CFFUNCTION>



<!--- Depart ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnDepart" OUTPUT=TRUE>
 
<DIV ID="DivDepart">
<TABLE WIDTH=100% bgcolor=CCDDEE BORDER=0 CELLPADDING=1 CELLSPACING=0 >
	<TR>
      <TD COLSPAN=4 CLASS=ListItemTime STYLE="Padding-right: 50;" ALIGN=RIGHT>                     
        <INPUT TYPE="TEXT" SIZE=2 NAME="flDepartureHH" VALUE="#this.DepartureHH#" STYLE="Text-ALign: right; font-size: 64">:
        <INPUT TYPE="TEXT" SIZE=2 NAME="flDepartureMM" VALUE="#this.DepartureMM#" STYLE="font-size: 64">
        <INPUT CLASS=btn TYPE="BUTTON" STYLE="font-size: 64" NAME="btnDepart" VALUE="DEPAR&uarr; HH:MM" OnClick="fnDepart();">

	  <TR><TD CLASS=ListNum>7
	        <TD CLASS=ListItemPlan>Flight Plan      
	        <TD CLASS=ListTaskPlan>OPEN
             <INPUT CLASS=btn TYPE="BUTTON" STYLE="font-size: 72" NAME="btnTakeOff" VALUE="T.O. &uarr;" OnClick="fnTakeOffFocus();">
             
 <TR>	   
	 <TD CLASS=SecHeading COLSPAN=3>APRON, TAXI CLEAR
        <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Fuel Select <TD CLASS=ListTask>RIGHT <FONT COLOR=##888888> / ON C152
		    <TR><TD CLASS=ListNum>2
		      <TD CLASS=ListItem STYLE="Border: none"><B>Taxi
		      <TD CLASS=ListTask STYLE="Border: none">CLEARANCE <FONT COLOR=BLUE>GND CZVL: 120.8, CYXD: 121.9
            <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Controls             <TD CLASS=ListTask>PER WINDS
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem STYLE="Border: none">Rolling Instrument Check  
	     <TD CLASS=ListTask STYLE="Border: none">TURN COORD, HI, COMPASS
	<TR><TD CLASS=ListNum><TD CLASS=ListItem COLSPAN=2><FONT COLOR=##AAAAAA>NEEDLE left/right&nbsp; BALL left/right &nbsp;  COMPASS free   
			 <TR><TD>&nbsp;
     

		 					 	 
 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>RUNUP
	     <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Nose Wheel                          <TD CLASS=ListTask>STRAIGHT
	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Brakes                              <TD CLASS=ListTask>ON or Set PARK
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem><B>Prop Wash                           <TD CLASS=ListTask>CHK CLEAR
		 <TR><TD CLASS=ListNum>4<TD CLASS=ListItem><B>Fuel Select                 <TD CLASS=ListTask>BOTH 
	     <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Windows, Seats, Belts               <TD CLASS=ListTask>SECURE 
	     <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Mixture                              <TD CLASS=ListTask>FULL RICH 
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Throttle                             <TD CLASS=ListTask>1700 RPM 

		 <TR><TD CLASS=ListNum>8<TD CLASS=ListItem STYLE="Border: none">Mags  <TD CLASS=ListTask STYLE="Border: none">CHK BOTH
     		 <FONT COLOR=GREY>Max &darr; 125 RPM  &##9650; 50 RPM


	     <TR><TD CLASS=ListNum>9<TD CLASS=ListItem><B>Mixture                <TD CLASS=ListTask>TST LEAN - FULL 
	     <TR><TD CLASS=ListNum>10<TD CLASS=ListItem><B>Carb. Ice             <TD CLASS=ListTask><FONT COLOR=red>HOT <FONT COLOR=blue>COLD <FONT COLOR=red>HOT  
	     <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Vacuum                   <TD CLASS=ListTask>CHK 5" Hg <FONT COLOR=GREEN>Green
	     <TR><TD CLASS=ListNum>12<TD CLASS=ListItem>Oil Temp, Pressure      <TD CLASS=ListTask>CHK <FONT COLOR=GREEN>Green
	     <TR><TD CLASS=ListNum>13<TD CLASS=ListItem>Ammeter                  <TD CLASS=ListTask>CHK +1 Needle Width
	     <TR><TD CLASS=ListNum>16<TD CLASS=ListItem>Throttle                 <TD CLASS=ListTask>IDLE
	     <TR><TD CLASS=ListNum>17<TD CLASS=ListItem>Oil Press.               <TD CLASS=ListTask>&uarr; <FONT COLOR=RED>RED
	     <TR><TD CLASS=ListNum>18<TD CLASS=ListItem>Carb. Heat               <TD CLASS=ListTask><FONT COLOR=blue>COLD 
	     <TR><TD CLASS=ListNum>19<TD CLASS=ListItem>Throttle                 <TD CLASS=ListTask>1000 RPM
	     <TR><TD CLASS=ListNum>20<TD CLASS=ListItem>Mixture                  <TD CLASS=ListTask>LEAN  1" @ 2000'
	     <TR><TD>&nbsp;

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>PRE-TAKEOFF 
	    <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Sun Visors            <TD CLASS=ListTask>UP 
      <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Trim                  <TD CLASS=ListTask>SET 4 T.O. 
	    <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Primer                <TD CLASS=ListTask>IN &amp; LOCKED
	    <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Mags                  <TD CLASS=ListTask>BOTH 
	    <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Carb. Heat            <TD CLASS=ListTask>COLD  
		  <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Throttl Frict.        <TD CLASS=ListTask>ADJUST   
	    <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Flaps                 <TD CLASS=ListTask>SET (as req.)
	    <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Fuel Select           <TD CLASS=ListTask>BOTH <FONT COLOR=##AAAAAA> / ON C152
	    <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Doors &amp; Wins      <TD CLASS=ListTask>SECURE
	    <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Seats, Belts         <TD CLASS=ListTask>SECURE 
		  <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Flight Controls      <TD CLASS=ListTask>FREE &amp; CORR.   
		  <TR><TD CLASS=ListNum>12<TD CLASS=ListItem>Emerg. Procs.        <TD CLASS=ListTask>REVIEW
  

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>HOLD SHORT 
	 		 <TR><TD CLASS=ListNum>1<TD CLASS=ListItem><B>Mixture           <TD CLASS=ListTask>Full RICH &darr;3000'
	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem><B>Xponder           <TD CLASS=ListTask>ALT MODE <FONT COLOR=AAAAAA>SQUAWK [1200]
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Lights, Pitot        <TD CLASS=ListTask>AS REQUIRED
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Carb. Heat           <TD CLASS=ListTask><FONT COLOR=BLUE >COLD
	     <TR><TD>&nbsp;
       <TR><TD>&nbsp;
			 <TR><TD CLASS=ListNum>6<TD CLASS=ListItem STYLE="Border: none"><B>T.O. Clearance 
			     <TD CLASS=ListTask STYLE="Border: none">Radio TWR <FONT COLOR=BLUE>CZVL: 120.0, CYXD: 119.1
			     
	     <TR><TD CLASS=ListNum>5<TD CLASS=ListItemTime><B>Depart Time     <TD CLASS=ListTaskTime>RECORD
     
</TABLE>
</DIV> 

</CFFUNCTION>


<!--- Takeoff ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnTakeoff" OUTPUT=TRUE>
 
<DIV ID="DivTakeOff">
<TABLE bgcolor="##EEDDDD" BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=100%>
 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>NORMAL TAKEOFF 
	     <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>HI, Compass        <TD CLASS=ListTask>CHK
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>GO 4 Flight        <TD CLASS=ListTask>"GO, No-Go"
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Throttle           <TD CLASS=ListTask>"Power Full"
		   <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Guauges (MP/RPM)   <TD CLASS=ListTask>"Green" (Full Static)
		   <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Airspeed           <TD CLASS=ListTask>"ALIVE"
	     
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Rotate                       <TD CLASS=ListTask>"V1-Rotate" 55 KIAS
	     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem STYLE="Border: none">Climb   <TD CLASS=ListTask STYLE="Border: none">BEST RATE 
	     <TR><TD CLASS=ListNum><TD CLASS=ListItem STYLE="Border: none" Colspan=2><FONT COLOR=GREY>Vy 73 KIAS Sea Level
	     <TR><TD CLASS=ListNum><TD CLASS=ListItem Colspan=2><FONT COLOR=GREY>Vy 68 KIAS @ 10,000 ft

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>X-Wind TAKEOFF 
	     <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>HI, Compass        <TD CLASS=ListTask>CHK
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>GO 4 Flight        <TD CLASS=ListTask>"GO, No-Go"
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>X-Wind Inputs      <TD CLASS=ListTask>Yoke Into Wind
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Throttle           <TD CLASS=ListTask>"Power Full"
		   <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Gauges (MP/RPM)   <TD CLASS=ListTask>"Green" (Full Static)
		   <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Airspeed           <TD CLASS=ListTask>"ALIVE"
	 	   <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>X-Wind Inputs      <TD CLASS=ListTask>Ease Out
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Rotate             <TD CLASS=ListTask>"V1-Rotate" &darr;55 KIAS
	     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem STYLE="Border: none">Climb   <TD CLASS=ListTask STYLE="Border: none">BEST RATE 
	     <TR><TD CLASS=ListNum><TD CLASS=ListItem STYLE="Border: none" Colspan=2><FONT COLOR=GREY>Vy 73 KIAS Sea Level
	     <TR><TD CLASS=ListNum><TD CLASS=ListItem Colspan=2><FONT COLOR=GREY>Vy 68 KIAS @ 10,000 ft


 <TR>	    
	 <TD CLASS=SecHeading2 COLSPAN=3>Soft-Field TAKEOFF
	     <TR><TD CLASS=ListNum>1<TD CLASS=ListItem><B>Flaps                      <TD CLASS=ListTask>10&deg;
	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem><B>Yoke                       <TD CLASS=ListTask>Full Back
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem><B>Inertia                    <TD CLASS=ListTask>Keep Rolling
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Throttle                      <TD CLASS=ListTask><B>"Smooth Power 2 Full"
		   <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Gauges (MP/RPM)               <TD CLASS=ListTask>"Green" (Full Static)
		   <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Airspeed                      <TD CLASS=ListTask>"ALIVE"
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Rotate                        <TD CLASS=ListTask>"V1-Rotate" &darr;55 KIAS
	     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem><B>Accel. in ground eff.      <TD>Pitch Level
	     <TR><TD CLASS=ListNum>9<TD CLASS=ListItem><B>Flaps "Safe Speed, + Rate"    <TD CLASS=ListTask>RETRACT
	     <TR><TD CLASS=ListNum>10<TD CLASS=ListItem STYLE="Border: none">Climb    <TD CLASS=ListTask STYLE="Border: none">BEST RATE 
	     <TR><TD CLASS=ListNum><TD CLASS=ListItem STYLE="Border: none" Colspan=2><FONT COLOR=GREY>Vy 73 KIAS Sea Level
	     
	     
 <TR>	    
	 <TD CLASS=SecHeading2 COLSPAN=3>Short-Field: SHORT-FIELD  
	     <TR><TD CLASS=ListNum>1a<TD CLASS=ListItem>Flaps Obstacle                <TD CLASS=ListTask>RETRACT (CLEAN)
	     <TR><TD CLASS=ListNum>1b<TD CLASS=ListItem>Flaps No Obstacle             <TD CLASS=ListTask>10&deg; 
	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem><B>Yoke                        <TD CLASS=ListTask>Full Back
	     <TR><TD CLASS=ListNum>3<TD CLASS=ListItem><B>Taxi to Position            <TD CLASS=ListTask>Use full runway
	     <TR><TD CLASS=ListNum>4<TD CLASS=ListItem><B>Brakes                         <TD CLASS=ListTask>APPLY FULL
	     <TR><TD CLASS=ListNum>5<TD CLASS=ListItem><B>Throttle                       <TD CLASS=ListTask>Full OPEN 
	     <TR><TD CLASS=ListNum>6<TD CLASS=ListItem><B>Engine Instruments             <TD CLASS=ListTask>"Gauges Green"
	     <TR><TD CLASS=ListNum>7<TD CLASS=ListItem><B>GO 4 Flight                    <TD CLASS=ListTask>"GO, No-Go"
	     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem><B>Brakes                         <TD CLASS=ListTask>RELEASE 
	     <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Rotate                        <TD CLASS=ListTask>&darr;55 KIAS 
	     <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Climb Out/50 ft. obst         <TD CLASS=ListTask>Vx 55 KIAS SL 
	     <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Climb Out/No obst             <TD CLASS=ListTask>Vy 73 KIAS SL
	     <TR><TD CLASS=ListNum>12<TD CLASS=ListItem><B>Flaps "Safe Speed, + Rate"    <TD CLASS=ListTask>RETRACT
	     <TR><TD CLASS=ListNum>13<TD CLASS=ListItem Colspan=2><FONT COLOR=Grey>Best Angle: 59 KIAS @ sea level<BR>61 KIAS @ 10,000 ft. 

      
         
   #fnCruise()# 
 </TABLE>
</DIV> 
</CFFUNCTION>


<!--- Circuit ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnCircuit" OUTPUT=TRUE>
	<DIV ID="DivCircuit">
	   <TABLE WIDTH=100%>
	     <TR>
	      <TD ALIGN=CENTER COLSPAN=4>
	       <IMG SRC="C172Circuit.png"  STYLE="WIDTH: Auto; Height: 1400" >
	   </TABLE>
	</DIV>   
</CFFUNCTION>



<!--- Speeds ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnSpeeds" OUTPUT=TRUE>

<DIV ID="DivSpeeds">
 		<TABLE WIDTH=100% BORDER=0 ALIGN=LEFT >
	
		  <TR><TD CLASS=SecHeading COLSPAN=4>Cessna-172M   <TD CLASS=SecHeading COLSPAN=3>Cessna-152 
		  <TR><TD CLASS=colHeading COLSPAN=2>V SPEEDS  
		      <TD CLASS=colHeading >KIAS   <TD CLASS=colHeading >MPH    <TD CLASS=colHeading >KIAS      <TD CLASS=SecHeading COLSPAN=1>
          
			<TR><TD CLASS=FormLabel>Stall (Flaps DN)<TD CLASS=ListItem>Vso           	<TD CLASS=ListSpeed>41       <TD CLASS=ListSpeed2>49			<TD CLASS=ListSpeed>35    <TD CLASS=ListItem>Vso            			                                                                                     
			<TR><TD CLASS=FormLabel>Stall (Flaps UP)<TD CLASS=ListItem>Vs            	<TD CLASS=ListSpeed>47       <TD CLASS=ListSpeed2>57			<TD CLASS=ListSpeed>40    <TD CLASS=ListItem>Vs             			                                                                                     
			<TR><TD CLASS=FormLabel>Rotate<TD CLASS=ListItem>Vr             					<TD CLASS=ListSpeed>55-65    <TD CLASS=ListSpeed2>60			<TD CLASS=ListSpeed>      <TD CLASS=ListItem>Vr             			                                                                                    
			<TR><TD CLASS=FormLabel>Best Angle<TD CLASS=ListItem>Vx (sea level) 			<TD CLASS=ListSpeed>59       <TD CLASS=ListSpeed2>75			<TD CLASS=ListSpeed>55    <TD CLASS=ListItem>(SL) Vx  				                                                                                      
			<TR><TD CLASS=FormLabel>Best Angle<TD CLASS=ListItem>Vx (10,000 ft.)			<TD CLASS=ListSpeed>61       <TD CLASS=ListSpeed2>  			<TD CLASS=ListSpeed>      <TD CLASS=ListItem>(10K) Vx 		                                                                                              
			<TR><TD CLASS=FormLabel>Best Rate<TD CLASS=ListItem>Vy (sea level) 				<TD CLASS=ListSpeed>73       <TD CLASS=ListSpeed2>90			<TD CLASS=ListSpeed>67    <TD CLASS=ListItem>(SL) Vy
			<TR><TD CLASS=FormLabel>Best Rate<TD CLASS=ListItem>Vy (2,000 ft.)				<TD CLASS=ListSpeed>         <TD CLASS=ListSpeed2>		  	<TD CLASS=ListSpeed>      <TD CLASS=ListItem>(2K) Vy 	    	       	    	                                                                                  
			<TR><TD CLASS=FormLabel>Best Rate<TD CLASS=ListItem>Vy (10,000 ft.)				<TD CLASS=ListSpeed>68       <TD CLASS=ListSpeed2>79			<TD CLASS=ListSpeed>      <TD CLASS=ListItem>(10K) Vy 				                                                                                      
			<TR><TD CLASS=FormLabel>Max Flaps Extnd<TD CLASS=ListItem>Vfe            	<TD CLASS=ListSpeed>85       <TD CLASS=ListSpeed2>100		  <TD CLASS=ListSpeed>85    <TD CLASS=ListItem>Vfe            			                                                                                    
			<TR><TD CLASS=FormLabel>Never Operate<TD CLASS=ListItem>Vno            		<TD CLASS=ListSpeed>128      <TD CLASS=ListSpeed2>145		  <TD CLASS=ListSpeed>      <TD CLASS=ListItem>Vno            			                                                                                    
			<TR><TD CLASS=FormLabel>Never Exceed<TD CLASS=ListItem>Vne          			<TD CLASS=ListSpeed>160      <TD CLASS=ListSpeed2>182		  <TD CLASS=ListSpeed>149   <TD CLASS=ListItem>Vne          				                                                                                    
			<TR><TD CLASS=FormLabel>Best Man.<TD CLASS=ListItem>Va (2300 lbs)					<TD CLASS=ListSpeed>97       <TD CLASS=ListSpeed2>112		  <TD CLASS=ListSpeed>104   <TD CLASS=ListItem NOWRAP>(1640 lbs) Va                                                                                  
			<TR><TD CLASS=FormLabel>Best Man.<TD CLASS=ListItem>Va (1950 lbs)					<TD CLASS=ListSpeed>89       <TD CLASS=ListSpeed2>		  	<TD CLASS=ListSpeed>      <TD CLASS=ListItem>( lbs)	Va 					                                                                                    
			<TR><TD CLASS=FormLabel>Best Man.<TD CLASS=ListItem>Va (1600 lbs)					<TD CLASS=ListSpeed>80       <TD CLASS=ListSpeed2>		  	<TD CLASS=ListSpeed>      <TD CLASS=ListItem>( lbs)	Va 				                                                                                      
			<TR><TD CLASS=FormLabel>Best Glide<TD CLASS=ListItem>(flaps UP)		        <TD CLASS=ListSpeed>65       <TD CLASS=ListSpeed2>		   	<TD CLASS=ListSpeed>60    <TD CLASS=ListItem>Best Glide		                                                                                        
			<TR><TD CLASS=FormLabel>Best Glide<TD CLASS=ListItem> (flaps DN)		      <TD CLASS=ListSpeed>60       <TD CLASS=ListSpeed2>	  		<TD CLASS=ListSpeed>      <TD CLASS=ListItem>Best Glide	                                                                                          
			<TR><TD CLASS=FormLabel>Max X-Wind<TD CLASS=ListItem>Demonstrated		    	<TD CLASS=ListSpeed>15       <TD CLASS=ListSpeed2>	  		<TD CLASS=ListSpeed>12    <TD CLASS=ListItem>X-Wind       	   		                                                                              
			<TR><TD CLASS=FormLabel>Approach<TD CLASS=ListItem> (Flaps UP)			      <TD CLASS=ListSpeed>60-70    <TD CLASS=ListSpeed2>	  		<TD CLASS=ListSpeed>      <TD CLASS=ListItem>Approach	      	                                                                              
			<TR><TD CLASS=FormLabel>Approach<TD CLASS=ListItem> (Flaps DN)		      	<TD CLASS=ListSpeed>55-65    <TD CLASS=ListSpeed2>	  		<TD CLASS=ListSpeed>      <TD CLASS=ListItem>Approach		                                                                                        

  	    	<TR><TD COLSPAN=6>* Never Operate is the maximum unless smooth air.          
  	    	<TR><TD COLSPAN=6>** Use Best Manouvering Speed (Va) in turbulent conditions.
 		</TABLE>       
     
		<TABLE WIDTH=100% BORDER=0>
		 <TR>	    
			 <TD CLASS=SecHeading COLSPAN=3>AIRCRAFT SPECIFICATIONS
			      <TR><TD CLASS=FormLabel>Type                    <TD CLASS=ListTask>Cessna 172M 
			      <TR><TD CLASS=FormLabel>Takeoff Weight          <TD CLASS=ListTask> 2300 lbs. 
			      <TR><TD CLASS=FormLabel>Usable Fuel             <TD CLASS=ListTask>38 gallons (172M)  48 gallons (Long Range) 
			      <TR><TD CLASS=FormLabel>Recommended oil         <TD CLASS=ListTask>15W-50/20W-50 (all temps.) 
			      <TR><TD CLASS=FormLabel>Oil Capacity: 		     	<TD CLASS=ListTask>8 quarts (sump) &ndash; 9 quarts (total) 
			      <TR><TD CLASS=FormLabel>Engine Type: 		      	<TD CLASS=ListTask>O-320-H2AD 
			      <TR><TD CLASS=FormLabel>Maximum Power: 		      <TD CLASS=ListTask>160 BHP 
  		      <TR><TD CLASS=FormLabel>Electrical System: 			<TD CLASS=ListTask>28V DC, 60-amp alt., 14V 24 amp-hr. battery 
			      <TR><TD CLASS=FormLabel>Proper tire inflation: 	<TD CLASS=ListTask>31 PSI (nose wheel), 29 PSI (main wheels) 
			      <TR><TD CLASS=FormLabel>Wingspan: 					    <TD CLASS=ListTask>36&rsquo; 1&rdquo; Length: 27&rsquo; 2&rdquo; 
			      <TR><TD CLASS=FormLabel>Height:				       	  <TD CLASS=ListTask>8&rsquo; 11&rdquo; Prop. diameter: 75&rdquo; 
			      <TR><TD CLASS=FormLabel>FSS: &ndash;            <TD CLASS=ListTask>1-888-WX-BRIEF<BR>1-888-992-7433
		</TABLE>

</DIV>
</CFFUNCTION>


<!--- Arrive ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnArrive" OUTPUT=TRUE>
   <DIV ID="DivArrive">
<TABLE bgcolor=##EEDDDD BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=100%>
	 <TR> 
	 	  <TD CLASS=ListItemTime COLSPAN=4 STYLE="Padding-right: 10" ALIGN=CENTER NOWRAP>
         <INPUT TYPE="TEXT" SIZE=2 NAME="flArrivalHH" VALUE="#this.ArrivalHH#" STYLE="Text-ALign: right; font-size: 64"> :
         <INPUT TYPE="TEXT" SIZE=2 NAME="flArrivalMM" VALUE="#this.ArrivalMM#" STYLE="font-size: 64">
         <INPUT CLASS=btn TYPE="BUTTON" NAME="btnArrive" STYLE="font-size: 64" VALUE="ARR&darr;VE HH:MM" OnClick="fnArrive();">
 		
 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>CLEARANCE DELIVERY
	 			 <TR><TD CLASS=ListNum>1<TD CLASS=ListItem STYLE="Border: none">ATIS <TD CLASS=ListTask STYLE="Border: none">Radio <FONT COLOR=BLUE>ATIS CZVL: 128.35, CYXD 125.4
	 			 <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Clearance Delivery <TD CLASS=ListTask>CLEAR
	 			 <TR><TD CLASS=ListNum>3<TD CLASS=ListItem STYLE="Border: none">Tower <TD CLASS=ListTask STYLE="Border: none">CLEAR <FONT COLOR=BLUE>TWR CZVL: 120.0, CYXD: 119.1

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>BEFORE LANDING
	 			<TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Primer<TD CLASS=ListTask>IN & LOCKED
					<TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Mast. Sw.<TD CLASS=ListTask>ON
					<TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Mags<TD CLASS=ListTask>ON BOTH
					<TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Carb Heat<TD CLASS=ListTask>CHK 4 ICE
					<TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Mixture<TD CLASS=ListTask>RICH 
					<TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Fuel Gauges<TD CLASS=ListTask>CHK
					<TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Oil Temp, Press<TD CLASS=ListTask> CHK GREEN
					<TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Land Light     <TD CLASS=ListTask>AS REQUIRED
					<TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Fuel Select <TD CLASS=ListTask> BOTH 172
					<TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Brakes <TD CLASS=ListTask>PRESSURE CHK
					<TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Belts, Doors, Seats<TD CLASS=ListTask> SECURE
					<TR><TD CLASS=ListNum>12<TD CLASS=ListItem STYLE="Border: none">Landing Clearance<TD CLASS=ListTask STYLE="Border: none"> CLEAR TWR <FONT COLOR=BLUE> CZVL: 120.0, CYXD: 119.1
					<TR><TD CLASS=ListNum><TD CLASS=ListItem COLSPAN=2>
				       <TR><TD>&nbsp;	 			

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>NORMAL LANDING
	 	  <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Touch Spot             <TD CLASS=ListTask>CALL 
	      <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Carb. Heat             <TD CLASS=ListTask><FONT COLOR=RED>HOT (out)
	      <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Power                  <TD CLASS=ListTask>RPM: 1500 <FONT COLOR=##AAAAAA>/ 1700 C152
	  	  <TR><TD CLASS=ListNum>4<TD CLASS=ListItem STYLE="Border: none">Airspeed                  <TD CLASS=ListTask STYLE="Border: none">70 KIAS <FONT COLOR=##AAAAAA>60 KIAS C152     
	      <TR><TD CLASS=ListNum>5<TD CLASS=ListItem Colspan=2><FONT COLOR=GREY>55-65 (Flaps DN)<BR>60-70 (Flaps UP) 
	      <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Flaps                                          <TD CLASS=ListTask>AS DESIRED 
	      <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Gear                                         <TD CLASS=ListTask>CHK
	      <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Touchdown                                          <TD CLASS=ListTask>MAINS first 
	      <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Nosewheel                                          <TD CLASS=ListTask>LOWER GENTLY 
	      <TR><TD CLASS=ListNum>11<TD CLASS=ListItem>Braking                                          <TD CLASS=ListTask>MINIMUM 
 <TR>	    
	 <TD CLASS=SecHeading2 COLSPAN=3 >SHORT FIELD LANDING
	      <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Carb. Heat            <TD CLASS=ListTask><FONT COLOR=RED>HOT (out)
	      <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Airspeed            <TD CLASS=ListTask>65 KIAS (Flaps UP) 
	      <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Flaps            <TD CLASS=ListTask>FULL DOWN 
	      <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Airspeed            <TD CLASS=ListTask>60 KIAS 
	      <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Power            <TD CLASS=ListTask>IDLE 
	      <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Touchdown            <TD CLASS=ListTask>MAINS first 
	      <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Brakes            <TD CLASS=ListTask>APPLY FIRM 


 <TR>
	 <TD CLASS=SecHeading COLSPAN=3>POST LANDING
	 	<TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Runway                <TD CLASS=ListTask>CLEAR 

    <TR><TD CLASS=ListNum>2<TD CLASS=ListItemTime STYLE="Border: none">Arrival Time   <TD CLASS=ListTaskTime STYLE="Border: none">RECORD

	 	<TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Flaps                 <TD CLASS=ListTask>RETRACT 
       <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Carb.       <TD CLASS=ListTask>COLD
       <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Xponder            <TD CLASS=ListTask>STBY 
       <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Lights           <TD CLASS=ListTask>OFF<BR>Strobes, Landing light
      


       <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Mixture          <TD CLASS=ListTask>LEAN for taxi
		     <TR><TD CLASS=ListNum>8<TD CLASS=ListItem STYLE="Border: none">Taxi Clearance  <TD CLASS=ListTask STYLE="Border: none"><B>GND Freq
		     <TR><TD CLASS=ListNum><TD CLASS=ListItem COLSPAN=2><FONT COLOR=BLUE>CZVL: 120.8, CYXD: 121.9  CEZ3: 123.2, OTH: 122.8
		     <TR><TD CLASS=ListNum>9<TD CLASS=ListItemPlan>Flight Plan         <TD CLASS=ListTaskPlan>CLOSE

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>SHUTDOWN    
       <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>ELT Monitor                <TD CLASS=ListTask>121.5 Mhz    
       <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Elec. & Radios       <TD CLASS=ListTask>OFF 
       <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Avionics Mast.          <TD CLASS=ListTask>OFF
       <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Lights                    <TD CLASS=ListTask>OFF 
       <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Throttle                 <TD CLASS=ListTask>IDLE 
	     <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Mags                   <TD CLASS=ListTask>CHK BOTH	   
       <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Throttle                   <TD CLASS=ListTask>1000 RPM      
       <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Mixture                   <TD CLASS=ListTask>IDLE cutoff 
       <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Mags.              <TD CLASS=ListTask>OFF, KEYS-OUT 
       <TR><TD CLASS=ListNum>10<TD CLASS=ListItem>Mast.                   <TD CLASS=ListTask>OFF 
       <TR><TD>&nbsp;


 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>COCKPIT CLEANUP  
   <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Keys                <TD CLASS=ListTask>STOWED	

   <TR><TD CLASS=ListNum>2<TD CLASS=ListItemPlan>Flight Plan      <TD CLASS=ListTaskPlan>CLOSED?	

  <TR><TD>&nbsp;
   <!--- <TR><TD CLASS=ListNum>3<TD CLASS=ListItemTime>Hobbs, Tach              <TD CLASS=ListTaskTime>RECORD  --->
   <TR><TD CLASS=ListNum>3
       <TD CLASS=ListItemTime COLSPAN=2 STYLE="Padding-bottom: 10 " ALIGN=RIGHT><B>HOBBS:
        <INPUT TYPE="TEXT" SIZE=6 NAME="flHobbsEnd" STYLE="font-size: 64"
         <CFIF this.flHobbsEnd GT 0>
             VALUE="#this.flHobbsEnd#" 
         </CFIF>
       STYLE="Text-ALign: right"> &nbsp;&nbsp;&nbsp;
       
       TACH:	
       <INPUT TYPE="TEXT" SIZE=6 NAME="flTachEnd"  STYLE="font-size: 64"
         <CFIF this.flTachEnd GT 0>
             VALUE="#this.flTachEnd#"
         </CFIF>
              
	 <!---  <TR><TD CLASS=ListNum>
	  <TD CLASS=ListItemTime COLSPAN=2 STYLE="Padding-bottom: 10 " ALIGN=RIGHT><B>
        
       STYLE="Text-ALign: right"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --->
  <TR><TD>&nbsp;

 <TR>	    
	 <TD CLASS=SecHeading COLSPAN=3>CLEANUP  
       <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Control Lock              <TD CLASS=ListTask>INSTALL 
	     <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Doors,Wins                <TD CLASS=ListTask>LOCKED &amp; CLEAN 																																																										
       <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Tie-Dwns,<BR>Chalks          <TD CLASS=ListTask>SECURE 																																																										
       <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Aircraft Logs        <TD CLASS=ListTask>COMPLETE																																																										
       <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Personal Logs        <TD CLASS=ListTask>COMPLETE																																																										
       <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Payments             <TD CLASS=ListTask> 		
	     <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Next Mission           <TD CLASS=ListTask>PLAN

</TABLE>
</DIV> 
 
</CFFUNCTION> 



<!--- Weight ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnWeight" OUTPUT=TRUE>

<DIV ID="DivWeight" >
<TABLE bgcolor=EEEEEE BORDER=0 CELLPADDING=1 CELLSPACING=0 WIDTH=100%>
 <TR>
	 <TD VALIGN=TOP CLASS=SecHeading COLSPAN=4>WEIGHT
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">a
 			     <TD CLASS=ListTask align=RIGHT><B>Basic Empty W. (BEW):  
 				 	 <TD CLASS=FormInput ALIGN=RIGHT>	     
  			      <INPUT CLASS=textWB NAME="WBBEW" VALUE="#this.WBBEW#" SIZE=6 MAXLENGTH=12 STYLE="text-align: right" > 
  			      <TD CLASS=FormInput><FONT COLOR=##FFFFFF>lbs			  

		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">b
		 	     <TD CLASS=ListTask  ALIGN=RIGHT><B>Pilot:
	 				  <TD CLASS=FormInput ALIGN=RIGHT>		 	 
		 	   			<INPUT CLASS=textWB  TYPE=TEXT NAME="WBPilot" VALUE="#this.WBPilot#" SIZE=3 MAXLENGTH=12 STYLE="text-align: right" > 
		 	   			<TD CLASS=FormInput><FONT COLOR=##FFFFFF>lbs
		 	   			 	                                                         
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">c
		 	     <TD CLASS=ListTask  ALIGN=RIGHT><B>Front Passenger  :
 				 	 <TD CLASS=FormInput ALIGN=RIGHT>
		 	 		 	  <INPUT CLASS=textWB  TYPE=TEXT NAME="WBFrontPassenger" VALUE="#this.WBFrontPassenger#" SIZE=3 MAXLENGTH=12 STYLE="text-align: right" > 
		 	 		 	  <TD CLASS=FormInput><FONT COLOR=##FFFFFF>lbs                                             	
		 	 		 	   
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">d
		 	     <TD CLASS=ListTask  ALIGN=RIGHT><B>Rear Passengers:<BR><FONT COLOR=##FFFFFF>_______ + _______     
	 				 	 <TD CLASS=FormInput ALIGN=RIGHT>	
			 	  	  <INPUT CLASS=textWB  TYPE=TEXT NAME="WBRearPassengers" VALUE="#this.WBRearPassengers#" SIZE=3 MAXLENGTH=12 STYLE="text-align: right" > 
			 	  	  <TD CLASS=FormInput><FONT COLOR=##FFFFFF>lbs 	 	         
		 	 
		 	 
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">e
		 	     <TD CLASS=ListTask ALIGN=RIGHT><B>Cargo:
		 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT>
		 	       <INPUT CLASS=textWB  TYPE=TEXT NAME="WBCargo" VALUE="#this.WBCargo#" SIZE=3 MAXLENGTH=12 STYLE="text-align: right" > 
		 	        <TD CLASS=FormInput> <FONT COLOR=##FFFFFF>lbs 	
		 	    
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">f
		 	     <TD CLASS=ListTask align=right><FONT COLOR=##FFFFFF> ( a:e ) <FONT COLOR=AAAAAA><B>ZERO FUEL W.
		 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT>
		 	       <INPUT CLASS=textWB  TYPE=TEXT NAME="WBZeroFuelWeight" VALUE="#this.WBZeroFuelWeight#" SIZE=6 MAXLENGTH=12 STYLE="text-align: right; border-top: 1pt solid black" >
		 	         <TD CLASS=FormInput> <FONT COLOR=##FFFFFF>lbs 	 

		 	       		 	                                       
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">h
		 	     <TD CLASS=ListTask STYLE="Background-color: DDDDFF" NOWRAP ALIGN=RIGHT>
		 	       <INPUT CLASS=textWB TYPE=TEXT NAME="WBFuelQuantity" SIZE=2 MAXLENGTH=12 STYLE="text-align: right;" VALUE="#this.WBFuelQuantity#">
		 	        
		 	          <FONT COLOR=##FFFFFF>Gallons x
		 	          <CFIF VAL(this.WBFuelWeightPerUnit) EQ 0 >
		 	             <CFSET  this.WBFuelWeightPerUnit = 6 >
		 	          </CFIF>
		 	               <INPUT  CLASS=textWB TYPE=TEXT NAME="WBFuelWeightPerUnit" VALUE="#this.WBFuelWeightPerUnit#" SIZE=2 MAXLENGTH=12 STYLE="text-align: right;" > lbs<BR>	
		 	               
		 	          = ( Ramp )</FONT> <B>Fuel:
		 	                       
		 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT VALIGN=TOP>	
		 		       <INPUT CLASS=textWB  TYPE=TEXT NAME="WBFuelWeight" VALUE="#this.WBFuelWeight#" SIZE=5 MAXLENGTH=12 STYLE="text-align: right;" VALUE="228"> 
		 	         <TD CLASS=FormInput> <FONT COLOR=##FFFFFF>lbs	 	 
		 	       		 	 
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">i
		 	     <TD CLASS=ListTask align=right><FONT COLOR=##FFFFFF> ( g + h ) <FONT COLOR=AAAAAA><B>A</B>ll <B>U</B>p <B>W</B>eight:
			 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT>	
		 		       <INPUT CLASS=textWB  TYPE=TEXT NAME="WBAllUpWeight" VALUE="#this.WBAllUpWeight#" SIZE=6 MAXLENGTH=12 STYLE="text-align: right;" VALUE=""> 
		 	         <TD CLASS=FormInput> <FONT COLOR=##FFFFFF>lbs	
		 	 
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">j
		 	     <TD CLASS=ListTask NOWRAP ALIGN=RIGHT>Pre-Takeoff Burn:<BR>
		 	      <FONT COLOR=##DDDDDD>( 1.1 gallons ) x [  6.0 lbs  ]                                                                               
		 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT>	
		 		       <INPUT CLASS=textWB  TYPE=TEXT NAME="WBPreTakeOffBurn" VALUE="#this.WBPreTakeOffBurn#" SIZE=3 MAXLENGTH=12 STYLE="text-align: right;" VALUE="6.6"> 
		 	         <TD CLASS=FormInput> <FONT COLOR=##FFFFFF>lbs	
		 	         
		 	         
		 	 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">k
		 	     <TD CLASS=ListTask align=right><FONT COLOR=##FFFFFF> ( i - j ) <FONT COLOR="551111"><B>T</B>ake<B>O</B>ff <B>WEIGHT</B>:
		 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT STYLE="Border: 3pt solid FFFFEE;">	
		 		       <INPUT CLASS=textWB STYLE="Border: None; Background-color: DDDDFF" TYPE=TEXT NAME="WBTakeOffWeight" VALUE="#this.WBTakeOffWeight#" SIZE=6 MAXLENGTH=12 STYLE="text-align: right;  border-top: 1pt solid black" >
		 	         <TD CLASS=FormInput><FONT COLOR=##FFFFFF>lbs	

       <TR><TD COLSPAN=3 ALIGN=RIGHT STYLE="Padding: 5">&nbsp; 
            <INPUT  CLASS=btn TYPE=Button NAME="btnWBCalc" VALUE="TO Weight Calculate" OnClick="fnWBCalc()">
            
         
  <SCRIPT LANGUAGE="Javascript">
    function fnWBCalc() {
       frm = document.forms[0];
 
      
       frm.WBZeroFuelWeight.value = 
          fnParseFloat(frm.WBBEW.value) + 
          fnParseFloat(frm.WBPilot.value) + 
          fnParseFloat(frm.WBFrontPassenger.value) + 
          fnParseFloat(frm.WBRearPassengers.value) + 
          fnParseFloat(frm.WBCargo.value);
          
       frm.WBFuelWeight.value = fnParseFloat(frm.WBFuelQuantity.value) * fnParseFloat(frm.WBFuelWeightPerUnit.value);
       frm.WBFuelWeight.value = roundNumber(frm.WBFuelWeight.value, 2);
       
       frm.WBAllUpWeight.value =   fnParseFloat(frm.WBZeroFuelWeight.value) +  fnParseFloat(frm.WBFuelWeight.value);
       
       frm.WBTakeOffWeight.value =   fnParseFloat(frm.WBAllUpWeight.value) -  fnParseFloat(frm.WBPreTakeOffBurn.value);
       frm.WBTakeOffWeight.value = roundNumber(frm.WBTakeOffWeight.value, 2);
    }
    
  </SCRIPT>		 	         

<TR> 
 <TD VALIGN=TOP CLASS=SecHeading COLSPAN=4>TBI 
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">
 			     <TD CLASS=ListTask align=RIGHT><B>Next Service:  
 			     <TD CLASS=FormInput  ALIGN=Right>&nbsp;
 			      <INPUT CLASS=textTBI TYPE=TEXT NAME="flTBINextService" VALUE= "#this.flTBINextService#" SIZE=9 MAXLENGTH=12 STYLE="text-align: right"> 
 			      <TD CLASS=FormInput><FONT COLOR=##FFFFFF>hours
 			       			 
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">
 			     <TD CLASS=ListTask align=RIGHT><B>Last J. Log Entry:    
 			     <TD CLASS=FormInput  ALIGN=Right>&nbsp;
  			    <INPUT CLASS=textTBI TYPE=TEXT NAME="flTBILastService" VALUE= "#this.flTBILastService#" SIZE=9 MAXLENGTH=12 STYLE="text-align: right"> 
  			    <TD CLASS=FormInput><FONT COLOR=##FFFFFF>hours
  			    
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">
 			     <TD CLASS=ListTask align=RIGHT><B>Recent Hours (non-logged):    
 			     <TD CLASS=FormInput  ALIGN=Right>&nbsp;
 			      <INPUT CLASS=textTBI TYPE=TEXT NAME="flTBIRecentHours" VALUE= "#this.flTBIRecentHours#" SIZE=9 MAXLENGTH=12 STYLE="text-align: right"> 
 			      <TD CLASS=FormInput><FONT COLOR=##FFFFFF>hours
 			 
       <TR><TD>                         
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5">
 			     <TD CLASS=ListTask align=right><FONT COLOR="DDAAAA"><b>TBI:</b>    
		 	 	 	 <TD CLASS=FormInput ALIGN=RIGHT STYLE="Border: 3pt solid FFFFEE;">  
 			  		 <INPUT CLASS=textTBI STYLE="Border: None; Background-color: DDDDFF" TYPE=TEXT NAME="flTBI" VALUE= "#this.flTBI#" SIZE=5 MAXLENGTH=12 STYLE="text-align: right"> 
 			  		 <TD CLASS=FormInput><FONT COLOR=##FFFFFF>hours         
 			  			                    
       <TR><TD COLSPAN=3 ALIGN=RIGHT STYLE="Padding: 5">&nbsp; 
             <INPUT CLASS=btn TYPE=Button NAME="btnTBICalc" VALUE="TBI Calculate" OnClick="fnTBICalc()">
 
  <SCRIPT LANGUAGE="Javascript">
    function fnTBICalc() {
       frm = document.forms[0];
       frm.flTBI.value = frm.flTBINextService.value - frm.flTBILastService.value - frm.flTBIRecentHours.value;
       
       frm.flTBI.value = roundNumber(frm.flTBI.value, 2);
    }
    
    function roundNumber(num, dec) {
	     var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
	     return result;
    }
  </SCRIPT>


</TABLE>

</DIV>




</CFFUNCTION>



<!--- Cruise ------------------------------------------------------------  --->
<CFFUNCTION NAME="fnCruise" OUTPUT=TRUE>
   
  <TR>	    
	  <TD CLASS=SecHeading COLSPAN=3>CRUISE 
	 
   <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Level Off        <TD CLASS=ListTask>Altimeter LEAD 
   <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Power            <TD CLASS=ListTask>2300-2450 RPM 
   <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Trim             <TD CLASS=ListTask>SET 
   <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Mixture          <TD CLASS=ListTask>LEAN 
   <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Lights           <TD CLASS=ListTask>AS REQ.
   <TR><TD CLASS=ListNum>6<TD CLASS=ListItem>Departure Angle  <TD CLASS=ListTask>CHK
   <TR><TD CLASS=ListNum>7<TD CLASS=ListItem>Depart Time      <TD CLASS=ListTask>RECORDED?
   <TR><TD CLASS=ListNum>8<TD CLASS=ListItem>Flight Plan      <TD CLASS=ListTaskPlan>OPENED?
   <TR><TD CLASS=ListNum>9<TD CLASS=ListItem>Enroute          <TD CLASS=ListTask><FONT COLOR=BLUE>126.7
      <BR>WPA: 122.75
	     
  <TR>
	    <TD COLSPAN=3 ALIGN=RIGHT>
       <INPUT CLASS=btn TYPE="BUTTON" NAME="btnPlanEmbedded" VALUE="Plan: #this.PlanId#"    OnClick="fnGoPlan();">

</CFFUNCTION>



<!---
<TR>
 <TD VALIGN=TOP CLASS=SecHeading COLSPAN=3>FLIGHT
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B><FONT COLOR=GREEN>HOBBS Start:    <TD CLASS=ListItem WIDTH=100>&nbsp;
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B>Tach Start:    <TD CLASS=ListItem >&nbsp;
                   <TR><TD>&nbsp;    
                   
                   
	 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B><FONT COLOR=BLUE>Depart Time:    <TD CLASS=ListItem >&nbsp;                       
		 	     <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B><FONT COLOR=BLUE>Arrive Time:    <TD CLASS=ListItem >&nbsp; 
                   <TR><TD>&nbsp;                       
                   
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B><FONT COLOR=GREEN>HOBBS Stop:    <TD CLASS=ListItem >&nbsp;
 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B>Tach Stop:    <TD CLASS=ListItem >&nbsp;   
                  <TR><TD>&nbsp;

 			 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B><FONT COLOR=GREEN>FLIGHT Hrs:    <TD CLASS=ListItem >&nbsp;
	 		 <TR><TD CLASS=ListNum STYLE="Padding-Bottom: 5"><TD CLASS=ListTask><B><FONT COLOR=BLUE>Air Hrs:    <TD CLASS=ListItem >&nbsp;    
	 		 <TR><TD> &nbsp;   
--->


		<!--- <TR>	    
			 <TD CLASS=SecHeading COLSPAN=3>OVERSHOOT
		       <TR><TD CLASS=ListNum>1<TD CLASS=ListItem>Throttle            <TD CLASS=ListTask>FULL OPEN 
		       <TR><TD CLASS=ListNum>2<TD CLASS=ListItem>Carb. Heat            <TD CLASS=ListTask>COLD 
		       <TR><TD CLASS=ListNum>3<TD CLASS=ListItem>Flaps            <TD CLASS=ListTask>RETRACT to 20&deg; 
		       <TR><TD CLASS=ListNum>4<TD CLASS=ListItem>Climb            <TD CLASS=ListTask>55 KIAS 
		       <TR><TD CLASS=ListNum>5<TD CLASS=ListItem>Flaps            <TD CLASS=ListTask>RETRACT  --->
		       

 

