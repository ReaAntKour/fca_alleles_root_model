function VENUS_histograms_timecourse(sub,genotype)
if ~exist('sub','var')
	figure
	set(gcf,'outerposition',[350  450  400  250])
	sub(1)=mySubplot(1,3,1,0,0.02,0.15,0.1,0.2);
	sub(2)=mySubplot(1,3,2,0,0.02,0.15,0.1,0.2);
	sub(3)=mySubplot(1,3,3,0,0.02,0.15,0.1,0.2);
end

genotypes={'fca-3','fca-1','Ler'};
if ~exist('genotype','var')
	I=1;
elseif ismember(genotype,genotypes)
	I=find(ismember(genotypes,genotype));
	if (length(I)==1)
		tmp=sub;
		sub=[];
		sub(I)=tmp;
	end
else
	error('Genotype not recognised')
end

%% setup Venus all reps
genotypes_name={'fca3','fca1','Ler'};
timepoints=[7 15 21];
filename='Venus_time_course.csv';
for time=1:3
    timepoint=timepoints(time);
	for gen=1:length(genotypes)
		for rep=1:3
		    % read in data
		    spheresTemp=readtable(filename,'Format','auto');
		    spheresTemp=spheresTemp((ismember(spheresTemp.genotype,genotypes{gen})),:);
		    spheresTemp=spheresTemp((spheresTemp.overlap_fraction>=0.55),:);
		    spheresTemp=spheresTemp((spheresTemp.timepoint==timepoint),:);
		    spheresTemp=spheresTemp(ismember(spheresTemp.flag,''),:);%not "excluded"
		    spheresTemp=spheresTemp(ismember(spheresTemp.tissue,'epidermis'),:);%cortex
		    if rep==3
			    spheresTemp=spheresTemp(ismember(spheresTemp.replicate,{'exp3','exp4'}),:);
		    else
			    spheresTemp=spheresTemp(ismember(spheresTemp.replicate,['exp',num2str(rep)]),:);
		    end
            spheres.(genotypes_name{gen}){time,rep}=spheresTemp.mean_in_sphere./spheresTemp.overlap_fraction-spheresTemp.mean_outside_sphere;
		end
	end
end

%% plot histograms of filled sphere intensity
bin=0.2;
xlim1F=-1;
xlim2F=20;
cols={'k',[0 0 0.5],[0.5 0 0]};
for timepoint=1:3
    for gen=I
        sphereM=[spheres.(genotypes_name{gen}){timepoint,1};spheres.(genotypes_name{gen}){timepoint,2};spheres.(genotypes_name{gen}){timepoint,3}];
		titl=[genotypes{gen},', T',num2str(timepoints(timepoint)),', Combined exp'];
		meanIntensity=mean(sphereM);
		
		[h,m]=histcounts(sphereM,xlim1F:bin:xlim2F);
		x=[m;m];x=x(2:end-1);
		y=100*[h/length(sphereM);h/length(sphereM)];y=y(:)';
		subplot(sub(timepoint))
		area=fill(x,y,cols{gen});
		set(area,'facealpha',1-timepoint/4,'edgecolor','none','displayname',[titl,' '])%,'edgecolor','none'
		hold on
		plot([meanIntensity meanIntensity],[0 100],'b')
		plot([median(sphereM) median(sphereM)],[0 100],'r')
		text(1,20,['Median: ',num2str(median(sphereM),2)],'color','r')
		text(1,50,['Mean: ',num2str(meanIntensity,2)],'color','b')
		text(1,80,['n=',num2str(length(sphereM))])
		if timepoint==2
			xlabel('Intensity')
		end
		set(gca,'ytick',[0 50 100])
		if timepoint==1
			ylabel('% Counts')
		else
			set(gca,'yticklabel',{})
		end
		xlim([-0.3 2])
		ylim([0 100])
		title(titl)
    end
end
