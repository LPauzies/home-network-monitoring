#!/bin/bash

# Setup global variables for the installation

python_source_activate=.venv/Scripts/activate

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ];
then
    python_source_activate=.venv/bin/activate
fi

# Assuming we are launching this app from our work folder.
# We will launch this script as sudo of pythonping library use.

# 1) Setup the database
cd home-network-monitoring-database
python database_initialization.py

cd ..

# 2) Launch ETL
cd home-network-monitoring-etl
source $python_source_activate
python etl.py >/dev/null 2>etl.log &

pid_etl=$!

cd ..

# 3) Launch API
cd home-network-monitoring-api
source $python_source_activate
uvicorn api:app --reload >/dev/null 2>api.log &

pid_api=$!

cd ..

# 4) Launch frontend
cd home-network-monitoring-ui/ui
ng serve --open >/dev/null 2>ui.log &

pid_ui=$!

cd ../..

trap exit_process SIGINT
exit_process() {
    kill -9 $pid_api $pid_etl $pid_ui &>/dev/null
    exit
}

echo "
██╗  ██╗ ██████╗ ███╗   ███╗███████╗    ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗    ███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
██║  ██║██╔═══██╗████╗ ████║██╔════╝    ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝    ████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗██║████╗  ██║██╔════╝ 
███████║██║   ██║██╔████╔██║█████╗      ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝     ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝██║██╔██╗ ██║██║  ███╗
██╔══██║██║   ██║██║╚██╔╝██║██╔══╝      ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗     ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗██║██║╚██╗██║██║   ██║
██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗    ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║██║██║ ╚████║╚██████╔╝
╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
"
echo "Dashboard will be opened in a few seconds..."
echo "Press Ctrl + C to stop the application..."

while true
do
    sleep 1
done