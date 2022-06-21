% This function determines species locations in the model 
% Inputs: m1 = exported Simbiology model
% Outputs: species_index = index of species locations in ValueInfo of simbiology model
% species_name_list = List of species names

function [species_index,species_name_list] = Species_Location(m1)
	
	% Get infomation from exported model in a readable form
	Type_Matrix = {m1.ValueInfo.Type};
	Name_Matrix = {m1.ValueInfo.Name};
	Value_Matrix = cell2mat({m1.ValueInfo.InitialValue});
	Parent_Matrix = {m1.ValueInfo.Parent};
	
	num_values = size(Type_Matrix,2);
	species_index = [];
	species_name_list = [];
	count = 0;
	
	% Create a matrix with index for species
	% In 2016b version can use string() - cannot use in 2016a version
	for i = 1:num_values

		%value_type = string(Type_Matrix(i));
		value_type = Type_Matrix{i};
		
		%if value_type == 'parameter'
		
		if strcmp(value_type,'species') == 1
			count = count+1;
			species_index(count) = i;
			%TempName = string(Name_Matrix(i));
			TempName = strcat(Parent_Matrix{i},'.',Name_Matrix{i});
			species_name_list{count}=TempName;
				
		end

	end
	

end