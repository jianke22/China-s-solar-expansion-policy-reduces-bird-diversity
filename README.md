# China’s solar expansion policy reduces bird diversity

## Replication Code for "China’s solar expansion policy reduces bird diversity"

## Overview

This repository contains the Stata replication code for analyzing the relationship between photovoltaic (solar) policy intensity and bird biodiversity across Chinese counties from 2014 to 2023. The study employs a two-way fixed effects framework (county and year-month) to examine how solar energy policies affect avian diversity, as measured by the Shannon Biodiversity Index.

## Table of Contents

- [Research Summary](#research-summary)
- [Data Requirements](#data-requirements)
- [Software Requirements](#software-requirements)
- [Repository Structure](#repository-structure)
- [Variable Descriptions](#variable-descriptions)
- [Code Structure](#code-structure)
- [How to Reproduce](#how-to-reproduce)
- [Output Files](#output-files)
- [Citation](#citation)
- [License](#license)

## Research Summary

This study investigates the unintended ecological consequences of China's rapid solar energy expansion on bird biodiversity. Using county-level panel data covering 2,344 counties over the period 2014–2023, we find that increased photovoltaic policy intensity significantly reduces bird biodiversity. The analysis includes:

1. **Baseline regression** with two-way fixed effects (county + year-month)
2. **Endogeneity treatment** using instrumental variables (historical sunshine duration / climate policy uncertainty) and propensity score matching
3. **Robustness checks** including alternative variable measures, sample interval adjustments, elimination of confounding policy effects, and additional controls
4. **Heterogeneity analysis** across geographic regions (poverty counties, Three-North regions, desert/gobi areas) and bird species characteristics (endemic vs. non-endemic, migratory vs. resident, protected vs. non-protected, nesting guilds, dietary guilds, flocking behavior)
5. **Mechanism analysis** exploring channels through NDVI, nightlight intensity, and leaf area index
6. **Further discussion** on socioeconomic consequences including species richness, evenness, and agricultural crop yields

## Data Requirements

The analysis requires the following `.dta` files placed in the data directory:

### Core Variables

| File | Description | Key Variables |
|------|-------------|---------------|
| `Bird.dta` | Bird biodiversity observations | `ShannonBD`, `SimpsonBD`, `id`, `year` |
| `BTN.dta` | Birdwatching effort | `BT` (birdwatching time), `BN` (number of birdwatchers) |
| `PI.dta` | Photovoltaic policy intensity | `PI` |
| `Climate.dta` | Climate variables | `Avt` (average temperature), `Wind` |
| `PD.dta` | Population density | `PD` |
| `air.dta` | Air quality | `CO2`, `PM` (PM2.5) |
| `TD.dta` | Land use composition | `Water`, `Green`, `Farm`, `Grass` |

### Robustness Check Variables

| File | Description | Key Variables |
|------|-------------|---------------|
| `PI1.dta` – `PI6.dta` | Alternative policy intensity measures | `PI1`–`PI6` (different weighting schemes) |
| `IC.dta` | Installed capacity of centralized PV stations | `ICtotal` |
| `cities.dta` | Provincial capital / municipality indicator | `cities` |
| `enin.dta` | Central environmental inspection policy | `enin` → `CEI` |
| `Coal.dta` | Coal-fired power plant closures | `FFP` → `Coal` |
| `Windexp.dta` | Wind power expansion | `风电数量` → `Windexp` |
| `highPI.dta` | Neighbor indicator for high-PI counties | `is_neighbor_of_highPI` |

### Instrumental Variable Data

| File | Description | Key Variables |
|------|-------------|---------------|
| `sunshine.dta` | Historical average sunshine duration (1984–2013) | `sun` |
| `CCPU.dta` | City-level climate policy uncertainty index | `CCPU` |

### Heterogeneity Variables

| File | Description | Key Variables |
|------|-------------|---------------|
| `poverty.dta` | National poverty county designation | `poverty_county` |
| `north_region.dta` | Three-North Shelterbelt region indicator | `north_region` |
| `Gebi.dta` | Sandy and gravel desert indicator | `desert_gobi` |
| `Migratory.dta` | Migratory bird diversity | `Migratory` |
| `Resident.dta` | Resident bird diversity | `Resident` |
| `Endemic.dta` | Endemic species diversity | `Endemic` |
| `non_Endemic.dta` | Non-endemic species diversity | `non_Endemic` |
| `Protected.dta` | Protected species diversity | `Protected` |
| `non_Protected.dta` | Non-protected species diversity | `non_Protected` |
| `Nest_veg.dta` | Vegetation-nesting bird diversity | `Nest_veg` |
| `Land_water.dta` | Land/water-nesting bird diversity | `Land_water` |
| `non_Herbivorous.dta` | Carnivorous and omnivorous bird diversity | `non_Herbivorous` |
| `Herbivorous.dta` | Herbivorous bird diversity | `Herbivorous` |
| `Small_flock.dta` | Small-flock bird diversity | `Small_flock` |
| `Large_flock.dta` | Large-flock bird diversity | `Large_flock` |

### Mechanism Variables

| File | Description | Key Variables |
|------|-------------|---------------|
| `Ndvi.dta` | Normalized Difference Vegetation Index | `Ndvi` |
| `NL.dta` | Nightlight intensity | `Nightlight` |
| `LAI.dta` | Leaf Area Index | `LAI` |

### Economic Consequence Variables

| File | Description | Key Variables |
|------|-------------|---------------|
| `Richeven.dta` | Species richness | `丰富度` → `Richness` |
| `AP.dta` | Agricultural production output | `APtotal` |

## Software Requirements

- **Stata** 16.0 or later (MP/SE recommended for large-panel computation)
- Required user-written packages:
 - [`reghdfe`](https://github.com/sergiocorreia/reghdfe) — High-dimensional fixed effects regression
 - [`ivreghdfe`](https://github.com/sergiocorreia/ivreghdfe) — IV regression with high-dimensional fixed effects
 - [`estout`](http://repec.sowi.unibe.ch/stata/estout/) — Exporting estimation results (`esttab`, `eststo`, `estadd`, `estpost`)
 - [`winsor2`](https://github.com/GuanghuiDu/Winsor) — Winsorization of continuous variables
 - [`psmatch2`](https://ideas.repec.org/c/boc/bocode/s432001.html) — Propensity score matching
 - [`ftools`](https://github.com/sergiocorreia/ftools) — Required dependency for `reghdfe`

### Installation

Install all required packages by running:

```stata
ssc install reghdfe, replace
ssc install ftools, replace
ssc install ivreghdfe, replace
ssc install estout, replace
ssc install winsor2, replace
ssc install psmatch2, replace
```

## Repository Structure

```
├── README.md                  # This file
├── CODE.do                    # Main Stata do-file (full replication code)
├── DATA/                      # Data directory (not included; see Data Requirements)
│   ├── Bird.dta
│   ├── BTN.dta
│   ├── PI.dta
│   ├── Climate.dta
│   ├── PD.dta
│   ├── air.dta
│   ├── TD.dta
│   ├── PI1.dta – PI6.dta
│   ├── IC.dta
│   ├── cities.dta
│   ├── enin.dta
│   ├── Coal.dta
│   ├── Windexp.dta
│   ├── sunshine.dta
│   ├── CCPU.dta
│   ├── highPI.dta
│   ├── poverty.dta
│   ├── north_region.dta
│   ├── Gebi.dta
│   ├── Migratory.dta
│   ├── Resident.dta
│   ├── Endemic.dta
│   ├── non_Endemic.dta
│   ├── Protected.dta
│   ├── non_Protected.dta
│   ├── Nest_veg.dta
│   ├── Land_water.dta
│   ├── non_Herbivorous.dta
│   ├── Herbivorous.dta
│   ├── Small_flock.dta
│   ├── Large_flock.dta
│   ├── Ndvi.dta
│   ├── NL.dta
│   ├── LAI.dta
│   ├── Richeven.dta
│   └── AP.dta
└── Documents/                 # Output directory for tables
    ├── sum_stats.rtf
    ├── baseline.rtf
    ├── IV.rtf
    ├── psm.rtf
    ├── robust_alternative_var.rtf
    ├── robust_alternative_model.rtf
    ├── robust_eliminate_policy.rtf
    ├── robust_other.rtf
    ├── heterogeneity1.rtf
    ├── heterogeneity2.rtf
    ├── heterogeneity3.rtf
    ├── mechenism.rtf
    └── outcomes.rtf
```

## Variable Descriptions

### Dependent Variables

| Variable | Description |
|----------|-------------|
| `ShannonBD` | Shannon Biodiversity Index — the negative sum of the proportion of each bird species multiplied by its natural logarithm |
| `SimpsonBD` | Simpson Diversity Index — one minus the sum of the squared proportions of each bird species |
| `Richness` | Species richness — total number of species observed within the survey area |
| `Evenness` | Species evenness — ratio of ShannonBD to the logarithm of species richness |

### Independent Variable

| Variable | Description |
|----------|-------------|
| `PI` | Photovoltaic policy intensity — weighted sum of policies at the provincial, municipal, and county levels |

### Alternative Independent Variables

| Variable | Description |
|----------|-------------|
| `Area` | Centralized PV station area (km²), derived from installed capacity |
| `PI1` | Arithmetic progression scores (1, 2, 3) with hierarchical weights (0.5, 0.3, 0.2) |
| `PI2` | Geometric progression scores (1, 2, 4) with hierarchical weights (0.5, 0.3, 0.2) |
| `PI3` | Exponential progression scores (2, 4, 8) with hierarchical weights (0.5, 0.3, 0.2) |
| `PI4` | Arithmetic progression scores (1, 2, 3) with equal weights |
| `PI5` | Geometric progression scores (1, 2, 4) with equal weights |
| `PI6` | Exponential progression scores (2, 4, 8) with equal weights |

### Control Variables

| Variable | Description |
|----------|-------------|
| `Temp` | Annual average temperature |
| `Wind` | Annual average wind speed |
| `Pop` | Log of population density (total population / regional area) |
| `Duration` | Log of birdwatching effort (birdwatching time / number of birdwatchers + 1) |
| `Carbon` | Log of carbon emissions |
| `Water` | Proportion of water area to total area |
| `Green` | Proportion of forest and shrub area to total area |
| `Farm` | Proportion of farmland area to total area |
| `Grass` | Proportion of grassland area to total area |
| `PM` | Log of PM2.5 concentration (used in additional robustness check) |

### Instrumental Variable

| Variable | Description |
|----------|-------------|
| `Sun_ccpu` | Ln(average sunshine duration 1984–2013) / city-level climate policy uncertainty index |

### Policy Indicators (Robustness)

| Variable | Description |
|----------|-------------|
| `CEI` | Central environmental inspection (=1 if inspection team stationed in the province-year) |
| `Coal` | Coal-fired power plant closure (=1 if a plant was closed in the county-year) |
| `Windexp` | Wind power expansion (=1 if new wind facilities constructed in the county-year) |
| `Greenfin` | Green finance pilot zone (=1 if designated as National Green Finance Reform and Innovation Pilot Zone) |

### Mechanism Variables

| Variable | Description |
|----------|-------------|
| `Ndvi` | Normalized Difference Vegetation Index (scaled ×100) |
| `Nightlight` | Nightlight intensity from satellite raster data |
| `LAI` | Leaf Area Index — total leaf area per unit ground area |

### Heterogeneity Grouping Variables

| Variable | Description |
|----------|-------------|
| `poverty_county` | National poverty county designation (=1 if poverty county) |
| `north_region` | Three-North Shelterbelt Program region (=1 if in the Three-North region) |
| `desert_gobi` | Sandy and gravel desert area (=1 if desert/gobi) |

### Bird Subgroup Dependent Variables

| Variable | Description |
|----------|-------------|
| `Endemic` / `non_Endemic` | Diversity of endemic vs. non-endemic species |
| `Migratory` / `Resident` | Diversity of migratory vs. resident species |
| `Protected` / `non_Protected` | Diversity of nationally protected vs. non-protected species |
| `Nest_veg` / `Land_water` | Diversity by nesting guild (vegetation vs. land/water) |
| `Herbivorous` / `non_Herbivorous` | Diversity by dietary guild (herbivorous vs. carnivorous/omnivorous) |
| `Small_flock` / `Large_flock` | Diversity by flocking behavior (small vs. large flocks) |

## Code Structure

The do-file (`CODE.do`) is organized into the following sequential sections:

### 1. Data Import and Merging

Merges 30+ datasets by county-year identifiers (`id`, `YEAR`), including core variables, robustness variables, instrumental variables, heterogeneity indicators, mechanism variables, and economic consequence variables. Programmatically generates the green finance pilot zone indicator (`Greenfin`) based on policy implementation dates and geographic coverage.

### 2. Data Preprocessing

- Generates birdwatching effort per capita (`BTN = BT/BN`)
- Replaces missing policy intensity values with zero
- Drops observations with missing control variables
- Converts installed capacity to area (`Area = ICtotal × 1000 / 0.15 / 1,000,000` km²)
- Applies logarithmic transformations to `PD`, `BTN`, `CO2`, `PM25`, and `APtotal`
- Winsorizes all continuous variables at the 1st and 99th percentiles
- Generates county group identifiers

### 3. Descriptive Statistics (`sum_stats.rtf`)

- Summary statistics table (N, Mean, S.D., Min, Max)
- Pearson correlation matrix with significance stars

### 4. Baseline Regression (`baseline.rtf`)

Three specifications with progressively added controls:
1. PI only + county and year-month FE
2. PI + climate and demographic controls
3. PI + full controls (including land use composition)

### 5. Endogeneity Treatment

- **Instrumental Variables** (`IV.rtf`): First-stage and second-stage IV regression using `Sun_ccpu` as instrument
- **Propensity Score Matching


** (`psm.rtf`): Three matching strategies:
 1. 1:1 nearest neighbor matching (caliper = 0.05)
 2. 1:2 nearest neighbor matching (caliper = 0.05)
 3. Kernel matching

### 6. Robustness Checks

- **Alternative variable measures** (`robust_alternative_var.rtf`): 8 specifications with alternative independent and dependent variables
- **Alternative sampling criteria** (`robust_alternative_model.rtf`): Excludes outlier counties, high-PI counties, and provincial capitals/municipalities
- **Confounding policy effects** (`robust_eliminate_policy.rtf`): Controls for central environmental inspection, coal plant closures, wind power expansion, green finance pilots, and all combined
- **Other robustness checks** (`robust_other.rtf`): Additional PM2.5 control, exclusion of high-PI neighboring counties, and seasonal subsample (May–July breeding season)

### 7. Heterogeneity Analysis

- **Cross-sectional heterogeneity** (`heterogeneity1.rtf`): Subsample regressions by poverty status, Three-North region, and desert/gobi classification
- **Bird species heterogeneity** (`heterogeneity2.rtf`, `heterogeneity3.rtf`): Subsample regressions across 12 bird subgroups classified by endemism, migratory status, conservation status, nesting guilds, dietary guilds, and flocking behavior

### 8. Mechanism Analysis (`mechenism.rtf`)

Tests three plausible channels through which solar policy affects bird biodiversity:
1. NDVI (vegetation greenness)
2. Nightlight intensity (economic activity / habitat disturbance)
3. Leaf Area Index (vegetation structure)

### 9. Further Discussion (`outcomes.rtf`)

- Lagged policy effects on biodiversity
- Impact on species richness and evenness
- Downstream effects on agricultural crop yields (one-period lead)

## How to Reproduce

### Step 1: Set Up Directory Structure

Create the following directory structure on your local machine:

```
project_root/
├── DATA/          # Place all .dta files here
└── Documents/     # Output tables will be saved here
```

### Step 2: Modify File Paths

Open `CODE.do` and update the two directory paths at the top and middle of the file:

```stata
* Update this path to your data directory
cd "YOUR_PATH/DATA"

* Update this path to your output directory (appears later in the code)
cd "YOUR_PATH/Documents"
```

### Step 3: Install Required Packages

Run the following in Stata:

```stata
ssc install reghdfe, replace
ssc install ftools, replace
ssc install ivreghdfe, replace
ssc install estout, replace
ssc install winsor2, replace
ssc install psmatch2, replace
```

### Step 4: Execute the Code

Run the entire do-file:

```stata
do "YOUR_PATH/CODE.do"
```

Or run individual sections by selecting the relevant code blocks in the Stata do-file editor.

### Expected Runtime

- Full execution: approximately 15–30 minutes depending on hardware (dataset covers 2,344 counties × 10 years with monthly observations)
- Individual sections: 1–5 minutes each

## Output Files

All output tables are saved as `.rtf` files in the `Documents/` directory:

| File | Table | Description |
|------|-------|-------------|
| `sum_stats.rtf` | Table S4 | Descriptive statistics and Pearson correlation matrix |
| `baseline.rtf` | Table 1 | Baseline regression results |
| `IV.rtf` | Table S6 | Instrumental variable first-stage and second-stage estimates |
| `psm.rtf` | Table S7 | Propensity score matching results |
| `robust_alternative_var.rtf` | Table S8 | Robustness checks with alternative variable measures |
| `robust_alternative_model.rtf` | Table S9 | Robustness checks with alternative sampling criteria |
| `robust_eliminate_policy.rtf` | Table S10 | Ruling out confounding policy effects |
| `robust_other.rtf` | Table S11 | Other robustness checks (PM2.5, neighboring counties, seasonality) |
| `heterogeneity1.rtf` | Table S12 | Cross-sectional heterogeneity (poverty, Three-North, desert) |
| `heterogeneity2.rtf` | Table S13 (Panel A) | Bird species heterogeneity (endemic, migratory, protected) |
| `heterogeneity3.rtf` | Table S13 (Panel B) | Bird species heterogeneity (nesting, diet, flocking) |
| `mechenism.rtf` | Table 2 | Mechanism analysis (NDVI, nightlight, leaf area) |
| `outcomes.rtf` | Table S14 | Further discussion (lagged effects, richness, evenness, crop yield) |

## Key Econometric Specifications

### Baseline Model

$$BD_{it} = \beta_0 + \beta_1 PI_{it} + \gamma X_{it} + \alpha_i + \delta_t + \varepsilon_{it}$$

Where:
- $BD_{it}$: Bird biodiversity (Shannon Index) for county $i$ in year-month $t$
- $PI_{it}$: Photovoltaic policy intensity
- $X_{it}$: Vector of control variables
- $\alpha_i$: County fixed effects
- $\delta_t$: Year-month fixed effects
- $\varepsilon_{it}$: Error term clustered at the county level

### Instrumental Variable Strategy

The instrument `Sun_ccpu` is constructed as:

$$IV_{it} = \frac{\ln(\overline{Sunshine}_i)}{CCPU_{ct}}$$

Where $\overline{Sunshine}_i$ is the 30-year average sunshine duration (1984–2013) for county $i$, and $CCPU_{ct}$ is the city-level climate policy uncertainty index from [Ma et al. (2023)](https://doi.org/10.1038/s41597-023-02817-5).

**Rationale**: Historical sunshine duration is a strong predictor of solar policy adoption (relevance condition) but is unlikely to directly affect contemporary bird biodiversity except through the policy channel (exclusion restriction). Dividing by climate policy uncertainty captures exogenous temporal variation in policy implementation intensity.

## Data Availability

> **Note**: The raw data files (`.dta`) are not included in this repository due to size and licensing constraints. Researchers interested in replicating the results should contact the authors for data access or refer to the following sources:

- **Bird biodiversity data**: Derived from citizen science birdwatching records in China (2014–2023)
- **Photovoltaic policy data**: Collected from official policy documents at provincial, municipal, and county levels
- **Climate data**: China Meteorological Administration
- **Socioeconomic data**: National Bureau of Statistics of China
- **Remote sensing data** (NDVI, Nightlight, LAI): Google Earth Engine / NASA MODIS
- **Climate policy uncertainty index**: [Ma et al. (2023), *Scientific Data*](https://doi.org/10.1038/s41597-023-02817-5)

## Citation

If you use this code or find this work useful, please cite:

```bibtex
@article{zhang2025solar,
  title={Solar Policy Intensity and Bird Biodiversity: Evidence from Chinese Counties},
  author={Zhang, Aixin and others},
  journal={},
  year={2025},
  note={Working paper}
}
```
