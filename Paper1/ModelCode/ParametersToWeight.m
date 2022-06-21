% This function creates a vector of parameters that will be weighted between UC and CD and also the location of the paramters
% Update - If additional reactions may want to add to this weighted structure

function [Parameters_weight,weight_loc] = ParametersToWeight(parameter_index,parameters)

%Label parameters that we want to vary between diseases
 Parameters_weight = {	'kbasal_Th0' %basal production/transport of Th0 cells
						'kbasal_iDC' %basal rate of production of null -> iDC
						'kbasal_IL12' %basal production of IL12
						'kbasal_IFNg' %basal production of IFNg
						'kbasal_IL2' %basal production of IL2
						'kbasal_IL6' %basal production of IL6
						'kbasal_IL23' %basal production of IL23
						'kbasal_IL21' %basal production of IL21
						'kbasal_TGFb' %basal production of TGFb
						'kbasal_IL10' %basal production of IL10
						'kbasal_TL1A' %basal production of TL1a
						'kbasal_IL13' %basal production of IL13
						'kbasal_IL17' %basal production of IL17
						'kbasal_IL5' %basal production of IL5
						'kbasal_IL4' %basal production of IL4
						'kbasal_IL15' %basal production of IL15
						'kbasal_IL18' %basal production of IL18
						'kbasal_TNFa' %basal production of TNFa
						'kbasal_NK' %basal production/transport of NK cells
						'kbasal_IL22' %basal rate of null -> IL22 
						'kbasal_NKT' %basal rate of null -> NKT
						'kbasal_Neu' %basal rate of null -> Neu
						'kbasal_IL8' %basal rate of null -> IL8
						'kbasal_GMCSF' %base rate of null -> GMCSF
						};

	num_totalParams = numel(parameters);
	numWeightedParams = size(Parameters_weight,1);
	
	% In 2016b version can use string() - cannot use in 2016a version
	%CurrentParameters = string(parameters);
	CurrentParameters = parameters;
	
	for i = 1:numWeightedParams
	
		tempName = Parameters_weight(i);
		loc = find(strcmp(tempName,CurrentParameters)==1);
		% This is the weight location in the vector of just the kinetic parameters
		weight_loc(i) = loc;
	
	end
		weight_loc = weight_loc';
end

 
   
