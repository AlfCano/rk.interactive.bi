// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(plotly)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    function safeF(v) {
      if (!v) return "";
      var clean_v = v.split(/[\[\"\]]|\$/).filter(Boolean).pop();
      return "~`" + clean_v + "`";
    }
  

    var sd = getValue("pl_data"); var x = getValue("pl_x"); var y = getValue("pl_y"); var color = getValue("pl_color"); var type = getValue("pl_type");
    echo("plotly_obj <- plotly::plot_ly(data = " + sd + ", x = " + safeF(x)); if(y) echo(", y = " + safeF(y)); if(color) echo(", color = " + safeF(color));
    if(type == "bar") echo(", type = 'bar'"); if(type == "scatter") echo(", type = 'scatter', mode = 'markers'"); if(type == "line") echo(", type = 'scatter', mode = 'lines'"); echo(")\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("3. Interactive Plot results")).print();
echo("rk.header('Interactive Plot Created')\n");
	//// save result object
	// read in saveobject variables
	var plSaveUi = getValue("pl_save_ui");
	var plSaveUiActive = getValue("pl_save_ui.active");
	var plSaveUiParent = getValue("pl_save_ui.parent");
	// assign object to chosen environment
	if(plSaveUiActive) {
		echo(".GlobalEnv$" + plSaveUi + " <- plotly_obj\n");
	}

}

