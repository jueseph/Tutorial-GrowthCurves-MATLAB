%% plot raw growth curve

% load data
load('singe_growth_curve.mat');

% plot growth curve
figure
plot(t,odraw,'.-');
xlabel('Time (hours)');
ylabel('OD_{raw} (a.u.)','interpreter','tex');

%%
print('fig/raw od v t','-dpng','-r150');

%% plot log-transformed, background-subtracted growth curve
logod = log2(odraw-0.028);

figure
plot(t,logod,'.-');
xlabel('Time (hours)');
ylabel('log_2 OD','interpreter','tex');
xlim([0 35]);

% fit line to a time window
idx = t>5 & t<12;
brob = robustfit(t(idx),logod(idx));	% brob(2) is the slope

% overlay fitted line
hold all
x = t(idx);
y = brob(1)+brob(2).*t(idx);
plot(x([1 end]), y([1 end]),'ro-','linewidth',2);
ylim([-10 0]);

%%
print('fig/logod v t','-dpng','-r150');

%% demo of bad time window fit
odraw = squeeze(od_all(8,8,:));
logod = log2(max(odraw-0.028,2^-10));

figure
plot(t,logod,'.-');
xlabel('Time (hours)');
ylabel('log_2 OD','interpreter','tex');
xlim([0 35]);

% fit line to a time window
idx = t>5 & t<12;
brob = robustfit(t(idx),logod(idx));	% brob(2) is the slope

% overlay fitted line
hold all
x = t(idx);
y = brob(1)+brob(2).*t(idx);
plot(x([1 end]), y([1 end]),'ro-','linewidth',2);
ylim([-10 0]);

title('Fit over 5 < t < 12','interpreter','tex');

%%
print('fig/logod v t missed','-dpng','-r150');

%% demo of good od window fit
odraw = squeeze(od_all(8,8,:));
logod = log2(max(odraw-0.028,2^-10));

figure
plot(t,logod,'.-');
xlabel('Time (hours)');
ylabel('log_2 OD','interpreter','tex');
xlim([0 35]);

% fit line to a time window
idx = logod>-8 & logod<-4;
brob = robustfit(t(idx),logod(idx));	% brob(2) is the slope

% overlay fitted line
hold all
x = t(idx);
y = brob(1)+brob(2).*t(idx);
plot(x([1 end]), y([1 end]),'ro-','linewidth',2);
ylim([-10 0]);

title('Fit over -8 < log_2OD < -4','interpreter','tex');

%%
print('fig/logod v t odwindow','-dpng','-r150');

%%
save('plate_data','od_all','t');

%%
print('fig/grid logod v t 2','-dpng','-r150');

%% plot multiple growth curves with OD-window fitting
load('plate_data.mat');
strainNames = readtable('strain_names.csv','readvariablenames',false);

[hf ha] = gridplot(2,3,200,200);    % custom function for making subplots

for r = 3:4
    for c = 2:4
        axes(ha(3*(r-3)+c-1));
        
        odraw = squeeze(od_all(r,c,:));
        logod = log2(max(odraw - 0.028,2^-10));
        
        plot(t,logod,'o','markersize',3);
        xlim([0 35]);
        ylim([-10 0]);
        xlabel('Time (hours)');
        ylabel('log_2 OD','interpreter','tex');
        
        hold all
        idx = logod>-8 & logod<-4;
        brob = robustfit(t(idx),logod(idx));	% brob(2) is the slope
        x = t(idx);
        y = brob(1)+brob(2).*t(idx);
        plot(x([1 end]), y([1 end]),'ro-','linewidth',1.5);

        adjustaxeslabels([2 3],[r-2 c-1]);
        labelplot(strainNames{r,c});
        labelplot(num2str(brob(2),2),'location','southeast');
    end
end

%%
print('fig/grid logod v t odwindow','-dpng','-r150');