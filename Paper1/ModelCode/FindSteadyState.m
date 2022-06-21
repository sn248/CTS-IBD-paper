% This function will calculate steady state of an exported simbiology model
% Input: m1 = exported Simbiology Model, parameter_index = parameters *****Note parameters already need to be updated in the model that is given in the input
% Output: SS_FLAG - 1 indicates error finding steady state, TSIM - time matrix, XSIM - matrix of time by species concentration, names_2 = output names matrix 
% Update - Can change epsilon


function [SS_FLAG,TSIM,XSIM,names_2] = FindSteadyState(m1,parameter_index)

	% Determine species location in model so can exclude outputs that are not species (i.e. rates that are not constant)
	[species_index,species_name_list] = Species_Location(m1);
	%SpeciesInitialValues = [];
	
	% Exclude species from steady state constraint -
	EXCLUDE = []; 
	NP = length(parameter_index);
	NX = length(species_index);
	XSIM = [];
	TSIM = [];

	% Set lower concentration bound -
	THRESHOLD = 10^-5;
	
	% When we make it here we need to find a steady-state -
	SS_LOOP_FLAG = 1;
	TSTART = 0.0;
	TSTOP = 5000;
	EPSILON = 1E-3;
	DEPTH = 10;
	MaxTime = 50000;
	Time_completed = 0;
	SS_FLAG = 0;
	
	while (SS_LOOP_FLAG)
	
		% Run for the solver for a bit -
		m1.SimulationOptions.StopTime = TSTOP;
		% This model should not take more than 30s - if so something went wrong
		m1.SimulationOptions.MaximumWallClock = 10;
	
		[T_1,X_1,names_1] = simulate(m1);
		if length(T_1) > TSTOP*2
			% Exit Loop - Cannot find Steady State
			SS_FLAG = 1;
			SS_LOOP_FLAG = 0;
		
		end
		
		% Set the new IC -
		IC = X_1(end,:)';
		for j=1:NX
			species_loc = species_index(j);
			m1.ValueInfo(species_loc).InitialValue = IC(j);
		end
	
		Time_completed = Time_completed + T_1(end);
		% Run for the solver for a bit -
		m1.SimulationOptions.StopTime = TSTOP/4;
		[T_2,X_2,names_2] = simulate(m1);
		Time_completed = Time_completed + T_2(end);

		% We need to exclude parameters that are not constant from names list as rates to exclude or it will effect threshold calculation
		for t = 1:length(names_2)
			
			if isempty(find(strcmp(species_name_list,names_2(t)) == 1))
				% This is not a species and we will exclude it 
				EXCLUDE = [EXCLUDE t]; 
				
			end
			
		end
		
		
		% OK, when I get here I have two time-points. We need to run the simulation until the change between the points is less than  epsilon -
		
		for z = 1:NX
			
			if abs(X_2(end,z)) > 0
				
				ERR(z,1) = abs(X_2(end,z)' - X_1(end,z)')./X_1(end,z)';
			else

				ERR(z,1) = 0;
			end
				
		end		
		
		% Find the worst offender whos absolute value exceeds the threshold -
		FIND_THRES = find(X_2(end,:)' > THRESHOLD);
		FIND_THRES = setdiff(FIND_THRES,EXCLUDE);
	
		TOL = max(ERR([FIND_THRES],1));

	
		if (TOL < EPSILON)
			% If we get here then I have a steady-state. Grab the value and set the FLAG to 0 to KILL the loop -
			SS_LOOP_FLAG = 0;
			ICSS = transpose(X_2(end,:));
	
		elseif (Time_completed > MaxTime)
			% Exit Loop - Cannot find Steady State
			SS_FLAG = 1;
			SS_LOOP_FLAG = 0;
		
			
		else
		
			% Set the new IC -
			IC = X_2(end,:)';
			for j=1:NX
				species_loc = species_index(j);
				m1.ValueInfo(species_loc).InitialValue = IC(j);
			end
			
		end
	end
	
	if SS_FLAG == 0 
		% Lets get the inital values
		XSIM = X_2;
		TSIM = T_2;
		
	else
		% Failed Steady State
		
	end	
	
return;