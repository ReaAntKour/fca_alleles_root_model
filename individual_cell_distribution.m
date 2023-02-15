%% Model parameters
ONmu=-1.2;
OFFmu=-2.3;
ONstd=0.7;
OFFstd=0.3;

xlim2Venus=5;binVenus=0.001;
x=0.001:binVenus:xlim2Venus;

%% Generate Histograms for Individual Cell Distributions
ON_ON=2*exp(ONstd*randn(100000,1)+ONmu)+exp(OFFstd*randn(100000,1)+OFFmu);
ON_OFF=exp(ONstd*randn(100000,1)+ONmu)+exp(OFFstd*randn(100000,1)+OFFmu);
OFF_OFF=exp(OFFstd*randn(100000,1)+OFFmu);

%% PDF
lognorm=@(x,m,s) exp(-((log(x)-m).^2)/(2*s^2))./(x*s*sqrt(2*pi));
lognormCDF=@(x,m,s) 1/2*(1+erf((log(x)-m)/(s*sqrt(2))));
logSum2CTMP=@(y,x,m1,s1,m2,s2) lognorm((x-y)/2,m1,s1).*lognorm(y,m2,s2);
logSum1CTMP=@(y,x,m1,s1,m2,s2) lognorm(x-y,m1,s1).*lognorm(y,m2,s2);
Dist2C=logSum(logSum2CTMP,x,ONmu,ONstd,OFFmu,OFFstd);
Dist1C=logSum(logSum1CTMP,x,ONmu,ONstd,OFFmu,OFFstd);
th_ON_ON=Dist2C/(sum(Dist2C)/length(Dist2C)*xlim2Venus);
th_ON_OFF=Dist1C/(sum(Dist1C)/length(Dist1C)*xlim2Venus);
th_OFF_OFF=lognorm(x,OFFmu,OFFstd)./lognormCDF(xlim2Venus,OFFmu,OFFstd);

%% plot
figure
set(gcf,'outerposition',[341   692   514   297])
sub(1)=mySubplot(1,3,1,0,0.02,0.15,0.1,0.2);
sub(2)=mySubplot(1,3,2,0,0.02,0.15,0.1,0.2);
sub(3)=mySubplot(1,3,3,0,0.02,0.15,0.1,0.2);

calc={ON_ON,ON_OFF,OFF_OFF};
th={th_ON_ON,th_ON_OFF,th_OFF_OFF};
name={'ON/ON cells','ON/OFF cells','OFF/OFF cells'};
cols={[1 1 0],[0.5 0.5 0],[0 0 0]};
for i=1:3
	subplot(sub(i))
	[h,m]=histcounts(calc{i},x);
	u=[m;m];u=u(2:end-1);
	y=[h/length(calc{i})/binVenus;h/length(calc{i})/binVenus];y=y(:)';
% 	area=fill(u,y,cols{i});
	area=fill(x,th{i},cols{i});
	set(area,'facealpha',0.15,'edgecolor','k')
	hold on
% 	plot([mean(calc{i}) mean(calc{i})],[0 100],'b')
%     text(1,4,num2str(mean(calc{i}),2))
    if i==1
	    ylabel('PDF')
    elseif i==2
        xlabel('Intensity')
    end
	xlim([0 2])
	ylim([0 15])
	title(name{i})
end

function out=logSum(fun,xbin,m1,s1,m2,s2)
    out=nan(1,length(xbin));
    for i=1:length(xbin)
        x=xbin(i);
        out(i)=integral(@(y) fun(y,x,m1,s1,m2,s2),0,x);
    end
end