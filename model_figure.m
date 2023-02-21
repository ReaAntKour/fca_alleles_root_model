clear
cellFiles=1000;
rep=1;
days=[7 15 21];

% Change to true to use provided ".mat" file matching manuscript figure
plot_from_fig=true;

if plot_from_fig
	filename='pONOFF_cellFiles1000.mat';
    S=load(filename);
    cellFiles=S.cellFiles;
    rootCellFile7=S.rootCellFile7;
    rootCellFile15=S.rootCellFile15;
    rootCellFile21=S.rootCellFile21;
else
	filename=['pONOFF_cellFiles',int2str(cellFiles),'_rep_',int2str(rep)];
end

%% Model parameters
pON=0.0007;% probability of OFF cell switching ON!
pOFF=0.01;% probability of ON cell switching OFF!
ONmu=-1.2;
OFFmu=-2.3;
ONstd=0.7;
OFFstd=0.3;
parameters=[pON pOFF ONmu OFFmu ONstd OFFstd];

%% run model
if ~plot_from_fig
	rootCellFile7=Simplified_ON_OFF_root_sim('cellFiles',cellFiles,'simDuration',24*days(1),'parameters',parameters);
	rootCellFile15=Simplified_ON_OFF_root_sim(rootCellFile7,'cellFiles',cellFiles,'simDuration',24*(days(2)-days(1)),'parameters',parameters);
	rootCellFile21=Simplified_ON_OFF_root_sim(rootCellFile15,'cellFiles',cellFiles,'simDuration',24*(days(3)-days(2)),'parameters',parameters);
	rootCellFile7=Prot_from_Simplified_ON_OFF_root_sim(rootCellFile7,'cellFiles',cellFiles,'parameters',parameters);
	rootCellFile15=Prot_from_Simplified_ON_OFF_root_sim(rootCellFile15,'cellFiles',cellFiles,'parameters',parameters);
	rootCellFile21=Prot_from_Simplified_ON_OFF_root_sim(rootCellFile21,'cellFiles',cellFiles,'parameters',parameters);
	save(filename)
end

%% plot
figure
set(gcf,'outerposition',[272    79   550   480])
subF=@(pos) mySubplot(2,3,pos,0,0.02,0.08,0.1,0.1);
for i=1:6
	sub(i)=subF(i);
end

% Cells 1-4 are ignored (estimate these are not included in imaging)
plot_from_saved_with_data(filename,sub)

%% draw roots
for i=1:10
	draw_roots_state_and_Protein(rootCellFile7(i*12+(1:12)),rootCellFile15(i*12+(1:12)),rootCellFile21(i*12+(1:12)));
end