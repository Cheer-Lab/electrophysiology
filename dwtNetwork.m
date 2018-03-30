function mdwtcr = dwtNetwork ( y )
    %% Discrete Wavelet Networks 
    % Takes in a trial of signals and outputs square correlation matrices
    % from each comparison between pairs of channels over frequency levels.
    % Wavelet decompositions are temporally corrected to align any
    % events that may become shifted to to the wavelet based filtering.
    %
    % Inputs:
    %   y - N signals by M timepoints trial of signals 
    % Outputs:
    %   mdwtcr - N signals by N signals by M levels correlation matrices
    %
    % Author: Brian Carson
    %
    % Change Log:
    % 3/2018: Written by Brian Carson
    % 
    % Please cite the following paper when utilizing this code:
    % Zlebnik and Carson et al. "Motivational Impairment is accompanied by corticalstriatal dysfunction 
    % in the BACHD-Tg5 rat model of Huntingtons Disease" (2018) (unpublished)
    
    for i = 1:size(y,1)
        mdwt(i,:,:) = modwt(y);
        mdwt(i,:,:) = mdwtmra(squeeze(mdwt(i,:,:)));
    end
    
    for n = 1:size(y,1)
        for m = 1:size(y,1)
            mdwtcr(n,m,:)=modwtcorr(squeeze(mdwt(n,:,:)),squeeze(mdwt(m,:,:)));
        end
    end
end