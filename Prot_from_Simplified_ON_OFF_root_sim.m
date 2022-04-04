function rootCellFile=Prot_from_Simplified_ON_OFF_root_sim(rootCellFile,varargin)
%% input parameters
options=varargin;

% How many files of cells to simulate. Each is like an independent run
cellFiles=options{2*find(ismember(options(1:2:length(options)),'cellFiles'))};

% vector with parameter values
parameters=options{2*find(ismember(options(1:2:length(options)),'parameters'))};
ONmu=parameters(2);
OFFmu=parameters(3);
ONstd=parameters(4);
OFFstd=parameters(5);

%% Protein
for k=1:cellFiles
	rootCellFile{k}.Protein=...
		(2*exp(ONstd*randn(length(rootCellFile{k}.CellON),1)+ONmu)).*(rootCellFile{k}.CellON==1)+...
		(exp(ONstd*randn(length(rootCellFile{k}.CellON),1)+ONmu)).*(rootCellFile{k}.CellON==0.5)+...
		(exp(OFFstd*randn(length(rootCellFile{k}.CellON),1)+OFFmu));
end