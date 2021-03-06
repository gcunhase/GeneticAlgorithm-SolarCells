
<div align="center"> 

[![Paper](https://img.shields.io/badge/Energies-2020-red.svg)](https://www.mdpi.com/1996-1073/13/7/1726)
[![Paper](https://img.shields.io/badge/arxiv-1909.06447-red.svg)](https://arxiv.org/abs/1909.06447)
[![Conference](https://img.shields.io/badge/NUSOD-2019-blue.svg)](https://www.nusod.org/2019/nusod19paper45.pdf)

</div>

## About
Repository for paper titled [*"Application of Genetic Algorithm for More Efficient Multi-layer Thickness Optimization in Solar Cells"*](https://www.mdpi.com/1996-1073/13/7/1726).

  <p align="center">
  <img src="./assets/graphical_abstract.jpg" height="200" alt="Graphical Abstract">
  </p>

## Contents
[Requirements](#requirements) • [How to Use](#how-to-use) • [Results](#results) • [How to Cite](#acknowledgment)

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

## How to Use
1. Set up solar cell model
    * With FDTD software
       * Solar cell FDTD file: [Evo_alg__P3HT-ICBA.fsp](./Evo_alg__P3HT-ICBA.fsp)
       * In the file that starts with `jsc_FDTD_...`, under the comment `%Load simulation file`, change the file directory to the directory you have saved the solar cell FDTD file in.
    * Without FDTD software (for testing)
       * Use in-built Jsc (fitness function) dictionary by setting `testing = 2` in the `.m` file that starts with `Evo_alg_...`
2. Run code with `Main_frontend_gui.m`
    * Single layer ZnO: [`./'ZnO optical spacer optimization files'/ZnO_Main_frontend_gui.m`](./ZnO%20optical%20spacer%20optimization%20files/ZnO_Main_frontend_gui.m)
    * Single layer MoOx: [`./'MoOx optical spacer optimization files'/MoOx_Main_frontend_gui.m`](./MoOx%20optical%20spacer%20optimization%20files/MoOx_Main_frontend_gui.m)
    * Multiple layer: [`./'ZnO+MoOx optical spacer optimization files'/ZnO_and_MoOx_Main_frontend_gui.m`](./ZnO+MoOx%20optical%20spacer%20optimization%20files/ZnO_and_MoOx_Main_frontend_gui.m)
3. Choose how many runs of each selection method has to perform
    * Each section has a repeat counter of 1000 times, used in order to find the average number of simulations required by the selection method.
    * For real time usage, change the 'repeat_runs' variable value to 1 in the `.m` file that starts with `Evo_alg_...`

## Results
* Results are saved in Excel files, with number of sheets equivalent to the number of runs in each selection.
* Obtain performance graph: [evaluation scripts](./evaluation)
   > Accuracy of 100% (meaning): all the 5000 runs converged to the optimal solution.

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

#### Crossover methods: Uniform vs *k*-point
  <p align="left">
    <img src="./assets/crossover_comparisons.png" height="150" alt="Crossover methods">
  </p>

## Acknowledgment
Co-First Authors: [Premkumar Vincent](https://github.com/vinpremkumar) and [Gwenaelle Cunha Sergio](https://github.com/gcunhase) had equal contribution

```
@article{VincentAndCunha2020GASolarCell,
   title={Application of Genetic Algorithm for More Efficient Multi-layer Thickness Optimization in Solar Cells},
   author={{Vincent, P. and Sergio, G. C.} and Jaewon Jang and In Man Kang and Jaehoon Park and Hyeok Kim and Minho Lee and Jin-Hyuk Bae},
   year={2020},
   journal={Energies},
   volume={13},
   issue={7},
   pages={1--14},
   article-number={1726},
   DOI={10.3390/en13071726},
   ISSN={1996-1073},
}
```

Contact: `2014600014@knu.ac.kr` and `gwena.cs@gmail.com`
