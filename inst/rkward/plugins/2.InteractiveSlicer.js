// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(crosstalk)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    function safeF(v) {
      if (!v) return "";
      var clean_v = v.split(/[\[\"\]]|\$/).filter(Boolean).pop();
      return "~`" + clean_v + "`";
    }
  

    var sd = getValue("sl_data"); var v = getValue("sl_var"); var clean_v = v.split(/[\[\"\]]|\$/).filter(Boolean).pop(); var type = getValue("sl_type");
    if(type == "select") { echo("slicer_obj <- crosstalk::filter_select(id = '" + clean_v + "_flt', label = 'Filter " + clean_v + "', sharedData = " + sd + ", group = " + safeF(v) + ")\n"); }
    else { echo("slicer_obj <- crosstalk::filter_slider(id = '" + clean_v + "_sld', label = 'Range " + clean_v + "', sharedData = " + sd + ", column = " + safeF(v) + ")\n"); }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("2. Interactive Slicer results")).print();
echo("rk.header('Interactive Slicer Created')\n");
	//// save result object
	// read in saveobject variables
	var slSaveUi = getValue("sl_save_ui");
	var slSaveUiActive = getValue("sl_save_ui.active");
	var slSaveUiParent = getValue("sl_save_ui.parent");
	// assign object to chosen environment
	if(slSaveUiActive) {
		echo(".GlobalEnv$" + slSaveUi + " <- slicer_obj\n");
	}

}

