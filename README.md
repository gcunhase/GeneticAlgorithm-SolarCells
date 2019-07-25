## About
* Single and multi-layer solar cell thickness optimization through genetic algorithm
* Evolutionary algorithm in ZnO and MoOx Optical Spacer
  <p align="left">
  <img src="./assets/solar_cell_device_structure.png" width="200" alt="Solar cell device structure">
  </p>

  > Solar cell device structure

## Contents
[Dependencies](#dependencies) • [How to Use](#how-to-use) • [Results](#results) • [Cite](#acknowledgement)

## Dependencies
* Tested on Windows 7 and Ubuntu 18.04 and Matlab 2018b and 2019a
* Toolboxes:
    * Add-Ons > Get Add-Ons
    * *de2bi* and *bi2de* functions:
        * Communication System Toolbox (Matlab 2018b)
        * Communications Toolbox (Matlab 2019a)
    * Parallel Computing Toolbox
    * Trading Toolbox
* `cprintf.m` ([download link](https://www.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-the-command-window))

## How to Use
1. Run code:
    * Single layer: `./[MoOx or ZnO folder]/[MoOx or ZnO]_Main_frontend_gui.m`
    * Multiple layer: `./[ZnO+MoOx folder]/[ZnO_and_MoOx]_Main_frontend_gui.m`
2. Choose how many runs of each selection to perform

## Results
* Results (accuracy, mean, standard deviation) are saved in Excel files, with number of sheets equivalent to the number of runs in each selection.

  | Selection Type | ZnO | MoOx | ZnO+MoOx |
  | -------------- | --- | ---- | -------- |
  | Random |  | | |
  | Roulette wheel | | | |
  | Tournament | | | |
  | Breeder | [result](./ZnO%20optical%20spacer%20optimization%20files/RESULTS/Breeder_Accuracy_results.xlsx) | | |

* ZnO single layer optimization
  <p align="left">
  <img src="./assets/optim_zno.png" width="400" alt="ZnO single">
  </p>

  > Accuracy of 100%: all the 5000 runs converged to the optimal solution.

* MoOx single layer optimization
  <p align="left">
  <img src="./assets/optim_moox.png" width="400" alt="ZnO single">
  </p>

* ZnO+MoOx multi-layer optimization
  <p align="left">
  <img src="./assets/optim_zno_moox.png" width="400" alt="ZnO+MoOx">
  </p>


## Acknowledgement
Co-First Authors: [Premkumar Vincent](https://github.com/vinpremkumar) and [Gwenaelle Cunha Sergio](https://github.com/gcunhase) had equal contribution

Include citation once available
