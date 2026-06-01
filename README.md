# China’s solar expansion policy reduces bird diversity

## Replication Code for "China’s solar expansion policy reduces bird diversity"

## Overview

This replication package contains the Stata code and data necessary to reproduce all tables and figures in the paper. The analysis examines the impact of photovoltaic (PV) policy stringency on bird diversity across 2,344 counties in China from 2014 to 2023.

---

## Software Requirements

- **Stata** (version 16 or later recommended)
- **Required Stata packages:**
 - `reghdfe` — High-dimensional fixed effects regression
 - `ivreghdfe` — Instrumental variable regression with high-dimensional fixed effects
 - `estout` / `esttab` — Exporting regression results
 - `winsor2` — Winsorization of variables
 - `psmatch2` — Propensity score matching
 - `binscatter` — Binned scatterplots
 - `estadd` — Adding scalars to estimation results

To install required packages, run:
```stata
ssc install reghdfe
ssc install ivreghdfe
ssc install estout
ssc install winsor2
ssc install psmatch2
ssc install binscatter
```

---

## Directory Structure

```
/DATA/                          <- All input datasets (.dta files)
/Documents/                     <- All output files (tables in .rtf, figures in .pdf)
code.txt                        <- Main Stata do-file
README.md                       <- This file
```

---

## Data Files

### Core Variables

| File | Description |
|------|-------------|
| `Bird.dta` | Bird diversity indices (Shannon, Simpson) at county-month level |
| `BTN.dta` | Birdwatching time (BT) and number of birdwatchers (BN) |
| `PI.dta` | Photovoltaic policy stringency index (PSI) |
| `Climate.dta` | Climate controls: average temperature (Avt) and wind speed (Wind) |
| `PD.dta` | Population density |
| `air.dta` | Air quality: CO2 emissions and PM2.5 |
| `TD.dta` | Land use: water, green cover, farmland, grassland areas |

### Alternative Measures & Robustness

| File | Description |
|------|-------------|
| `PI1.dta` – `PI6.dta` | Alternative PSI constructions with different scoring/weighting schemes |
| `IC.dta` | Installed capacity of centralized PV power stations |
| `cities.dta` | Provincial capital and municipality indicator |
| `enin.dta` | Central Environmental Inspection (CEI) policy indicator |
| `Coal.dta` | Coal-fired power plant closure indicator |
| `Windexp.dta` | Wind power expansion indicator |
| `BirdDrop3.dta` – `BirdDrop20.dta` | Bird diversity after excluding low-activity observations |
| `highPI.dta` | Indicator for counties neighboring high-PI counties |

### Instrumental Variables

| File | Description |
|------|-------------|
| `sunshine.dta` | Average sunshine duration (1984–2013) by county |
| `CCPU.dta` | City-level Climate Policy Uncertainty (CPU) index |

### Heterogeneity Analysis

| File | Description |
|------|-------------|
| `poverty.dta` | National poverty county designation |
| `north_region.dta` | Three-North Shelterbelt region indicator |
| `Gebi.dta` | Sandy and gravel desert indicator |
| `Migratory.dta`, `Resident.dta` | Diversity by migratory vs. resident species |
| `Endemic.dta`, `non_Endemic.dta` | Diversity by endemism status |
| `Protected.dta`, `non_Protected.dta` | Diversity by national protection status |
| `Nest_veg.dta`, `Land_water.dta` | Diversity by nesting guild |
| `non_Herbivorous.dta`, `Herbivorous.dta` | Diversity by dietary guild |
| `Small_flock.dta`, `Large_flock.dta` | Diversity by flocking behavior |

### Mechanism Variables

| File | Description |
|------|-------------|
| `Ndvi.dta` | Normalized Difference Vegetation Index (NDVI) |
| `NL.dta` | Nighttime light intensity |
| `LAI.dta` | Leaf Area Index |

### Economic Consequences

| File | Description |
|------|-------------|
| `Richeven.dta` | Species richness |
| `AP.dta` | Agricultural crop yield |

---

## Variable Definitions

