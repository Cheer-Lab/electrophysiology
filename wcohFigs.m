%imagesc(squeeze(mean(owcoh(type=='W' & ages=='3',:,:))))
tp={'Wt';'Tg5'};
agrp={' 3'; ' 6'; '12'};
time=-5.001:10/2500:5;
fre=log2(wcohf(wcohf<120 & wcohf>.5));
for i=1:2
    for j=1:3
        figure
        imagesc(time,fre,squeeze(mean(owcoh(type==tp{i}(1) & ages==agrp{j}(2),wcohf<120 & wcohf>.5,:))))
        ax = gca;
        ytick = str2double(ax.YTickLabel);
        ax.YTickLabel = num2str(2.^ytick);
        set(gca, 'Ydir','normal')
        title(['WC ' tp{i} ' ' agrp{j} 'mo'])
        xlabel('Time(s)')
        ylabel('Frequency(Hz)')
        caxis([0.45 .65])
        axis xy
    end
end