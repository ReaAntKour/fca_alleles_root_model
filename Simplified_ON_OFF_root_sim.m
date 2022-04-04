function rootCellFile=Simplified_ON_OFF_root_sim(varargin)
% Can use output rootCellFile of previous run as input, to continue running
if (~isempty(varargin))&&iscell(varargin{1})
	skipMakeRoot=1;
	rootCellFile=varargin{1};
	
	options=varargin(2:end);
else
	skipMakeRoot=0;
	options=varargin;
end

%% parameters
% How long should the file be. After division, cells beyond are discarded
cellFileLength=30;

% How long is each simulation step
timestep=1;% hour

% How many files of cells to simulate. Each is like an independent run
cellFiles=options{2*find(ismember(options(1:2:length(options)),'cellFiles'))};

% How many hours to run the simulation
simDuration=options{2*find(ismember(options(1:2:length(options)),'simDuration'))};
steps=ceil(simDuration/timestep);

% vector with parameter values
parameters=options{2*find(ismember(options(1:2:length(options)),'parameters'))};
p=parameters(1);


%% setup root
MeanCellCycleLength=setup_root_division_parameters('stochastic');% cell cycle lengths according to position (alternative "deterministic"). details given in function
if ~skipMakeRoot
	rootCellFile=cell(cellFiles,1);
	for k=1:cellFiles
		rootCellFile{k}=table;
		for whichCell=1:cellFileLength
			rootCellFile{k}.CellCycle(whichCell)=MeanCellCycleLength(whichCell)*rand(1);
			if whichCell==31
				rootCellFile{k}.CellCycle(32:cellFileLength)=Inf;
				break
			end
		end
		rootCellFile{k}.CellON=ones(cellFileLength,1);
	end
end

%% run simulation
for k=1:cellFiles
	timeInt=1;
	for j=1:steps% of length given by "timestep"
		%% divide cells and switch OFF
		if (j*timestep)>=timeInt
			rootCellFile{k}=root_sim_divide_and_switch(rootCellFile{k},p,cellFileLength,MeanCellCycleLength);
			timeInt=timeInt+1;
		end
	end
end