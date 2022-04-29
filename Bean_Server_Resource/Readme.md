|Name|
|----|
|Christopher Johnston|

#The Bean Model Page

This server contains one resource and html pages covering what the model was and how it was made. The model is a bean type predictor which cna predict between a Barbunya, Cali, Dermason, horoz, Seker and a Sira bean. The model takes in 15 features: perimerter. shapefactor 1 2 3 and 4, compactness, roundness, area, equivdiameter, solidity, minoraxislength, aspectration, eccentricity, extent, adn convexarea. 

##SRC
This directory contains most of the functions (not server.py) that activate the html pages and work on data in the backgorund.

##Templates
This is where all the html files are stored.

##static
All the pictures used and the css files are stored in this directory.

##Master.yml
In order to establish a restfull server, a yml was used to organize each endpoint in one place. this reduces complexity and significantly helps with readability.

##docker/make
These two files get the container to run. This docker being built is using ubuntu because.... because why not? It is for education perposes and personally it was interesting. Don't come at me if my webpage brings you horror memories of dialup. Patience is key to a good life.

##Resources
This is where the model is stored. 

##requirments.py
All the modules needed for this were stored in this file. Sklearn was not really needed for the end result, but it was left in due to laziness. I mean it would take less time to delete it rather than typing this, but I digress. 

##server.py
This file is very important. It is needed to run the entire server so it could be consiedered the heart. 
