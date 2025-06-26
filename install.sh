#!/bin/bash

# cd back into the workspace
cd .. 

# create directories necessary for training
mkdir ./data


mkdir ./weights

cd data
wget https://portal.conp.ca/data/calgary-campinas_version-1.0.tar.gz


cd ..
git clone https://github.com/NKI-AI/direct.git
cd direct
