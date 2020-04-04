## Evaluation

### 1. Obtain results Excel file (*.xlsx*)
> Example for **ZnO**
* Run: `ZnO_Main_frontend_gui.m`
* Output: Excel file (*.xlsx*`) containing "Accuracy", "Mean number of simulations", and "Standard Deviation of the mean".

### 2. Plot performance graph
* Re-format Excel file:
    * Add 3 additional columns: A (Population count), B (Generation count), C (Mutation rate).
    * Accuracy, Mean number of simulation, and Standard Deviation should be on columns E, F, and G. The first data should be from row 3.
    * **Note**: This has already been done in the provided Excel files.
* Run: `evaluation/roulette_graphing_code.m`
