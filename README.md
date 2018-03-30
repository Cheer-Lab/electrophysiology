# Ephys
Files used in various analyses of electrophysiological data. 


# Local Field Potentials

Many LFP analyses include elements that delve into frequency or time-frequency content of signals, acquired from a multitude of methods, such as the Thomson Multitaper PSD, Continuous Wavelet Transform, and Wavelet Coherence among others. Below is an example of time frequency content of a local field potential derived using the continuous wavelet transform. 

![Continuous Wavelet Transform](https://github.com/Cheer-Lab/Ephys/blob/master/cwtEx.PNG)

An interesting element of local field potentials is their relation to each other, often referred to as connectivity. This can be calculated from Granger Causality, Wavelet Coherence, Multiscale Discrete Wavelet Correlation, among many other methods. A common way to summarize this imformation is within adjacency matrices. These matrices can then be thresholded to show important functional and structural differences within networks. Shown below is an example adjacency matrix and resulting network graph.

![](https://github.com/Cheer-Lab/Ephys/blob/master/adjEx.PNG) ![](https://github.com/Cheer-Lab/Ephys/blob/master/networkEx.PNG)

# Spikes

For spikes, an important step before beginning any analysis is sorting the spikes into distinct cells. This can be done in a variety of ways. Included here are methods utilizing a k-means algorithm, as well as a multisignal discrete wavelet transform clustering method. A couple examples of cells from these methods are shown below. Followed by the average cells detected on a single wire. These detections still need to be cleaned further, which can be done in a variety of ways, such as best fit from regression, signal to noise ratio, or removing outliers. 

![](https://github.com/Cheer-Lab/Ephys/blob/master/spkClustEx.PNG) ![](https://github.com/Cheer-Lab/Ephys/blob/master/spkClustEx2.PNG)

![](https://github.com/Cheer-Lab/Ephys/blob/master/spkAvgCells.PNG)

Comparing results to human labeled data shows that the methods find cells with similar results to that of human operators. The main source of error would likely be the splitting of a single cell into two cells. Below are the results of the human labeled data, followed by the multisignal discrete wavelet transform clustering. These spikes were projected onto a 2-D plane using t-Distributed Stochastic Neighbor Embedding, or t-SNE for short. 

![](https://github.com/Cheer-Lab/Ephys/blob/master/tsnePlxClustEx.PNG)

![](https://github.com/Cheer-Lab/Ephys/blob/master/tsneMdwtClustEx.PNG)
 
