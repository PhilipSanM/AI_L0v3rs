On Anaconda terminal just run the commands

```
conda create --prefix ./env pandas numpy matplotlib scikit-learn

```

```
conda activate ./env

```

```
conda install jupyter

```

```
jupyter notebook

```

---

For sharing .yml file:

```
conda env export --prefix ./env > environment.yml

```

And for running:

```
conda env create --file environment.yml --name env_from_ymlfile

```
