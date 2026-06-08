# rk.interactive.bi

![Version](https://img.shields.io/badge/Version-0.0.1-blue.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![RKWard](https://img.shields.io/badge/Platform-RKWard-green)
[![R Linter](https://github.com/AlfCano/rk.interactive.bi/actions/workflows/lintr.yml/badge.svg)](https://github.com/AlfCano/rk.interactive.bi/actions/workflows/lintr.yml)
![AI Gemini](https://img.shields.io/badge/AI-Gemini-4285F4?logo=googlegemini&logoColor=white)

**An RKWard GUI Plugin for Power BI-style Interactive Dashboards**

`rk.interactive.bi` provides a seamless, point-and-click graphical interface inside RKWard to create interactive, cross-filtered dashboards without needing a Shiny server. Acting as a unified GUI wrapper for powerful web-rendering R packages like [`crosstalk`](https://cran.r-project.org/package=crosstalk), [`plotly`](https://cran.r-project.org/package=plotly), [`DT`](https://cran.r-project.org/package=DT), [`kpiwidget`](https://cran.r-project.org/package=kpiwidget), and [`bslib`](https://cran.r-project.org/package=bslib), this plugin allows users to build modular visual analytics and export them as standalone HTML files.

This package includes a **multi-component workflow** structured neatly into 7 sequential steps to keep the interface clean and intuitive.

---

## 🌟 Key Features

* **Zero-Code Dashboards:** Build complex, interactive HTML dashboards directly from your datasets.
* **Client-Side Cross-Filtering:** Filter a dataset using a slicer, and watch your plots, tables, and KPI cards update instantly in the browser without an active R session.
* **Modular Widget Assembly:** Create individual components (Plots, Slicers, Tables, Cards) and seamlessly stitch them together using Bootstrap Grid Math.
* **Standalone Export:** Save your fully interactive dashboard as a single `.html` file that can be emailed or hosted anywhere.
* **Multilingual:** Fully translated into English, Spanish, French, German, and Portuguese (Brazil).

---

## ⚙️ Prerequisites

You must have [RKWard](https://rkward.kde.org/) installed along with the following R packages:

```R
install.packages(c("crosstalk", "plotly", "DT", "kpiwidget", "bslib", "htmltools"))
```

---

## 🚀 Installation

You can install this plugin directly from GitHub using `devtools`:

```R
# Install the plugin
devtools::install_github("AlfCano/rk.interactive.bi")
```

Once installed, open RKWard, navigate to **Settings -> Configure RKWard -> Plugins**, and activate `rk.interactive.bi`.

---

## 🛠️ Usage Workflow

This plugin adds a new top-level menu to RKWard called **Interactive BI**, featuring a 7-step modular workflow:

### 1. Data Model Linker
Convert a standard `data.frame` into a `SharedData` object. This is the "glue" that allows widgets to talk to each other.
### 2. Interactive Slicer
Create Dropdowns, Checkboxes, or Sliders linked to your SharedData object to filter variables.
### 3. Interactive Plot
Build dynamic, hoverable Scatter, Bar, or Line charts using `plotly`.
### 4. Interactive Table
Generate a paginated, searchable, and sortable data matrix using `DT`.
### 5. Summary Card (KPI)
Create styled, numeric indicator cards that aggregate data (Sum, Mean, Count) using `kpiwidget`.
### 6. Dashboard Assembler
Combine your saved widgets into a single layout. Use Bootstrap themes (Darkly, Flatly, Cerulean) and define column widths visually.
### 7. Export to HTML
Save your assembled dashboard locally as a standalone interactive web page.

---

## 🧪 The Testing Workflow

To test the generated plugins and see the magic of cross-filtering, follow this step-by-step guide. First, paste this into the RKWard console to create a mock BI dataset:

```r
# Create a Mock Sales Dataset
sales_data <- data.frame(
  Region = sample(c("North", "South", "East", "West"), 200, replace = TRUE),
  Category = sample(c("Electronics", "Furniture", "Office Supplies"), 200, replace = TRUE),
  Profit = round(runif(200, -50, 500), 2),
  Sales = round(runif(200, 100, 1000), 2)
)
```

**Step-by-step Test:**

1.  **Open `Interactive BI > 1. Data Model Linker`**
    *   *Base Data.frame:* Select `sales_data`
    *   *Output tab:* Keep default (`shared_data_obj`). Click **Submit**.
2.  **Open `Interactive BI > 2. Interactive Slicer`**
    *   *SharedData Object:* Select `shared_data_obj`
    *   *Variable to Filter:* Select `Region`
    *   *Slicer Type:* Dropdown/Checkbox
    *   *Output tab:* Keep default (`slicer_obj`). Click **Submit**.
3.  **Open `Interactive BI > 3. Interactive Plot`**
    *   *SharedData Object:* Select `shared_data_obj`
    *   *X Axis:* Select `Sales`
    *   *Y Axis:* Select `Profit`
    *   *Color By:* Select `Category`
    *   *Plot Type:* Scatter Plot
    *   *Output tab:* Keep default (`plotly_obj`). Click **Submit**.
4.  **Open `Interactive BI > 4. Interactive Table`**
    *   *SharedData Object:* Select `shared_data_obj`
    *   *Output tab:* Keep default (`table_obj`). Click **Submit**.
5.  **Open `Interactive BI > 5. Summary Card (KPI)`**
    *   *SharedData Object:* Select `shared_data_obj`
    *   *Variable to Aggregate:* Select `Sales`
    *   *Statistic:* Sum
    *   *Card Title / Label:* Type `Total Sales`
    *   *Output tab:* Keep default (`card_obj`). Click **Submit**.
6.  **Open `Interactive BI > 6. Dashboard Assembler`**
    *   *Select visuals, slicers, and cards:* Hold CTRL and select **all 4 output objects**: `slicer_obj`, `card_obj`, `plotly_obj`, and `table_obj`.
    *   *Column Widths:* Type `3, 3, 6, 12` *(This means: Slicer gets 3 columns, Card gets 3 columns, Plot gets 6 columns, and Table drops to the next row taking up all 12 columns).*
    *   Click **Submit**.
7.  **Open `Interactive BI > 7. Export Dashboard to HTML`**
    *   *Dashboard Object to Save:* Select `dashboard_obj`
    *   *Save as (.html):* Click the folder icon, navigate to your Desktop, and type a name like `my_dashboard.html`.
    *   Click **Submit**.

**Result:** A fully interactive HTML widget will open in your RKWard viewer showing a dashboard with a slicer, a KPI card, a scatter plot, and a table. If you click the "North" region on the slicer, all the widgets (including the KPI Card total) will instantly filter to match. You will also have a standalone `.html` file on your Desktop that you can send to anyone!

---

## 🌍 Internationalization (i18n)

The graphical interface automatically adapts to your RKWard language settings. Currently supported languages:
* 🇺🇸 English (Default)
* 🇪🇸 Spanish (Español)
* 🇫🇷 French (Français)
* 🇩🇪 German (Deutsch)
* 🇧🇷 Portuguese (Português do Brasil)

---

## 📝 License and Author

**Author:** Alfonso Cano ([@AlfCano](https://github.com/AlfCano))  
**Email:** alfonso.cano@correo.buap.mx  
*   **Assisted by:** Gemini, a large language model from Google.
*   **License:** GPL (>= 3)

This project is licensed under the **GPL (>= 3)** License.
