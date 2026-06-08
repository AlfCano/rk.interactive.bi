// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(htmltools)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var obj = getValue("ex_obj");
    var file = getValue("ex_file");
    echo("export_path <- '" + file + "'\n");

    // Usamos endsWith() para evitar por completo el problema de escapar caracteres con grepl
    echo("if(!endsWith(export_path, '.html')) export_path <- paste0(export_path, '.html')\n");

    echo("htmltools::save_html(" + obj + ", file = export_path)\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("7. Export to HTML results")).print();
echo("rk.header('Dashboard Exported Successfully')\nrk.print(paste0('<b>File saved to:</b> ', export_path))\n");

}

