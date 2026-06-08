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
  

    var df = getValue("dl_data"); var key = getValue("dl_key");
    if(key) { echo("shared_data_obj <- crosstalk::SharedData$new(" + df + ", key = " + safeF(key) + ")\n"); }
    else { echo("shared_data_obj <- crosstalk::SharedData$new(" + df + ")\n"); }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("1. Data Model Linker results")).print();
echo("rk.header('Data Linker: SharedData Model Created')\nrk.print('Saved as: " + getValue("dl_save_ui") + "')\n");
	//// save result object
	// read in saveobject variables
	var dlSaveUi = getValue("dl_save_ui");
	var dlSaveUiActive = getValue("dl_save_ui.active");
	var dlSaveUiParent = getValue("dl_save_ui.parent");
	// assign object to chosen environment
	if(dlSaveUiActive) {
		echo(".GlobalEnv$" + dlSaveUi + " <- shared_data_obj\n");
	}

}

