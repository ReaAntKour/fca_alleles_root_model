function sub=draw_roots_state_and_Protein(rootCellFile7,rootCellFile15,rootCellFile21)
figure
set(gcf,'outerposition',[100 40 630 1040])
sub(1)=subplot(2,3,1);
sub(2)=subplot(2,3,4);
sub(3)=subplot(2,3,2);
sub(4)=subplot(2,3,5);
sub(5)=subplot(2,3,3);
sub(6)=subplot(2,3,6);
linkaxes(sub)

timepoints=[7 15 21];
maxProtein=0;
rootCellFiles={rootCellFile7,rootCellFile15,rootCellFile21};
for timepoint=1:3
	rootCellFile=rootCellFiles{timepoint};
	cellFiles=length(rootCellFile);

	for k=1:cellFiles
		maxProtein=max([maxProtein;rootCellFile{k}.Protein]);
	end
end
for timepoint=1:3
	rootCellFile=rootCellFiles{timepoint};
	for k=1:cellFiles
		cellFileLength=height(rootCellFile{k});
		
		subplot(sub(2*timepoint-1))
		rootStructure=nan(cellFileLength,1);
		currentPosition=0;
		for i=1:cellFileLength
			rootStructure(i)=fill([k+1 k+1 k k],[currentPosition currentPosition+1 currentPosition+1 currentPosition],[rootCellFile{k}.CellON(i),rootCellFile{k}.CellON(i),0],'edgecolor','r');
			if i==1
				hold on
			end
			currentPosition=currentPosition+1;
		end

		subplot(sub(2*timepoint))
		ProotStructure=nan(cellFileLength,1);
		currentPosition=0;
		for i=1:cellFileLength
			if rootCellFile{k}.Protein(i)<=(maxProtein/2)
				ProotStructure(i)=fill([k+1 k+1 k k],[currentPosition currentPosition+1 currentPosition+1 currentPosition],[rootCellFile{k}.Protein(i)/(maxProtein/2),rootCellFile{k}.Protein(i)/(maxProtein/2),0],'edgecolor','r');
			elseif rootCellFile{k}.Protein(i)<=maxProtein
				ProotStructure(i)=fill([k+1 k+1 k k],[currentPosition currentPosition+1 currentPosition+1 currentPosition],[1,1,rootCellFile{k}.Protein(i)/(maxProtein/2)-1],'edgecolor','r');
			else
				ProotStructure(i)=fill([k+1 k+1 k k],[currentPosition currentPosition+1 currentPosition+1 currentPosition],[0,1,1],'edgecolor','r');
			end
			if i==1
				hold on
			end
			currentPosition=currentPosition+1;
		end
	end
	title([int2str(timepoints(timepoint)),' days after sowing'])
end

for i=1:6
	subplot(sub(i))
	hold off
	xlim([-2 cellFiles+4])
	ylim([-cellFileLength/20 cellFileLength])
	set(gca,'ytick',[])
	set(gca,'xtick',[])
% 	if mod(i,2)==0
% 		title('Protein')
% 	else
% 		title('ON/OFF')
% 	end
end

%% colourbars
k=0;
sub(7)=axes;
set(sub(7),'position',[0.93,0.8,0.05,0.1])
sub(8)=axes;
set(sub(8),'position',[0.93,0.3,0.05,0.1])

subplot(sub(7))
CellON=[0,0.5,1];
for i=1:3
	fill([k+1 k+1 k k],[CellON(i)-0.25 CellON(i)+0.25 CellON(i)+0.25 CellON(i)-0.25],[CellON(i),CellON(i),0],'edgecolor','none');
	hold on
end
ylim([-0.25 1.25])
set(gca,'xtick',[])

subplot(sub(8))
Protein=0:0.2:maxProtein;
for i=1:length(Protein)
	if Protein(i)<=(maxProtein/2)
		fill([k+1 k+1 k k],[Protein(i)-0.1 Protein(i)+0.1 Protein(i)+0.1 Protein(i)-0.1],[Protein(i)/(maxProtein/2),Protein(i)/(maxProtein/2),0],'edgecolor','none');
	elseif Protein(i)<=maxProtein
		fill([k+1 k+1 k k],[Protein(i)-0.1 Protein(i)+0.1 Protein(i)+0.1 Protein(i)-0.1],[1,1,Protein(i)/(maxProtein/2)-1],'edgecolor','none');
	else
		fill([k+1 k+1 k k],[Protein(i)-0.1 Protein(i)+0.1 Protein(i)+0.1 Protein(i)-0.1],[0,1,1],'edgecolor','none');
	end
	hold on
end
ylim([-0.1 maxProtein-0.1])
set(gca,'xtick',[])