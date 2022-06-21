% Run_Model_Example.m

% Load Model 
load('.\exportedGutInflammation.mat');
VPmodel = exportedModel;

% Load Population 
load('.\VPop_Baseline');

parameters = VPop(1:334,:);
weights_HV = [];
weights_CD = VPop(335:358,:);
weights_UC = VPop(359:382,:);

% Choose Population member: 
pop_num = 1;

% Simulate Model 
[X_HV,T,n_HV,OutDYDT] = SimulateModel(VPmodel,parameters(:,pop_num),weights_HV);
[X_CD,T,n_CD,OutDYDT] = SimulateModel(VPmodel,parameters(:,pop_num),weights_CD(:,pop_num));
[X_UC,T,n_UC,OutDYDT] = SimulateModel(VPmodel,parameters(:,pop_num),weights_UC(:,pop_num));

% Want concentrations for x in per ml - different volume for different compartments
	volGut = 933;
	volBlood = 4500;
	volLiver = 1660;
	
	num_species = size(n_HV,1);

	for i = 1:num_species
		
		if isempty(strmatch('Gut',n_HV(i))) == 0 && strcmp('Gut.Calprotectin',n_HV(i)) ~= 1 
			X_HV(i,:) = X_HV(i,:)/volGut;
			X_CD(i,:) = X_CD(i,:)/volGut;
			X_UC(i,:) = X_UC(i,:)/volGut;
		elseif strmatch('Blood',n_HV(i))	
			X_HV(i,:) = X_HV(i,:)/volBlood;
			X_CD(i,:) = X_CD(i,:)/volBlood;
			X_UC(i,:) = X_UC(i,:)/volBlood;
		elseif strmatch('Liver',n_HV(i))
			X_HV(i,:) = X_HV(i,:)/volLiver;
			X_CD(i,:) = X_CD(i,:)/volLiver;
			X_UC(i,:) = X_UC(i,:)/volLiver;
		end 
			
	end

	
% Let's just plot boxplot of a few example proteins 
xtick_labels = {'HV','CD','UC'};

% CRP - pg/mL to mg/L
subplot(2,2,1)
bar([X_HV(40,end)/1E6,X_CD(40,end)/1E6,X_UC(40,end)/1E6])	
ylabel('CRP (mg/L)')
set(gca,'XTickLabel',xtick_labels)

% FCP - mg/kg 
subplot(2,2,2)
bar([X_HV(36,end),X_CD(36,end),X_UC(36,end)])	
ylabel('FCP (mg/kg)')
set(gca,'XTickLabel',xtick_labels)

% IL8 - pg/mL 
subplot(2,2,3)
bar([X_HV(42,end),X_CD(42,end),X_UC(42,end)])	
ylabel('IL8 - Blood (pg/mL)')
set(gca,'XTickLabel',xtick_labels)

% IL12 - pg/mL 
subplot(2,2,4)
bar([X_HV(44,end),X_CD(44,end),X_UC(44,end)])	
ylabel('IL12 - Blood (pg/mL)')
set(gca,'XTickLabel',xtick_labels)

