function efmeas = networkMeasures(networks,groupVar1,groupVar2,rng1,rng2)
%% Network Measure Calculation
% Calculates efficiency measures from networks ove various regions provided
% and tests measures for significant differences. Current network
% measures are average nodal degree, channel range 1 and 2 average
% degrees, density, and range 1 and 2 rich club coefficients. Density and
% rich club coefficient calculation require BCT. 
%
% input size: neworks[N M M] double for N subjects with M by M channel matrices
%             groupVar1(N) char for 1st grouping variable
%             groupVar2(N) char for 2nd grouping variable
%             rng1(X) double for X chans in 1st area
%             rng2(Y) double for Y chans in 2nd area
%
% output size: [N by 6] for N subjects by 6 measures
%
% Author: Brian Carson
% 
% Please cite the following paper when utilizing this code:
%
% Zlebnik and Carson et al. "Motivational Impairment is accompanied by corticalstriatal dysfunction 
% in the BACHD-Tg5 rat model of Huntingtons Disease" (2018) (unpublished)

rtrsh=.01:.01:1;
warning('off','all')

nodes=1:size(networks,2);
for i=1:size(networks,1)
    for j=1 :100 
        data=squeeze(networks(i,:,:));
        data=data.*(ones(24,24)-diag(ones(1,24))); % removes self loops    
        data=data+data'; % undirected graph 
        data=(data-mean2(data(rng1,rng2)))/std2(data(rng1,rng2));  %z-scoring to connectivity
        data(data<rtrsh(j))=0; % thresholding      
        a=graph(data);
        % measures
        try
            rc=rich_club_wu(data,size(data,1)); % requires BCT
        catch
            rc=NaN;
        end
        try 
            dens=density_und(data); % requires BCT
        catch
            dens=NaN;
        end
        kdeg=degree(a); % inbuilt function
        % variable for averaging over threshold range
        mefmeas(j,1)=mean(kdeg);
        mefmeas(j,2)=dens;          
        mefmeas(j,3)=mean(rc(nodes<17),'omitnan'); % BCT
        mefmeas(j,4)=mean(rc(nodes>16),'omitnan'); % BCT
        mefmeas(j,5)=mean(kdeg(nodes<17));
        mefmeas(j,6)=mean(kdeg(nodes>16));

        for m=1:size(mefmeas,2) % remove bad values
            if(mefmeas(j,m)==Inf)
                mefmeas(j,m)=NaN;
            end
        end
    end
    efmeas(i,:)= mean(mefmeas,1,'omitnan');
end
measnames={'k '; 'dens '; 'rcNac '; 'rcPFC '; 'kNac ';'kPFC '};
%% Significance testing
alph=0.05;
ag='362';
for i=1:size(efmeas,2)
    try
        p=anovan(squeeze(real(efmeas(:,i))),{groupVar1';groupVar2'},'display','off');
    catch
        disp(['missing values for ' measnames{i} ', is BCT installed?'])
        p=1;
    end
    if ( p(1) < alph )
        disp([ 'find from ' measnames{i} ' with groupVar1 p=' num2str(p(1)) ' and groupVar2 p=' num2str(p(2))])
    end
end
end