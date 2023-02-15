function plot_from_saved_with_data(filename,sub)
if ~exist('sub','var')
	figure
	set(gcf,'outerposition',[272    79   550   700])
	for i=1:9
		sub(i)=subplot(3,3,i);
	end
end

VENUS_histograms_timecourse(sub(4:6))

S=load(filename);
cellFiles=S.cellFiles;
rootCellFile7=S.rootCellFile7;
rootCellFile15=S.rootCellFile15;
rootCellFile21=S.rootCellFile21;

h_ON7=[];h_ON15=[];h_ON21=[];
h_Protein7=[];h_Protein15=[];h_Protein21=[];
for k=1:cellFiles
	% Cells 1-4 are ignored (estimate these are not included in imaging)
	h_ON7=[h_ON7; rootCellFile7{k}.CellON(5:end)];
	h_ON15=[h_ON15; rootCellFile15{k}.CellON(5:end)];
	h_ON21=[h_ON21; rootCellFile21{k}.CellON(5:end)];
	
	h_Protein7=[h_Protein7; rootCellFile7{k}.Protein(5:end)];
	h_Protein15=[h_Protein15; rootCellFile15{k}.Protein(5:end)];
	h_Protein21=[h_Protein21; rootCellFile21{k}.Protein(5:end)];
end
h={2*h_ON7;2*h_ON15;2*h_ON21;h_Protein7;h_Protein15;h_Protein21};


binVenus=0.2;
xlim1Venus=-1;
xlim2Venus=10;
for i=1:6
	subplot(sub(i))
	
	if i<4
		m=-0.3:0.2:2.3;
	else
		m=xlim1Venus:binVenus:xlim2Venus;
		if max(h{i})>xlim2Venus
			max(h{i})
		end
	end	
	[histData]=histcounts(h{i},m);
	x=[m;m];x=x(2:end-1);
	y=100*[histData/length(h{i});histData/length(h{i})];y=y(:)';
	area=fill(x,y,[0 0 0.5]);
	set(area,'facecolor','none','edgecolor','k','LineWidth',2)
	hold on
    plot([mean(h{i}) mean(h{i})],[0 100],'--','color',[0.3,0.75,0.93],'LineWidth',2)
    plot([median(h{i}) median(h{i})],[0 100],'--','color',[255,102,51]/255,'LineWidth',2)
    text(1,65,num2str(mean(h{i}),2),'color',[0.3,0.75,0.93])
	text(1,35,num2str(median(h{i}),2),'color',[255,102,51]/255)
	if i==7
		ylabel('% Counts')
	end
	ylim([0 100])
	set(gca,'ytick',[0 50 100],'LineWidth',1)
	xlim([m(1) m(end)])
	if i<4
		xlabel('ON/OFF')
	else
		xlabel('Intensity per cell')
		xlim([-0.2 1.5])
	end
	
	if mod(i,3)==1
		title('7')
	elseif mod(i,3)==2
		title('15')
	else
		title('21')
	end
end

