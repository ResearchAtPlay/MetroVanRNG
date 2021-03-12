This README.txt file was generated on 2021-02-22 by Kevin Palmer-Wilson


GENERAL INFORMATION

1. Title of Dataset: 
Modelling data: Electricity and renewable gas energy system alternatives for fossil fuel substitution in Metro Vancouver, British Columbia, Canada 

2. Author Information
		Name: Kevin Palmer-Wilson
		Institution: University of Victoria
		Address: Institute for Integrated Energy Systems, Department of Mechanical Engineering, University of Victoria, PO Box 1700 STN CSC, Victoria BC V8W 2Y2, Canada
		Email: kevinpw@uvic.ca

3. Date of data collection (single date, range, approximate date): 
2019-01-22 - 2021-02-22

4. Geographic location of data collection: 
British Columbia, Canada

5. Information about funding sources that supported the collection of the data: 
Energy Modelling Initiative

SHARING/ACCESS INFORMATION

1. Licenses/restrictions placed on the data:
MIT License

2. Links to publications that cite or use the data: 
https://emi-ime.ca/projects/call-for-projects/


DATA & FILE OVERVIEW

1. File List:

	/0_README.txt - this file
	/EnergyDemandData/AnnualEnergyDemands.csv - estimated annual end-use space heat demand, end-use water heat demand, and net electricity demand (excluding space and water heating) for Metro Vancouver
	/EnergyDemandData/HourlyEnergyDemandProfiles.csv - normalized hourly end-use space heat, end-use water heat, and electricity demand profiles for Metro Vancouver
	/OSeMOSYS_MetroVanRNG.mod - Modified custom version of the Open Source Energy System Model

	/results/$Scenario/$Scenario_$SubShare_$Pathway_SelRes.csv - Optimization output results
	/parameters/$Scenario/$Scenario_$SubShare_$Pathway_params.txt - Input model parameters
	
	where:
	$Scenario = [Reference, LowHeatDemand, MuchBiogas] - the scenario name
	$Sub = [0, 10, ..., 100] - the natural gas substitution rate from 0 to 100 percent
	$Pathway = [Elec, 100H] - the electrification or the renewable gas pathway
	For example:
	/results/LowHeatDemand/LowHeatDemand_60Share_100H_SelRes.csv - Optimization output for LowHeatDemand scenario with natural gas substitution rate of 60 percent in the hydrogen pathway
	

METHODOLOGICAL INFORMATION

1. Description of methods used for collection/generation of data: 
The model, parameters, and results accompany the Energy Modelling Initiative Report: "Electricity and renewable gas energy system alternatives for fossil fuel substitution in British Columbia" dated 19 March 2021.

2. Methods for processing the data: 
<describe how the submitted data were generated from the raw or collected data>

3. Instrument- or software-specific information needed to interpret the data: 
Please use the GNU Linear Programming Kit (GLPK) by Andrew Makhorin to run the model. Available at: https://www.gnu.org/software/glpk/
To solve a specific parameter file, add the glpksol.exe in a /GLPK/ subfoler run the following command in the command line:
.\GLPK\glpsol.exe -m OSeMOSYS_RNG-V47.mod -d LowHeatDemand_60Share_100H_params.txt --log logfile.txt