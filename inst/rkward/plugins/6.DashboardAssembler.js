// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(crosstalk)\n");	echo("require(bslib)\n");	echo("require(htmltools)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var objs = getValue("as_objs").split("\n").filter(Boolean);
    var widths = getValue("as_widths");
    var width_arg = (widths !== "NA" && widths !== "") ? "widths = c(" + widths + ")" : "widths = NA";
    var theme = getValue("as_theme");

    if(theme === "default") {
      // Usamos suppressWarnings para silenciar el aviso inofensivo de las 12 columnas
      echo("dashboard_obj <- suppressWarnings(crosstalk::bscols(" + width_arg + ", \n  ");
      echo(objs.join(",\n  "));
      echo("\n))\n");
    } else {
      echo("dashboard_obj <- htmltools::browsable(bslib::page_fluid(\n");
      echo("  theme = bslib::bs_theme(bootswatch = '" + theme + "'),\n");
      echo("  suppressWarnings(crosstalk::bscols(" + width_arg + ", \n    ");
      echo(objs.join(",\n    "));
      echo("\n  ))\n");
      echo("))\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("6. Dashboard Assembler results")).print();

    echo("rk.header('Dashboard Assembled')\n");
    echo("rk.print('<br><b>Previewing Dashboard...</b>')\n");
    echo("print(dashboard_obj)\n");
  
	//// save result object
	// read in saveobject variables
	var asSaveUi = getValue("as_save_ui");
	var asSaveUiActive = getValue("as_save_ui.active");
	var asSaveUiParent = getValue("as_save_ui.parent");
	// assign object to chosen environment
	if(asSaveUiActive) {
		echo(".GlobalEnv$" + asSaveUi + " <- dashboard_obj\n");
	}

}