| Variable | Definition |
|----------|------------|
| `ShannonBD` | Shannon Diversity Index: −Σ(pᵢ × ln(pᵢ)) |
| `SimpsonBD` | Simpson Diversity Index: 1 − Σ(pᵢ²) |
| `PI` | Photovoltaic policy stringency index (weighted sum across government levels) |
| `Area` | Centralized PV station area (km²), derived from installed capacity |
| `Temp` | Annual average temperature |
| `Wind` | Annual average wind speed |
| `Pop` | ln(population density) |
| `Duration` | ln(birdwatching time / number of birdwatchers + 1) |
| `Carbon` | ln(CO₂ emissions) |
| `Water` | Water area / total area |
| `Green` | (Forest + shrub area) / total area |
| `Farm` | Farmland area / total area |
| `Grass` | Grassland area / total area |
| `Sun_ccpu` | Instrumental variable: ln(sunshine) / city CPU |
| `CCPU` | City-level Climate Policy Uncertainty index |

---

## Reproducing Results

### Step 1: Set Working Directory

Update the file path at the top of `code.txt` to match your local directory:

```stata
cd "/your/path/to/DATA"
```

Also update the output directory:

```stata
cd "/your/path/to/Documents"
```

### Step 2: Run the Code

Execute `code.txt` sequentially in Stata. The script is organized into the following sections:

---

## Code Structure and Output Mapping

| Section | Description | Output File(s) |
|---------|-------------|----------------|
| **Data Preparation** | Merges all datasets, constructs variables, winsorizes, generates IVs | — |
| **Descriptive Statistics** | Summary statistics and correlation matrix | `sum_stats.rtf` (Table S4) |
| **Baseline Regression** | Main OLS with fixed effects | `baseline.rtf` (Table 1) |
| **Endogeneity Treatment** | IV estimation (shift-share), PSM | `IV.rtf` (Table S7), `CCPU_exogeneity.rtf` (Table S8), `SSIV_table1.rtf` (Table S9), `SSIV_table2.rtf` (Table S10), `psm.rtf` (Table S11) |
| **Robustness Checks** | Alternative variables, samples, thresholds, confounding policies | `robust_alternative_var.rtf` (Table S12), `robust_alternative_model.rtf` (Table S13), `robust_exclude.rtf` (Table S14), `robust_eliminate_policy.rtf` (Table S15), `robust_other.rtf` (Table S16) |
| **Heterogeneity Analysis 1** | Cross-sectional heterogeneity (poverty, Three-North, desert) | `heterogeneity1.rtf` (Table S17) |
| **Heterogeneity Analysis 2** | Bird species heterogeneity (traits-based) | `heterogeneity2.rtf`, `heterogeneity3.rtf` (Table S18) |
| **Plausible Channels** | Mechanism tests (NDVI, nightlight, leaf area) | `mechenism.rtf` (Table 2) |
| **Further Discussion** | Lagged effects, richness, evenness, crop yield | `outcomes.rtf` (Table S19) |
| **CPU Variation** | Within-city temporal variation diagnostics | `CPU_within_variation.rtf` (Table R1), `CPU_annual_summary.rtf` (Table R2) |
| **PV-Area Analysis** | Correlation between PSI and PV installation area | `FigS2.pdf` (Figure S2) |

---

## Identification Strategy

The main specification is:

```
ShannonBDᵢₜ = β × PSIᵢₜ + γ × Controlsᵢₜ + αᵢ + δₜ + εᵢₜ
```

where:
- `i` indexes counties, `t` indexes year-month
- `αᵢ` = county fixed effects
- `δₜ` = year-month fixed effects
- Standard errors are clustered at the county level

**Instrumental Variable:** The shift-share instrument is constructed as:

```
IV = ln(Sunshine₁₉₈₄₋₂₀₁₃) / City CPUₜ
```

- **Share (time-invariant):** Natural logarithm of historical average sunshine duration (1984–2013)
- **Shift (time-varying):** Inverse of the city-level Climate Policy Uncertainty index

---

## Key Methodological Notes

1. **Winsorization:** All continuous variables are winsorized at the 1st and 99th percentiles.
2. **Fixed Effects:** All regressions include county and year-month fixed effects using `reghdfe`.
3. **Clustering:** Standard errors are clustered at the county level throughout.
4. **Sample:** 2,344 counties across China, 2014–2023 (monthly observations).
5. **Missing Values:** PI and related policy variables are set to 0 when missing (reflecting absence of policy).

---

## Data Availability

- Bird observation data are sourced from citizen science birdwatching platforms.
- Climate and land-use data are from remote sensing and official statistical yearbooks.
- The Climate Policy Uncertainty (CPU) index is sourced from Ma et al. (2023).
- Sunshine duration data are from meteorological station records (1984–2013).

---

## Citation

If you use this replication package, please cite the associated paper.

---

## Contact

For questions regarding the replication package, please contact the corresponding author.
