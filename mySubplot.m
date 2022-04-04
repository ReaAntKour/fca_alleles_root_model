function varargout=mySubplot(rows,cols,pos,dist,distx,disty,startX,startY)
if nargin<8
	startX=0.1;
	startY=0.1;
end
if nargin<5
	distx=dist;
	disty=dist;
end

x=(1-startX)/cols-distx;
y=(1-startY)/rows-disty;

posc=mod(pos-1,cols)+1;
posr=rows-(pos-posc)/cols;

sub=axes;
set(sub,'box','on','position',[startX+(posc-1)*(x+distx),startY+(posr-1)*(y+disty),x,y])

hold on

if (posc>1)&&(distx<0.05)
	set(sub,'yticklabel',{})
end
if (posr>1)&&(disty<0.05)
	set(sub,'xticklabel',{})
end

if nargout>0
	varargout={sub};
end