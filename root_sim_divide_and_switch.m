function [rootCellFile,divisionPositions]=root_sim_divide_and_switch(rootCellFile,p,cellFileLength,MeanCellCycleLength)
rootCellFile.CellCycle=rootCellFile.CellCycle-1;
whichCells=find(rootCellFile.CellCycle<=0);
whichCells=whichCells+(0:(length(whichCells)-1))';
whichCells=whichCells(whichCells<=cellFileLength);
divisionPositions=whichCells;
for cellI=1:length(whichCells)
	whichCell=whichCells(cellI);
	rootCellFile(((whichCell+1):height(rootCellFile))+1,:)=rootCellFile((whichCell+1):height(rootCellFile),:);
	
	%% time of next division
	if whichCell>31
		if whichCell<cellFileLength
			rootCellFile.CellCycle(whichCell+1)=Inf;
		end
		rootCellFile.CellCycle(whichCell)=Inf;
	else
		if whichCell<cellFileLength
			rootCellFile.CellCycle(whichCell+1)=MeanCellCycleLength(whichCell+1);
		end
		rootCellFile.CellCycle(whichCell)=MeanCellCycleLength(whichCell);
	end
	
	%% switching
	if rootCellFile.CellON(whichCell)==0
		if whichCell<cellFileLength
			rootCellFile.CellON(whichCell+1)=0;
		end
		rootCellFile.CellON(whichCell)=0;
	elseif rootCellFile.CellON(whichCell)==0.5
		randNum=rand(1);
		if randNum<p^2
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0;
			end
			rootCellFile.CellON(whichCell)=0;
		elseif randNum<(p^2+(1-p)*p)
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0;
			end
			rootCellFile.CellON(whichCell)=0.5;
		elseif randNum<(p^2+2*(1-p)*p)
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0.5;
			end
			rootCellFile.CellON(whichCell)=0;
		else
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0.5;
			end
			rootCellFile.CellON(whichCell)=0.5;
		end
	elseif rootCellFile.CellON(whichCell)==1
		randNum=rand(1);
		if randNum<p^4
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0;
			end
			rootCellFile.CellON(whichCell)=0;
		elseif randNum<((p^4)+2*(1-p)*(p^3))
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0.5;
			end
			rootCellFile.CellON(whichCell)=0;
		elseif randNum<((p^4)+4*(1-p)*(p^3))
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0;
			end
			rootCellFile.CellON(whichCell)=0.5;
		elseif randNum<((p^4)+4*(1-p)*(p^3)+4*((1-p)^2)*(p^2))
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0.5;
			end
			rootCellFile.CellON(whichCell)=0.5;
		elseif randNum<((p^4)+4*(1-p)*(p^3)+5*((1-p)^2)*(p^2))
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0;
			end
			rootCellFile.CellON(whichCell)=1;
		elseif randNum<((p^4)+4*(1-p)*(p^3)+6*((1-p)^2)*(p^2))
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=1;
			end
			rootCellFile.CellON(whichCell)=0;
		elseif randNum<((p^4)+4*(1-p)*(p^3)+6*((1-p)^2)*(p^2)+2*((1-p)^3)*p)
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=1;
			end
			rootCellFile.CellON(whichCell)=0.5;
		elseif randNum<((p^4)+4*(1-p)*(p^3)+6*((1-p)^2)*(p^2)+4*((1-p)^3)*p)
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=0.5;
			end
			rootCellFile.CellON(whichCell)=1;
		else
			if whichCell<cellFileLength
				rootCellFile.CellON(whichCell+1)=1;
			end
			rootCellFile.CellON(whichCell)=1;
		end
	end
end
% delete all beyond cellFileLength
rootCellFile=rootCellFile(1:cellFileLength,:);
% no next division beyond division zone
rootCellFile.CellCycle(32:end)=Inf;