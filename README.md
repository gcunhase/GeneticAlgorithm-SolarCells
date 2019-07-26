## About
**Genetic Algorithm** for efficient single and multi-layer **solar cell** thickness optimization

## Contents
[Requirements](#requirements) • [Solar Cell](#solar-cell-device-structure) • [How to Use](#how-to-use) • [Results](#results) • [Cite](#acknowledgement)

## Requirements
* Windows 7 or Ubuntu 18.04
* Matlab 2018b or 2019a
    * Toolboxes (Add-Ons > Get Add-Ons)
        * *de2bi* and *bi2de* functions:
            * Communication System Toolbox (Matlab 2018b)
            * Communications Toolbox (Matlab 2019a)
        * Parallel Computing Toolbox
        * Trading Toolbox
    * `cprintf.m` ([download link](https://www.mathworks.com/matlabcentral/fileexchange/24093-cprintf-display-formatted-colored-text-in-the-command-window))
* Lumerical, FDTD solutions software + license (you can get 1 month trial version from their website if you have an organization email)

## Solar cell device structure
ZnO and MoOx Optical Spacer
  <p align="left">
  <img hspace="20cm" src="./assets/solar_cell_device_structure.png" width="250" alt="Solar cell device structure">
  </p>

## How to Use
1. Set up solar cell model:
    * Solar cell FDTD file: [Evo_alg__P3HT-ICBA.fsp](./Evo_alg__P3HT-ICBA.fsp)
    * In the file that starts with `jsc_FDTD_...`, under the comment `%Load simulation file`, change the file directory to the directory you have saved the solar cell FDTD file in.
2. Run code with `Main_frontend_gui.m`:
    * Single layer ZnO: [`./'ZnO optical spacer optimization files'/ZnO_Main_frontend_gui.m`](./ZnO%20optical%20spacer%20optimization%20files/ZnO_Main_frontend_gui.m)
    * Single layer MoOx: [`./'MoOx optical spacer optimization files'/MoOx_Main_frontend_gui.m`](./MoOx%20optical%20spacer%20optimization%20files/MoOx_Main_frontend_gui.m)
    * Multiple layer: [`./'ZnO+MoOx optical spacer optimization files'/ZnO_and_MoOx_Main_frontend_gui.m`](./ZnO+MoOx%20optical%20spacer%20optimization%20files/ZnO_and_MoOx_Main_frontend_gui.m)
3. Choose how many runs of each selection method has to perform. Each section has a repeat counter of 1000 times. This was used for finding the average number of simulations required by the selection method. For real time usage, change the 'repeat_runs' variable value to 1 in the `.m` file that starts with `Evo_alg_...`

PS: If the user cannot obtain the Lumerical, FDTD solutions software license, you can still run the code using our in-built Jsc (fitness function) dictionary which was used for testing. To utilize this, set `testing = 2` in the `.m` file that starts with `Evo_alg_...`

## Results
Results are saved in Excel files, with number of sheets equivalent to the number of runs in each selection.

> Accuracy of 100%: all the 5000 runs converged to the optimal solution.

#### ZnO single layer optimization [[excel](./ZnO%20optical%20spacer%20optimization%20files/RESULTS)]
  <p align="left">
    <img src="./assets/optim_zno.png" height="200" alt="ZnO single" hspace="15cm">
    <img src="./assets/optim_zno_plot.png" height="200" alt="ZnO single plot">
  </p>

#### MoOx single layer optimization [[excel](./MoOx%20optical%20spacer%20optimization%20files/RESULTS)]
  <p align="left">
    <img src="./assets/optim_moox.png" height="200" alt="MoOx single" hspace="15cm">
    <img src="./assets/optim_moox_plot.png" height="200" alt="MoOx single plot" hspace="15cm">
  </p>

#### ZnO+MoOx multi-layer optimization [[excel](./ZnO+MoOx%20optical%20spacer%20optimization%20files/RESULTS)]
  <p align="left">
    <img src="./assets/optim_zno_moox.png" height="200" alt="ZnO+MoOx" hspace="15cm">
    <img src="./assets/optim_zno_moox_plot.png" height="200" alt="ZnO+MoOx" hspace="15cm">
  </p>

## Acknowledgement
Co-First Authors: [Premkumar Vincent](https://github.com/vinpremkumar) and [Gwenaelle Cunha Sergio](https://github.com/gcunhase) had equal contribution

Include citation once available
