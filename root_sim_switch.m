function rootCellFile=root_sim_switch(rootCellFile,pON,pOFF,cellFileLength)
for whichCell=1:cellFileLength
	%% switching
    if rootCellFile.CellON(whichCell)==0
		randNum=rand(1);
        if randNum<(pON^2)
			rootCellFile.CellON(whichCell)=1;
		elseif randNum<((pON^2)+2*pON*(1-pON))
			rootCellFile.CellON(whichCell)=0.5;
        end

	elseif rootCellFile.CellON(whichCell)==0.5
		randNum=rand(1);
        if randNum<(pOFF*(1-pON))
			rootCellFile.CellON(whichCell)=0;
		elseif randNum<(pOFF*(1-pON)+pON*(1-pOFF))
			rootCellFile.CellON(whichCell)=1;
        end

	elseif rootCellFile.CellON(whichCell)==1
		randNum=rand(1);
        if randNum<(pOFF^2)
			rootCellFile.CellON(whichCell)=0;
		elseif randNum<((pOFF^2)+2*pOFF*(1-pOFF))
			rootCellFile.CellON(whichCell)=0.5;
        end
    end
end