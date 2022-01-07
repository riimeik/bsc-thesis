# Building and evaluating models from methylation coverage reports

## Prerequisites

* Coverage reports (from the preprocessing step) in the folder `../meth`
* [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
* [Jupyter](https://jupyter.org/install)
* Data files not included in this repository:
  * `../data_mes_IGAIGN_combined.xlsx`
  * `../data_mes_IGAEDUIGN_combined.xlsx`
  * `../M06_2019-04-23_200GD_Esimene_ajapunkt_1.0_KMe.xlsx`

The environment can be re-created from the file at `environment.yml`:

```bash
conda env create -f ./environment.yml
```

## Preprocessing

The notebook at `./preprocessing.ipynb` includes the steps for processing, aggregating and filtering individual coverage reports. The outputs are merged methylation and coverage reports, both before and after filtering.

## Imputation

The next step is imputation, which is covered in the notebook at `./imputation.ipynb`. Three methods are explored - IterativeImputer (MICE), MissForest and IterativeImputer with RandomForestRegressor. The outputs are pickled imputed datasets.

## Analysis and modeling

The notebook at `./modeling.ipynb` generates some figures on the data and builds a model evaluation pipeline using nested cross-validation. The methods evaluated are linear regression, regularized regressions (Huber, LASSO, ridge and ElasticNet), SVM, and RandomForest. For each method, the inner folds are used for hyperparameter tuning, while in the outer folds, various performance metrics are calculated (RMSE, MAE, R). Prior to being fed into the pipeline, each label (dependent variable) is normalized according to the most suitable normalizing function (e.g. square root), which is determined using the Shapiro-Wilk test.
