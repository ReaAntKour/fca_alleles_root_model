function sub=draw_roots_state_and_Protein(rootCellFile7,rootCellFile15,rootCellFile21)
figure
set(gcf,'outerposition',[100 40 630 1040])
sub(1)=axes;
set(sub(1),'position',[0.1,0.52,0.22,0.4])
sub(2)=axes;
set(sub(2),'position',[0.1,0.1,0.22,0.4])
sub(3)=axes;
set(sub(3),'position',[0.4,0.52,0.22,0.4])
sub(4)=axes;
set(sub(4),'position',[0.4,0.1,0.22,0.4])
sub(5)=axes;
set(sub(5),'position',[0.7,0.52,0.22,0.4])
sub(6)=axes;
set(sub(6),'position',[0.7,0.1,0.22,0.4])
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
maxWhite=1.5;

for timepoint=1:3
	rootCellFile=rootCellFiles{timepoint};
	for k=1:cellFiles
		cellFileLength=height(rootCellFile{k});
		
		subplot(sub(2*timepoint-1))
		rootStructure=nan(cellFileLength,1);
		currentPosition=0;
		for i=1:cellFileLength
			rootStructure(i)=fill([k+1 k+1 k k],[currentPosition currentPosition+1 currentPosition+1 currentPosition],[rootCellFile{k}.CellON(i)*2/3+(rootCellFile{k}.CellON(i)==1)*1/3,rootCellFile{k}.CellON(i)*2/3,(rootCellFile{k}.CellON(i)<1)*rootCellFile{k}.CellON(i)*4/3],'edgecolor',[1 1 1]*0.5);
			if i==1
				hold on
			end
			currentPosition=currentPosition+1;
		end

		subplot(sub(2*timepoint))
		ProotStructure=nan(cellFileLength,1);
		currentPosition=0;
		for i=1:cellFileLength
			ProotStructure(i)=drawSquare(k,currentPosition,currentPosition+1,rootCellFile{k}.Protein(i),maxWhite,maxProtein,[1 1 1]*0.5);
			if i==1
				hold on
			end
			currentPosition=currentPosition+1;
		end
	end
	set(sub(2*timepoint-1),'visible','off')
	set(sub(2*timepoint),'visible','off')
	subplot(sub(2*timepoint-1))
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
set(sub(7),'position',[0.93,0.82,0.05,0.1])
sub(8)=axes;
set(sub(8),'position',[0.93,0.4,0.05,0.1])

subplot(sub(7))
CellON=[0,0.5,1];
for i=1:3
	fill([k+1 k+1 k k],[CellON(i)-0.25 CellON(i)+0.25 CellON(i)+0.25 CellON(i)-0.25],[CellON(i)*2/3+(CellON(i)==1)*1/3,CellON(i)*2/3,(CellON(i)<1)*CellON(i)*4/3],'edgecolor','none');
	hold on
end
ylim([-0.25 1.25])
set(gca,'xtick',[],'YTickLabel',{'0','1','2'})

subplot(sub(8))
Protein=0:0.2:maxProtein;
for i=1:length(Protein)
	drawSquare(0,Protein(i)-0.1,Protein(i)+0.1,Protein(i),maxWhite,maxProtein,'none');
	hold on
end
ylim([-0.1 maxProtein-0.1])
set(gca,'xtick',[])
end

function area=drawSquare(x,currentPosition1,currentPosition2,intensity,maxWhite,maxProtein,edgecolor)
    if intensity<=(maxWhite/3)
		area=fill([x+1 x+1 x x],[currentPosition1 currentPosition2 currentPosition2 currentPosition1],[intensity/(maxWhite/3)/3,intensity/(maxWhite/3)/3,intensity/(maxWhite/3)*2/3],'edgecolor',edgecolor);
	elseif intensity<=(maxWhite*2/3)
		area=fill([x+1 x+1 x x],[currentPosition1 currentPosition2 currentPosition2 currentPosition1],[1/3+(intensity-(maxWhite/3))/(maxWhite/3)/3,1/3,2/3],'edgecolor',edgecolor);
	elseif intensity<=maxWhite
		area=fill([x+1 x+1 x x],[currentPosition1 currentPosition2 currentPosition2 currentPosition1],[2/3+(intensity-(2*maxWhite/3))/(maxWhite/3)/3,1/3,(maxWhite-intensity)/(maxWhite/3)*2/3],'edgecolor',edgecolor);
	else
		area=fill([x+1 x+1 x x],[currentPosition1 currentPosition2 currentPosition2 currentPosition1],[1,2*(intensity-maxWhite)/(3*(maxProtein-maxWhite))+1/3,0],'edgecolor',edgecolor);
    end
end