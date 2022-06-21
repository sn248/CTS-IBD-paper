% Current model units are in pmole 
% In this function we will convert pmole to pg for protein species
% Inputs: X_original - not converted units, species_list = names of species in same order as X_original
% Do not need to convert for cells 

function [X_converted] = ConvertUnits(X_original,species_list)

	% We need MW of species 
	MW_proteins = [	17000 %IL4		g/mol
		19000 %IL10 	g/mol	
		25000 %TGFb		g/mol
		70000 %IL12		g/mol, 40000 IL12p40 (IL-12B) g/mol, 35000 IL12p35	g/mol	
		17000 %IFNg		g/mol	
		21000 %TL1A		g/mol	
		15500 %IL2 		g/mol	
		15000 %IL21		g/mol	
		60000 %IL23		g/mol, 19000 IL23p19	g/mol, 40000 IL12p40 (IL-12B)	g/mol	
		26000 %IL6		g/mol	
		15000 %IL17		g/mol	
		16000 %GMCSF	g/mol	
		17000 %TNFa		g/mol	
		12000 %IL13		g/mol	
		24000 %IL5		g/mol	
		13000 %IL15		g/mol	
		17000 %IL18		g/mol	
		16700 %IL22		g/mol	
		8000  %IL8		g/mol	
		110000 %CRP in serum g/mol
		26000 %IL6		g/mol
		145000 %anti_IL6 g/mol
		70000 %IL12		g/mol, 40000 IL12p40 (IL-12B) g/mol, 35000 IL12p35	g/mol
		60000 %IL23		g/mol, 19000 IL23p19	g/mol, 40000 IL12p40 (IL-12B)	g/mol	
		150000 %anti_IL12p40 g/mol
		60000 %IL23		g/mol, 19000 IL23p19	g/mol, 40000 IL12p40 (IL-12B)	g/mol	
		150000 %anti_IL23A g/mol
		15000 %IL17		g/mol	
		150000 %anti_IL17 g/mol
		17000 %TNFa		g/mol	
		150000 %anti_TNFa g/mol
		];
		
	% Now we need locations of proteins from species_list - These match locations in MW_proteins
	Protein_names = {'IL4'
	 'IL10' 		
	 'TGFb'
	 'IL12'		
	 'IFNg'	
	 'TL1A'	
	 'IL2'	
	 'IL21'	
	 'IL23'	
	 'IL6'	
	 'IL17'	
	 'GMCSF'	
	 'TNFa'	
	 'IL13'	
	 'IL5'	
	 'IL15'	
	 'IL18'	
	 'IL22'	
	 'IL8'
	 'CRP'
	 'Total_IL6'
	 'Total_anti_IL6'
	 'Total_IL12'
	 'Total_IL23_1'
	 'Total_anti_IL12p40'
	 'Total_IL23_2'
	 'Total_anti_IL23A'
	 'Total_IL17'
	 'Total_anti_IL17'
	 'Total_TNFa'
	 'Total_anti_TNFa'
	 };
	
	num_proteins = length(Protein_names);
	
	X_converted = X_original; 
	% Here we need to Multiply by MW in Gut Compartment(pmole to g)
	for i = 1:num_proteins
		
		species = Protein_names(i);
		tempname = strcat('Gut.',species);
		loc = find(strcmp(tempname,species_list)==1);
		%keyboard;
		% Here we need to multiply by MW for the protein
		X_converted(loc,:) = MW_proteins(i)*X_original(loc,:);
	
	end
	% Here we need to Multiply by MW in Blood Compartment(pmole to g)
	for i = 1:num_proteins
		
		species = Protein_names(i);
		tempname = strcat('Blood.',species);
		loc = find(strcmp(tempname,species_list)==1);
		% Here we need to multiply by MW for the protein
		X_converted(loc,:) = MW_proteins(i)*X_original(loc,:);
	
	end

end 