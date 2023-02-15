function [rootCellFile,divisionPositions]=root_sim_divide(rootCellFile,cellFileLength,MeanCellCycleLength)
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
	
	%% cell state is inherited to both daughter cells
    if whichCell<cellFileLength
        rootCellFile.CellON(whichCell+1)=rootCellFile.CellON(whichCell);
    end
end
% delete all beyond cellFileLength
rootCellFile=rootCellFile(1:cellFileLength,:);
% no next division beyond division zone
rootCellFile.CellCycle(32:end)=Inf;