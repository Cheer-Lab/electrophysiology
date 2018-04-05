function [owcoh,wcohf] =wcohGrps(dataset,j1,j2)
%% Wavelet Coherence for groups
% Calculates wavelet coherence for dataset variable.  Generally, every 
% possible combination is not used due to the required memory and time. 
%
% inputs: dataset: struct of N entries with field 'trial' containing a cell
% array of size M channels by T timepoints.
%         j1: first channel range
%         j2: second channel range
%
% outputs: owcoh: N by X frequencies by Y timepoints of individual overall
% coherence
%          wcohf: X frequency values
%
% Author: Brian Carson
%
%
% Please cite the following paper when utilizing this code:
% Zlebnik and Carson et al. "Motivational Impairment is accompanied by corticalstriatal dysfunction 
% in the BACHD-Tg5 rat model of Huntingtons Disease" (2018) (unpublished)
% 
% ex: j1= [2 3 6 7 10 11 14 15]; % chan rng1
%     j2= [17 18 19 20 21 22 23 24]; % chan rng2
%     [coh,freq]=wcohGrps(dataset,j1,j2)

lfpeventwcoh=[];
for i=1:size(dataset,2)
    evs=size(dataset(i).trial,2);
    for m=1:length(j1)
        for k=1:evs
            wcoh=wcoherence(dataset(i).trial{k}(j1(m),:) ,dataset(i).trial{k}(j2(m),:),1000);
            lfpeventwcoh(m,k,:,:)=wcoh;   % individual wcoh for chans and events
        end
    end
    owcoh(i,:,:)=imresize(squeeze(mean(mean(lfpeventwcoh))),[145 250]); % change to improve temporal resolution
end
% get frequencies
[~,~,wcohf]=wcoherence(dataset(i).trial{k}(j1(m),:) ,dataset(i).trial{k}(j2(m),:),1000);
end
