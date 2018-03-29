# Ephys
Files used in various analyses of electrophysiological data. Many include elements that delve into frequency or time-frequency content of signals, acquired from a multitude of methods, such as the Thomson Multitaper PSD, Continuous Wavelet Transform, and Wavelet Coherence among others.

![Continuous Wavelet Transform](https://github.com/Cheer-Lab/Ephys/blob/master/cwtEx.PNG)

Above is an example of time frequency content of a local field potential derived using the continuous wavelet transform. 

For spikes, an important step before beginning any analysis is sorting the spikes into distinct cells. This can be done in a variety of ways. Included here are methods utilizing a k-means algorithm, as well as a multisignal discrete wavelet transform clustering method. A couple examples of cells from these methods are shown below. Followed by the average cells detected on a single wire. 

![](https://github.com/Cheer-Lab/Ephys/blob/master/spkClustEx.PNG) ![](https://github.com/Cheer-Lab/Ephys/blob/master/spkClustEx2.PNG)

![](https://github.com/Cheer-Lab/Ephys/blob/master/spkAvgCells.PNG)

Comparing results to human labeled data shows that the methods find cells with similar results to that of human operators. The main source of error would likely be the splitting of a single cell into two cells. Below are results from clustering the human labeled data, followed by the multisignal discrete wavelet transform clustering. 

![](https://github.com/Cheer-Lab/Ephys/blob/master/tsnePlxClustEx.PNG)

![](https://github.com/Cheer-Lab/Ephys/blob/master/tsneMdwtClustEx.PNG)
