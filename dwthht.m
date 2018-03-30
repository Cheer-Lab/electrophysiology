function sig=dwthht(x)
    %% Combination Decomposition Filtering via DWT and EMD
    % First tests the original signal to determine whether filtering is
    % necessary, then proceeds through the filtering process if need be.
    % Filter removes 60Hz noise from signals by decomposing the waveform into
    % discrete wavelet levels, and then selects levels for further
    % decomposition into intrinsic mode functions. Finally the intrinsic
    % mode functions with 60Hz noise are then filtered using a zero phase
    % IIR butterworth filter. 
    % 
    % Inputs: 
    %    x - signal
    % Outputs:
    %    sig - filtered waveform
    %
    % Author: Brian Carson (bpcarson1 AT gmail.com)
    %
    % Change Log:
    % 3/2018: Added test for 60Hz outlier by Brian Carson
    % 
    % Please cite the following paper when utilizing this code:
    % Zlebnik and Carson et al. "Motivational Impairment is accompanied by corticalstriatal dysfunction 
    % in the BACHD-Tg5 rat model of Huntingtons Disease" (2018) (unpublished)

    [pxx,f]=pwelch(x,[],[],1:100,1000);
    indx=find(f==60);
    test=isoutlier(pxx,'movmedian',8); 
    if ~test(indx)
        sig=x;
        return
    end
    
    bs60 = designfilt('bandstopiir','FilterOrder',20, ...
             'HalfPowerFrequency1',59.5,'HalfPowerFrequency2',60.5, ...
             'SampleRate',1000,'DesignMethod','butter');
    xmdwt=modwt(x); % decompose signal via discrete wavelet
    x60=xmdwt(4,:); % ~60hz level waveelet coefficients
    x60dec=eemd(x60,.1,8); % decompose level 4/60hz wavelet via HHT
    x60dec(:,1)=filtfilt(bs60,x60dec(:,1)); % filtering noisy IMFs 1-3 w/ 60hz notch
    x60dec(:,2)=filtfilt(bs60,x60dec(:,2));
    x60dec(:,3)=filtfilt(bs60,x60dec(:,3));
    xmdwt(4,:)=sum(x60dec,2).*.5 ; % filtered IMFs sum to new level 4 modwt
    sig=imodwt(xmdwt); % invert wavelet coefs to recover cleaned signal
end