// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(kpiwidget)\n");	echo("require(htmltools)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var sd = getValue("sc_data");
    var v = getValue("sc_var");
    var clean_v = v.split(/[\[\"\]]|\$/).filter(Boolean).pop(); // kpiwidget uses string col names
    var stat = getValue("sc_stat");
    var prefix = getValue("sc_prefix");

    // We build a Power BI style card using standard Bootstrap HTML tags.
    echo("card_obj <- htmltools::tags$div(\n");
    echo("  class = 'card text-center mb-3 shadow-sm',\n");
    echo("  htmltools::tags$div(\n");
    echo("    class = 'card-body',\n");
    echo("    htmltools::tags$h5(class = 'card-title text-muted', '" + prefix + "'),\n");
    echo("    htmltools::tags$h2(\n");
    echo("      class = 'card-text fw-bold',\n");
    // CHANGED TO kpiwidget HERE!
    echo("      kpiwidget::kpiwidget(" + sd + ", kpi = '" + stat + "', column = '" + clean_v + "')\n");
    echo("    )\n");
    echo("  )\n");
    echo(")\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("5. Summary Card (KPI) results")).print();
echo("rk.header('Summary Card Created')\n");
	//// save result object
	// read in saveobject variables
	var scSaveUi = getValue("sc_save_ui");
	var scSaveUiActive = getValue("sc_save_ui.active");
	var scSaveUiParent = getValue("sc_save_ui.parent");
	// assign object to chosen environment
	if(scSaveUiActive) {
		echo(".GlobalEnv$" + scSaveUi + " <- card_obj\n");
	}

}

