% SimulateModel will run model for given parameters and weights [] = no weights
% VPmodel = exported simbiology model, parameters = kinetic parameters, weights = weights CD and UC 
% Update - If change model update NumofStates (species)


function [X_converted,T,species_list,OutDYDT] = SimulateModel(VPmodel,parameters,weights)
	
	% Reset Species to 0 -
	Type_Matrix = {VPmodel.ValueInfo.Type};
	loc_species = find(strcmp(Type_Matrix,'species'));
	NumofStates = length(loc_species);
	for k = 1:NumofStates
	
		VPmodel.ValueInfo(loc_species(k)).InitialValue = 0;
	
	end	
	
	
	% Get parameters and initial values
	[parameter_index,ConstantParameters,ConstantParameterValues] = ParametersToVary(VPmodel);
	
	% See parameters that are weighted 
	[Parameters_weight,weight_loc] = ParametersToWeight(parameter_index,ConstantParameters);
	num_weights = size(Parameters_weight,1);
	
	if isempty(weights) 
		weights = ones(num_weights,1);
	end
	
	% Change parameters based on weight and weight_loc
	
	parameters_new = parameters;
	
	for i = 1:num_weights
		
		%Here we need the location of the weight in the vector of kinetic parameters
		loc = weight_loc(i);
		parameters_new(loc) = weights(i)*parameters(loc);
		
	end

	p = parameters_new;
	% Create variant - Change parameter initial value  
	for j=1:numel(p)
		param_loc = parameter_index(j);
		VPmodel.ValueInfo(param_loc).InitialValue = p(j);
	end
	
	
	[SS_FLAG,TSIM,XSIM,names] = FindSteadyState(VPmodel,parameter_index);
	
	if SS_FLAG == 0 
		% FindSteadyState was successful
		OutDYDT = XSIM'; 
		T = TSIM;
		species_list = names; 
	else
		x_currentVP = 1e30*ones(NumofStates,1);    
		t_currentVP=[1 2];
		species_list = names;
	end

	% Currently XSIM for proteins is in pmole - change to pg 
	[X_converted] = ConvertUnits(OutDYDT,species_list);

end