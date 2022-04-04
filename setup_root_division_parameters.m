function [MeanCellCycleLength,PD] = setup_root_division_parameters(Stoch_or_Det)
% depending on tissue, a different average cell cycle length is given at
% each position along the file. "tissueType" refers to the type of tissue 
% of the cell file (can be "Epidermis" or "Cortex") and the second
% variable determines whether MeanCell.. is a vector of cell cycle lengths
% for each position ("deterministic") or if it is a function that draws
% from a truncated normal distribution with mean and std based on
% experimental data and also returns a cell cycle length ("stochastic").
% Either format has the same use: "MeanCellCycleLength(whichCell)"

% Cell cycle length extrapolated from measured data in Rahni 2019
EpidermisMeanCellCycleLength=[61.200,35.211,31.775,27.470,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251,23.251];
EpidermisSTDCellCycleLength=[22.486,6.890,7.505,6.742,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395,5.395];

if strcmp(Stoch_or_Det,'deterministic')
	MeanCellCycleLength=EpidermisMeanCellCycleLength;
elseif strcmp(Stoch_or_Det,'stochastic')
		for i=1:32% based on 3:15 from Rahni 2019
			PD(i)=truncate(makedist('Normal','mu',EpidermisMeanCellCycleLength(i),'sigma',EpidermisSTDCellCycleLength(i)),13,1000);
		end
	MeanCellCycleLength=@(whichCell) random(PD(whichCell),1);
else
	error('Incorrect value given to setup root division parameters. "stochastic" or "deterministic" are acceptable')
end