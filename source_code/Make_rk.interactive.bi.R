local({
  # =========================================================================================
  # 1. Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.08-1")

  plugin_name <- "rk.interactive.bi"

  if(basename(getwd()) == plugin_name) {
    stop("Please run this script from the parent directory to avoid nested folders.")
  }

  package_about <- rk.XML.about(
    name = plugin_name,
    author = person(
      given = "Alfonso",
      family = "Cano",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "A suite of tools to create Power BI-style interactive dashboards, cross-filtered visuals, and slicers without a Shiny server.",
      version = "0.0.1",
      url = "https://github.com/AlfCano/rk.interactive.bi",
      license = "GPL (>= 3)"
    )
  )

  # --- Shared Resources ---
  shared_var_selector <- rk.XML.varselector(id.name = "shared_workspace_selector", label = "Objects in workspace")
  h_menu <- list("Interactive BI")

  # JS Helper for Rule #8
  js_safe_formula <- '
    function safeF(v) {
      if (!v) return "";
      var clean_v = v.split(/[\\[\\"\\]]|\\$/).filter(Boolean).pop();
      return "~`" + clean_v + "`";
    }
  '

  # =========================================================================================
  # MODULE 1: The Data Linker (MAIN COMPONENT)
  # =========================================================================================
  dl_data <- rk.XML.varslot(id.name = "dl_data", label = "Base Data.frame", source = "shared_workspace_selector", classes = "data.frame", required = TRUE)
  dl_key <- rk.XML.varslot(id.name = "dl_key", label = "Key Variable (Optional, for linking)", source = "shared_workspace_selector")
  dl_save <- rk.XML.saveobj("Save Shared Data object as", initial = "shared_data_obj", chk = TRUE, id.name = "dl_save_ui")

  dl_dialog <- rk.XML.dialog(label = "1. Data Linker (Create Data Model)", child = rk.XML.tabbook(tabs = list("Inputs" = rk.XML.row(shared_var_selector, rk.XML.col(rk.XML.text("Step 1: Convert a dataset into a 'SharedData' object."), dl_data, dl_key)), "Output" = rk.XML.col(dl_save))))

  js_dl_calc <- paste(js_safe_formula, '
    var df = getValue("dl_data"); var key = getValue("dl_key");
    if(key) { echo("shared_data_obj <- crosstalk::SharedData$new(" + df + ", key = " + safeF(key) + ")\\n"); }
    else { echo("shared_data_obj <- crosstalk::SharedData$new(" + df + ")\\n"); }
  ', sep="\n")
  js_dl_print <- 'echo("rk.header(\'Data Linker: SharedData Model Created\')\\nrk.print(\'Saved as: " + getValue("dl_save_ui") + "\')\\n");'

  # =========================================================================================
  # MODULE 2: Interactive Slicer
  # =========================================================================================
  sl_data <- rk.XML.varslot(id.name = "sl_data", label = "SharedData Object", source = "shared_workspace_selector", required = TRUE)
  sl_var <- rk.XML.varslot(id.name = "sl_var", label = "Variable to Filter", source = "shared_workspace_selector", required = TRUE)
  sl_type <- rk.XML.dropdown("Slicer Type", id.name = "sl_type", options = list("Dropdown/Checkbox"=list(val="select", chk=TRUE), "Slider (Numeric/Dates)"=list(val="slider")))
  sl_save <- rk.XML.saveobj("Save Slicer object as", initial = "slicer_obj", chk = TRUE, id.name = "sl_save_ui")

  sl_dialog <- rk.XML.dialog(label = "2. Create Slicer", child = rk.XML.tabbook(tabs = list("Settings" = rk.XML.row(shared_var_selector, rk.XML.col(sl_data, sl_var, sl_type)), "Output" = rk.XML.col(sl_save))))

  js_sl_calc <- paste(js_safe_formula, '
    var sd = getValue("sl_data"); var v = getValue("sl_var"); var clean_v = v.split(/[\\[\\"\\]]|\\$/).filter(Boolean).pop(); var type = getValue("sl_type");
    if(type == "select") { echo("slicer_obj <- crosstalk::filter_select(id = \'" + clean_v + "_flt\', label = \'Filter " + clean_v + "\', sharedData = " + sd + ", group = " + safeF(v) + ")\\n"); }
    else { echo("slicer_obj <- crosstalk::filter_slider(id = \'" + clean_v + "_sld\', label = \'Range " + clean_v + "\', sharedData = " + sd + ", column = " + safeF(v) + ")\\n"); }
  ', sep="\n")
  js_sl_print <- 'echo("rk.header(\'Interactive Slicer Created\')\\n");'
  comp_sl <- rk.plugin.component("2. Interactive Slicer", xml = list(dialog = sl_dialog), js = list(require = "crosstalk", calculate = js_sl_calc, printout = js_sl_print), hierarchy = h_menu)

  # =========================================================================================
  # MODULE 3: Interactive Plot
  # =========================================================================================
  pl_data <- rk.XML.varslot(id.name = "pl_data", label = "SharedData Object", source = "shared_workspace_selector", required = TRUE)
  pl_x <- rk.XML.varslot(id.name = "pl_x", label = "X Axis", source = "shared_workspace_selector", required = TRUE)
  pl_y <- rk.XML.varslot(id.name = "pl_y", label = "Y Axis (Optional)", source = "shared_workspace_selector")
  pl_color <- rk.XML.varslot(id.name = "pl_color", label = "Color By (Optional)", source = "shared_workspace_selector")
  pl_type <- rk.XML.dropdown("Plot Type", id.name = "pl_type", options = list("Bar Chart"=list(val="bar"), "Scatter Plot"=list(val="scatter", chk=TRUE), "Line Chart"=list(val="line")))
  pl_save <- rk.XML.saveobj("Save Plot object as", initial = "plotly_obj", chk = TRUE, id.name = "pl_save_ui")

  pl_dialog <- rk.XML.dialog(label = "3. Interactive Plot", child = rk.XML.tabbook(tabs = list("Variables" = rk.XML.row(shared_var_selector, rk.XML.col(pl_data, pl_x, pl_y, pl_color)), "Settings" = rk.XML.col(pl_type), "Output" = rk.XML.col(pl_save))))

  js_pl_calc <- paste(js_safe_formula, '
    var sd = getValue("pl_data"); var x = getValue("pl_x"); var y = getValue("pl_y"); var color = getValue("pl_color"); var type = getValue("pl_type");
    echo("plotly_obj <- plotly::plot_ly(data = " + sd + ", x = " + safeF(x)); if(y) echo(", y = " + safeF(y)); if(color) echo(", color = " + safeF(color));
    if(type == "bar") echo(", type = \'bar\'"); if(type == "scatter") echo(", type = \'scatter\', mode = \'markers\'"); if(type == "line") echo(", type = \'scatter\', mode = \'lines\'"); echo(")\\n");
  ', sep="\n")
  js_pl_print <- 'echo("rk.header(\'Interactive Plot Created\')\\n");'
  comp_pl <- rk.plugin.component("3. Interactive Plot", xml = list(dialog = pl_dialog), js = list(require = "plotly", calculate = js_pl_calc, printout = js_pl_print), hierarchy = h_menu)

  # =========================================================================================
  # MODULE 4: Interactive Matrix (DT)
  # =========================================================================================
  dt_data <- rk.XML.varslot(id.name = "dt_data", label = "SharedData Object", source = "shared_workspace_selector", required = TRUE)
  dt_save <- rk.XML.saveobj("Save Table object as", initial = "table_obj", chk = TRUE, id.name = "dt_save_ui")
  dt_dialog <- rk.XML.dialog(label = "4. Interactive Table Matrix", child = rk.XML.row(shared_var_selector, rk.XML.col(dt_data, dt_save)))
  js_dt_calc <- 'echo("table_obj <- DT::datatable(" + getValue("dt_data") + ", width = \'100%\')\\n");'
  js_dt_print <- 'echo("rk.header(\'Interactive Table Created\')\\n");'
  comp_dt <- rk.plugin.component("4. Interactive Table", xml = list(dialog = dt_dialog), js = list(require = "DT", calculate = js_dt_calc, printout = js_dt_print), hierarchy = h_menu)

  # =========================================================================================
  # MODULE 5: NEW! Summary Card (KPI) - FIXED FOR kpiwidget
  # =========================================================================================
  sc_data <- rk.XML.varslot(id.name = "sc_data", label = "SharedData Object", source = "shared_workspace_selector", required = TRUE)
  sc_var <- rk.XML.varslot(id.name = "sc_var", label = "Variable to Aggregate", source = "shared_workspace_selector", required = TRUE)
  sc_stat <- rk.XML.dropdown("Statistic", id.name = "sc_stat", options = list("Sum"=list(val="sum", chk=TRUE), "Mean/Average"=list(val="mean"), "Count"=list(val="count")))
  sc_prefix <- rk.XML.input("Card Title / Label (e.g., 'Total Sales')", id.name = "sc_prefix", initial = "Total:")
  sc_save <- rk.XML.saveobj("Save Card object as", initial = "card_obj", chk = TRUE, id.name = "sc_save_ui")

  sc_dialog <- rk.XML.dialog(label = "5. Summary KPI Card", child = rk.XML.row(shared_var_selector, rk.XML.col(sc_data, sc_var, sc_stat, sc_prefix, sc_save)))

  js_sc_calc <- '
    var sd = getValue("sc_data");
    var v = getValue("sc_var");
    var clean_v = v.split(/[\\[\\"\\]]|\\$/).filter(Boolean).pop(); // kpiwidget uses string col names
    var stat = getValue("sc_stat");
    var prefix = getValue("sc_prefix");

    // We build a Power BI style card using standard Bootstrap HTML tags.
    echo("card_obj <- htmltools::tags$div(\\n");
    echo("  class = \'card text-center mb-3 shadow-sm\',\\n");
    echo("  htmltools::tags$div(\\n");
    echo("    class = \'card-body\',\\n");
    echo("    htmltools::tags$h5(class = \'card-title text-muted\', \'" + prefix + "\'),\\n");
    echo("    htmltools::tags$h2(\\n");
    echo("      class = \'card-text fw-bold\',\\n");
    // CHANGED TO kpiwidget HERE!
    echo("      kpiwidget::kpiwidget(" + sd + ", kpi = \'" + stat + "\', column = \'" + clean_v + "\')\\n");
    echo("    )\\n");
    echo("  )\\n");
    echo(")\\n");
  '
  js_sc_print <- 'echo("rk.header(\'Summary Card Created\')\\n");'

  # CHANGED REQUIREMENT TO kpiwidget
  comp_sc <- rk.plugin.component("5. Summary Card (KPI)", xml = list(dialog = sc_dialog), js = list(require = c("kpiwidget", "htmltools"), calculate = js_sc_calc, printout = js_sc_print), hierarchy = h_menu)


  # =========================================================================================
  # MODULE 6: Dashboard Assembler
  # =========================================================================================
  as_objs <- rk.XML.varslot(id.name = "as_objs", label = "Select visuals, slicers, and cards", source = "shared_workspace_selector", multi = TRUE, required = TRUE)
  as_widths <- rk.XML.input("Column Widths (comma separated, max 12. e.g: 3, 3, 6)", id.name = "as_widths", initial = "NA")
  as_theme <- rk.XML.dropdown("Dashboard Theme", id.name = "as_theme", options = list("Standard Light"=list(val="default", chk=TRUE), "Dark Mode (Darkly)"=list(val="darkly"), "Flat Corporate (Flatly)"=list(val="flatly"), "Blue Accent (Cerulean)"=list(val="cerulean")))
  as_save <- rk.XML.saveobj("Save Dashboard object as", initial = "dashboard_obj", chk = TRUE, id.name = "as_save_ui")

  as_dialog <- rk.XML.dialog(label = "6. Dashboard Assembler", child = rk.XML.tabbook(tabs = list("Widgets & Layout" = rk.XML.row(shared_var_selector, rk.XML.col(as_objs, as_widths)), "Style & Output" = rk.XML.col(as_theme, as_save))))

js_as_calc <- '
    var objs = getValue("as_objs").split("\\n").filter(Boolean);
    var widths = getValue("as_widths");
    var width_arg = (widths !== "NA" && widths !== "") ? "widths = c(" + widths + ")" : "widths = NA";
    var theme = getValue("as_theme");

    if(theme === "default") {
      // Usamos suppressWarnings para silenciar el aviso inofensivo de las 12 columnas
      echo("dashboard_obj <- suppressWarnings(crosstalk::bscols(" + width_arg + ", \\n  ");
      echo(objs.join(",\\n  "));
      echo("\\n))\\n");
    } else {
      echo("dashboard_obj <- htmltools::browsable(bslib::page_fluid(\\n");
      echo("  theme = bslib::bs_theme(bootswatch = \'" + theme + "\'),\\n");
      echo("  suppressWarnings(crosstalk::bscols(" + width_arg + ", \\n    ");
      echo(objs.join(",\\n    "));
      echo("\\n  ))\\n");
      echo("))\\n");
    }
  '

  js_as_print <- '
    echo("rk.header(\'Dashboard Assembled\')\\n");
    echo("rk.print(\'<br><b>Previewing Dashboard...</b>\')\\n");
    echo("print(dashboard_obj)\\n");
  '

    comp_as <- rk.plugin.component("6. Dashboard Assembler", xml = list(dialog = as_dialog), js = list(require = c("crosstalk", "bslib", "htmltools"), calculate = js_as_calc, printout = js_as_print), hierarchy = h_menu)

  # =========================================================================================
  # MODULE 7: Export to HTML
  # =========================================================================================
  ex_obj <- rk.XML.varslot(id.name = "ex_obj", label = "Dashboard Object to Save", source = "shared_workspace_selector", required = TRUE)

  # CORRECCIÓN: El type debe ser "savefile", no "save"
  ex_file <- rk.XML.browser(label = "Save as (.html)", type = "savefile", id.name = "ex_file")

  ex_dialog <- rk.XML.dialog(label = "7. Export Dashboard to HTML", child = rk.XML.row(shared_var_selector, rk.XML.col(rk.XML.text("Select the completed Dashboard Object, and choose a folder on your computer to save it as a standalone interactive webpage."), ex_obj, ex_file)))

  js_ex_calc <- '
    var obj = getValue("ex_obj");
    var file = getValue("ex_file");
    echo("export_path <- \'" + file + "\'\\n");

    // Usamos endsWith() para evitar por completo el problema de escapar caracteres con grepl
    echo("if(!endsWith(export_path, \'.html\')) export_path <- paste0(export_path, \'.html\')\\n");

    echo("htmltools::save_html(" + obj + ", file = export_path)\\n");
  '

  js_ex_print <- 'echo("rk.header(\'Dashboard Exported Successfully\')\\nrk.print(paste0(\'<b>File saved to:</b> \', export_path))\\n");'

  comp_ex <- rk.plugin.component("7. Export to HTML", xml = list(dialog = ex_dialog), js = list(require = "htmltools", calculate = js_ex_calc, printout = js_ex_print), hierarchy = h_menu)

  # =========================================================================================
  # SKELETON BUILD
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = dl_dialog),
    js = list(require = "crosstalk", calculate = js_dl_calc, printout = js_dl_print),
    components = list(comp_sl, comp_pl, comp_dt, comp_sc, comp_as, comp_ex),
    pluginmap = list(name = "1. Data Model Linker", hierarchy = h_menu),
    create = c("pmap", "xml", "js", "desc"),
    overwrite = TRUE, load = TRUE, show = FALSE
  )
})
