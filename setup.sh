#!/bin/bash

# Install Miniforge
# in /home/miniforge3/
# When asked if you want to add Miniforge to the PATH, select "No" to avoid conflicts with Anaconda

echo "Installing Miniforge..."
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -p $HOME/miniforge3

# Activate Miniforge
echo "Activating Miniforge..."
conda deactivate
source $HOME/miniforge3/bin/activate

# Install Mamba
echo "Installing Mamba..."
conda install -n base -c conda-forge mamba -y

# Create the RGI environment
echo "Creating the RGI environment..."
mamba create -n rgi -c bioconda -c conda-forge rgi -y

# Activate the RGI environment
echo "Activating the RGI environment..."
conda activate rgi

# Load the RGI database
echo "Loading the RGI database..."
rgi auto_load

echo "Installation complete!"