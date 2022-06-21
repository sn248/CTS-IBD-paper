% This function creates a vector of parameters in the model

function [parameter_index,ConstantParameters,ConstantParameterValues] = ParametersToVary(m1)

Type_Matrix = {m1.ValueInfo.Type};
Name_Matrix = {m1.ValueInfo.Name};
Value_Matrix = cell2mat({m1.ValueInfo.InitialValue});

num_values = size(Type_Matrix,2);
parameter_index = [];
ConstantParameters = [];
ConstantParameterValues = [];
count = 0;

% Create a matrix with index for parameters 
for i = 1:num_values

	value_type = Type_Matrix{i};
		
	if strcmp(value_type,'parameter') == 1
		count = count+1;
		parameter_index(count) = i;
		%TempName = string(Name_Matrix(i));
		TempName = Name_Matrix{i};
		ConstantParameters{count}=TempName;
		ConstantParameterValues(count)=Value_Matrix(i);	
	end
	

end


ConstantParameters=ConstantParameters';
ConstantParameterValues=ConstantParameterValues';

end

