clear all; clc; close all;

dinfo = dir('*.txt'); %Call Directory to Data Folder with TEXT Files
Power = [200,250,300,350,400];
Speed = [200,400,600];
PrintParameters = [200,200,200,250,250,250,300,300,300,350,350,350,400,400,400,200,400,600,200,400,600,200,400,600,200,400,600,200,400,600];
varNames ={'V_12','I_23','V_34','I_41','R_S'};
varNames2 ={'Power','Speed','Mean','Standard Error'};
Rs = cell2table(cell(0,4));
tit = pwd; %Folder Path
tit = tit(110:end); %Folder Name
K=1; %Loop counter for iterating across each file
%Loop Through All Text Files and Store Filename, Resistance, 
for i=1:5
    for j = 1:3
        data = zeros(10,5); %Empty Zeros Array for Storing Values
        for t =1:4
            if rem(t,2) == 0
                m=2;
            else
                m=1;
            end
            thisdata = importdata(dinfo(K).name); %load just this file
            data(:,t)= thisdata.data(:,m);
            K=K+1;
        end
        data(:,5)= pi.*(data(:,1)./data(:,2)+data(:,3)./data(:,4))./(4*log(2)).*1; %Calculates Sheet Resistance
        evalin('base',sprintf('data_%dW_%dS=array2table(data,''VariableNames'',varNames);',Power(i),Speed(j))); %Creates a table name wtih column names 
        Rs = [Rs;table(Power(i),Speed(j),mean(data(:,5)),std(data(:,5))/sqrt(10))]; % appends printing parameters, average sheet resistance, and standard error into a table
    end
end
Rs.Properties.VariableNames=varNames2;

%Set Random Array xaxis and point colors
Sample=[1:15]';
Rs.Mean = Rs.Mean*1000+c; %Unit Conversion
%For Loop to Make Each Point in the Legend
figure;
hold on

for k=1:numel(Sample)
plot = scatter(Sample,table2array(Rs(:,3)),'k','v','filled');
hold on;
%Overlay Error Bars
errorbar(Sample,table2array(Rs(:,3)),table2array(Rs(:,4)),'k','LineStyle','none');
end

%Assign Cosmetic Graph Attributes
xlh = xlabel(sprintf('P[W]:        %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d \nS[mm/s]: %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d',PrintParameters),'FontSize',10);
ylabel('R_s (Ohm/sqm)','FontSize',10); title(sprintf('%s Resistivity',tit),'FontSize',20);
set(gca,'XTick',[])
%legend(('Back Left', 'Back Right', 'Front Left', 'Front Right', 'Error'),'FontSize',30);


