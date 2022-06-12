#!/bin/bash
#
# Owner : LPauzies
# Email : lucas.pauzies@hotmail.fr

# Setup global variables for the installation
## Owner
owner=LPauzies
## Repos
db=home-network-monitoring-database
etl=home-network-monitoring-etl
api=home-network-monitoring-api
ui=home-network-monitoring-ui

clone_if_not_exists() {
    if [[ ! -d "$1" ]]
    then
        git clone https://github.com/$owner/$1.git
    else
        echo "Folder already exists. Aborted."
        exit
    fi
}

python_source_activate=.venv/Scripts/activate

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ];
then
    python_source_activate=.venv/bin/activate
fi

# Database part
clone_if_not_exists $db

# ETL part
clone_if_not_exists $etl
cd home-network-monitoring-etl
python -m venv .venv
source $python_source_activate
python -m pip install --upgrade pip
pip install -r requirements.txt
cd ..

# API part
clone_if_not_exists $api
cd home-network-monitoring-api
python -m venv .venv
source $python_source_activate
python -m pip install --upgrade pip
pip install -r requirements.txt
cd ..

# UI part
clone_if_not_exists $ui
cd home-network-monitoring-ui/ui
npm install --silent --no-optional
cd ../..

echo "Installation done."