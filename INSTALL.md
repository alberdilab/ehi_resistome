# Installation Instructions

## Step 1: Install Miniforge
Download and install Miniforge:
```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh
```
When prompted, select "No" to avoid adding Miniforge to the PATH automatically.

## Step 2: Activate Miniforge
Disable Anaconda manually
```bash
conda deactivate
```

Activate Miniforge manually:
```bash
source ~/miniforge3/bin/activate
```

If you want reactivate Anaconda
*conda deactivate*
*source ~/anaconda3/bin/activate*

## Step 3: Install Mamba
Install Mamba using Conda:
```bash
conda install -n base -c conda-forge mamba
```

Verify the installation:
```bash
which mamba # the path: /home/miniforge3/bin/mamba
```

## Step 4: Create and Activate the RGI Environment
Create a new environment with RGI
```bash
mamba create -n rgi -c bioconda -c conda-forge rgi
```

Activate the environment
```bash
conda activate rgi
rgi --help
```

## Step 5: Load the RGI Database
Load the RGI database:
```bash
rgi auto_load
```

Check database
```bash
rgi database --version
```
## To avoid all this steps run the **setup.sh** file in bash


## Step 6: create the directories

Move the Snakefile.smk and the script_config.yaml to a directory named "my_proyect"
Save the file config.yaml in a directory named profiles relative to your workflow directory
Create the following directories

/my_proyect/
│── data/
│   │── sample1_R1.fastq.gz
│   │── sample1_R2.fastq.gz
│   │── ...
│── Snakefile.smk
│── script_config.yaml
│── profiles/
│   ├── config.yaml
│── rgi_results/
│── logs/
│   │── rgi/
│── others_files...


## Step 7: Run the workflow
Run the workflow with snakemake and slurm
```bash
snakemake --snakefile Snakefile.smk --workflow-profile profiles
```