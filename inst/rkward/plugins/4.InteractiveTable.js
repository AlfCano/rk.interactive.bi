// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(DT)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated
echo("table_obj <- DT::datatable(" + getValue("dt_data") + ", width = '100%')\n");
}

function printout(is_preview){
	// printout the results
	new Header(i18n("4. Interactive Table results")).print();
echo("rk.header('Interactive Table Created')\n");
	//// save result object
	// read in saveobject variables
	var dtSaveUi = getValue("dt_save_ui");
	var dtSaveUiActive = getValue("dt_save_ui.active");
	var dtSaveUiParent = getValue("dt_save_ui.parent");
	// assign object to chosen environment
	if(dtSaveUiActive) {
		echo(".GlobalEnv$" + dtSaveUi + " <- table_obj\n");
	}

}

