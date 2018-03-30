function [zmapUn, zmapClu, zmapPix,diffmap]=permTest(data1,data2,alpha)
%% PermTest
% Computes Significant differences over data using premutation based
% statistics. Correction is done using cluster correction as well as max
% value pixel based correction. If data sizes are not the same then the
% last subject of the larger dataset is removed to allow for even
% permutation based statistics. Further improvements would involve
% adjusting this for a different replacement such as a mean of a
% group or repetition of the median subject.
%
% Inputs:
%     data1 - (N,M,Z) - N x M variables over Z trials/subjects
%     data2 - same format as data1, N x M must be the same size, but the
%     Z may change to be either larger or smaller than data1
% Outputs:
%     zmapUn - uncorrected pvals
%     zmapClu - cluster corrected data
%     zmapPix - pixel corrected data
%     diffmap - difference of data 
%
% Change Log:
% 3/2018: Adapted by Brian Carson (bpcarson1 AT gmail.com) from material
% by MX Cohen, changed for use as a function with arbitrarily sized data
% and uneven groups. 
%
% Please cite the following papers when utilizing this code:
%
% Zlebnik and Carson et al. "Motivational Impairment is accompanied by corticalstriatal dysfunction 
% in the BACHD-Tg5 rat model of Huntingtons Disease" (2018) (unpublished)
%
% Cohen MX: Non-parametric permutation testing. 
% Analyzing Neural Time Series Data: Theory and Practice. MIT Press,
% Cambridge, MA.

if size(data1,3)>size(data2,3)
    data1=data1(:,:,1:size(data2,3));
end
data2=data2(:,:,1:size(data1,3));

ntrials=size(data1,3);

tf(1,:,:,:) = data1;
tf(2,:,:,:) = data2;
diffmap = squeeze(mean(tf(2,:,:,:),4 )) - squeeze(mean(tf(1,:,:,:),4 ));
%% statistics via permutation testing
% p-value
pval = alpha;

% convert p-value to Z value
zval = abs(norminv(pval));

% number of permutations
n_permutes = 1000;

% initialize null hypothesis maps
permmaps = zeros(n_permutes,size(tf,2),size(tf,3));

% for convenience, tf power maps are concatenated
%   in this matrix, trials 1:ntrials are from channel "1" 
%   and trials ntrials+1:end are from channel "2"
tf3d = cat(3,squeeze(tf(1,:,:,:)),squeeze(tf(2,:,:,:)));

% generate maps under the null hypothesis
for permi = 1:n_permutes
    
    % randomize trials, which also randomly assigns trials to channels
    randorder = randperm(size(tf3d,3));
    temp_tf3d = tf3d(:,:,randorder);
    
    % compute the "difference" map
    % what is the difference under the null hypothesis?
    permmaps(permi,:,:) = squeeze( mean(temp_tf3d(:,:,1:ntrials),3) - mean(temp_tf3d(:,:,ntrials+1:end),3) );
end
%% non-corrected thresholded maps
% compute mean and standard deviation maps
mean_h0 = squeeze(mean(permmaps));
std_h0  = squeeze(std(permmaps));

% now threshold real data...
% first Z-score
zmap = (diffmap-mean_h0) ./ std_h0;

% threshold image at p-value, by setting subthreshold values to 0
zmap(abs(zmap)<zval) = 0;
zmap(isnan(zmap))=0;

zmapUn=zmap;
%% corrections for multiple comparisons
% initialize matrices for cluster-based correction
max_cluster_sizes = zeros(1,n_permutes);
% ... and for maximum-pixel based correction
max_val = zeros(n_permutes,2); % "2" for min/max

% loop through permutations
for permi = 1:n_permutes
    
    % take each permutation map, and transform to Z
    threshimg = squeeze(permmaps(permi,:,:));
    threshimg = (threshimg-mean_h0)./std_h0;
    
    % threshold image at p-value
    threshimg(abs(threshimg)<zval) = 0;
    
    % find clusters (need image processing toolbox for this!)
    islands = bwconncomp(threshimg);
    if numel(islands.PixelIdxList)>0
        
        % count sizes of clusters
        tempclustsizes = cellfun(@length,islands.PixelIdxList);
        
        % store size of biggest cluster
        max_cluster_sizes(permi) = max(tempclustsizes);
    end
    
    % get extreme values (smallest and largest)
    temp = sort( reshape(permmaps(permi,:,:),1,[] ));
    max_val(permi,:) = [ min(temp) max(temp) ];
    
end
%%
% find cluster threshold (need image processing toolbox for this!)
% based on p-value and null hypothesis distribution
cluster_thresh = prctile(max_cluster_sizes,100-(100*pval));

%% multiple comparisons corrections
% now find clusters in the real thresholded zmap
% if they are "too small" set them to zero
islands = bwconncomp(zmap);
for i=1:islands.NumObjects
    % if real clusters are too small, remove them by setting to zero!
    if numel(islands.PixelIdxList{i}==i)<cluster_thresh
        zmap(islands.PixelIdxList{i})=0;
    end
end

zmapClu=zmap;
%% now with max-pixel-based thresholding
% find the threshold for lower and upper values
thresh_lo = prctile(max_val(:,1),100-100*pval); % what is the
thresh_hi = prctile(max_val(:,2),100-100*pval); % true p-value?

% threshold real data
zmap = diffmap;
zmap(zmap>thresh_lo & zmap<thresh_hi) = 0;
zmapPix=zmap;
end