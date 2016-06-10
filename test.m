clc
clear
fid = fopen('Channel68.locs','r');
% ChannelXY = fscanf(fid, '%*d\t%f\t%f\t%*s\n',[68,2]);
% ChannelName= textscan(fid, '%*d\t%*f\t%*f\t%s\n',68);
C = textscan(fid,'%*d\t%.20f64\t%.20f64\t%s');
fclose(fid);
celldisp(C)
ChannelInfo.PosX = C{1} - 0.5;
ChannelInfo.PosY = 0.5 - C{2};
ChannelInfo.Label = C{3};
ChannelInfo.type = t;
ChannelInfo.HeadOutline = lay.outline{1};
ChannelInfo.NoseOutline = lay.outline{2};
ChannelInfo.LeftEarOutline = lay.outline{3};
ChannelInfo.RightOutline = lay.outline{4};


alpha = linspace(0,2*pi,500);
R=0.425;
x=R*cos(alpha);
y=R*sin(alpha);
plot(x,y,'-')

%�Ҷ�
t=linspace(0,pi*0.67,500);
x=0.4550+0.038*cos(t);
y=-0.0255+0.1*sin(t);
plot(x,y)

%���
t=linspace(0,pi*0.67,500);
x=-0.4550+0.038*cos(t);
y=-0.0255+0.1*sin(t);
plot(x,y)
%%
load ChannelInfo;
figure;
hold on;
axis([-0.6 0.6 -0.6 0.6]);
axis equal;

alpha = linspace(0,2*pi,500);
%���
x=ChannelInfo.LeftEarOutline.Center(1)+ChannelInfo.LeftEarOutline.RadiusX*cos(alpha);
y=ChannelInfo.LeftEarOutline.Center(2)+ChannelInfo.LeftEarOutline.RadiusY*sin(alpha);
plot(x,y,'-k','linewidth',3);
%�Ҷ�
x=ChannelInfo.RightEarOutline.Center(1)+ChannelInfo.RightEarOutline.RadiusX*cos(alpha);
y=ChannelInfo.RightEarOutline.Center(2)+ChannelInfo.RightEarOutline.RadiusY*sin(alpha);
plot(x,y,'-k','linewidth',3);


plot(ChannelInfo.NoseOutline(:,1),ChannelInfo.NoseOutline(:,2),'-k','linewidth',3);



R=ChannelInfo.HeadOutline.Radius;
x=ChannelInfo.HeadOutline.Center(1) + R*cos(alpha);
y=ChannelInfo.HeadOutline.Center(2) + R*sin(alpha);
fill(x,y,'w');
plot(x,y,'-k','linewidth',3);

plot(ChannelInfo.PosX,ChannelInfo.PosY,'ok','markersize',4);


LabelPosX = zeros(numel(ChannelInfo.Label),1);
LabelPosY = zeros(numel(ChannelInfo.Label),1);

IndexTwoCharElectrode = ~cellfun('isempty',regexp(ChannelInfo.Label,'^..$'));
IndexThreeCharElectrode = ~cellfun('isempty',regexp(ChannelInfo.Label,'^...$'));

%�ֱ��趨˫�ַ��缫�����ַ��缫�ı�עˮƽλ��
LabelPosX(IndexTwoCharElectrode) =  ChannelInfo.PosX(IndexTwoCharElectrode)-0.018;
LabelPosX(IndexThreeCharElectrode) =  ChannelInfo.PosX(IndexThreeCharElectrode)-0.025;

ChannelInfo.LabelPosX = LabelPosX;

IndexCB1CB2Electrode = ~cellfun('isempty',regexp(ChannelInfo.Label,'^CB.$'));
%�ֱ��趨CB1(58)��CB2��62���������缫�ı�ע��ֱλ��
LabelPosY(IndexCB1CB2Electrode) = ChannelInfo.PosY(IndexCB1CB2Electrode)+0.03;

LabelPosY(~IndexCB1CB2Electrode) = ChannelInfo.PosY(~IndexCB1CB2Electrode)-0.03;

ChannelInfo.LabelPosY = LabelPosY;



text(ChannelInfo.LabelPosX,ChannelInfo.LabelPosY,ChannelInfo.Label,'FontName','Roboto','FontWeight','Bold');

hold off;

