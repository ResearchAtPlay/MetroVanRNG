# OSeMOSYS_2017_11_08
# 
# Open Source energy MOdeling SYStem
#
# Modified by Francesco Gardumi, Constantinos Taliotis, Igor Tatarewicz, Adrian Levfert
# Main changes to previous version OSeMOSYS_2016_08_01
# Bugs fixed in equations:
#		- Objective function
#		- E5, E8, E9
#		- SV1, SV2
#		- SC2 (both lower and upper)
#		- RE4
# ============================================================================
#
#    Copyright [2010-2015] [OSeMOSYS Forum steering committee see: www.osemosys.org]
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# ============================================================================
#
#  To run OSeMOSYS, enter the following line into your command prompt after replacing FILEPATH & YOURDATAFILE with your folder structure and data file name:
#
#  C:\...FILEPATH...\glpsol -m C:\...FILEPATH...\osemosys_short.txt -d C:\...FILEPATH...\YOURDATAFILE.txt -o C:\...FILEPATH...\Results.txt
#
#  Alternatively, install GUSEK (http://gusek.sourceforge.net/gusek.html) and run the model within this integrated development environment (IDE).
#  To do so, open the .dat file and select "Use External .dat file" from the Options menu. Then change to the model file and select the "Go" icon or press F5.
#
#                                      #########################################
######################                        Model Definition                                #############
#                                      #########################################
#
###############
#    Sets     #
###############
#
set YEAR;
set TECHNOLOGY;
set TIMESLICE;
set FUEL;
set EMISSION;
set MODE_OF_OPERATION;
set REGION;
set SEASON;
set DAYTYPE;
set DAILYTIMEBRACKET;
set FLEXIBLEDEMANDTYPE;
set STORAGE;
#
#####################
#    Parameters     #
#####################
#
########                        Global                                                 #############
#
param YearSplit{l in TIMESLICE, y in YEAR};
param DiscountRate{r in REGION};
param DaySplit{lh in DAILYTIMEBRACKET, y in YEAR};
param Conversionls{l in TIMESLICE, ls in SEASON};
param Conversionld{l in TIMESLICE, ld in DAYTYPE};
param Conversionlh{l in TIMESLICE, lh in DAILYTIMEBRACKET};
param DaysInDayType{ls in SEASON, ld in DAYTYPE, y in YEAR};
param TradeRoute{r in REGION, rr in REGION, f in FUEL, y in YEAR};
param DepreciationMethod{r in REGION};
#
########                        Demands                                         #############
#
param SpecifiedAnnualDemand{r in REGION, f in FUEL, y in YEAR};
param SpecifiedDemandProfile{r in REGION, f in FUEL, l in TIMESLICE, y in YEAR};
param AccumulatedAnnualDemand{r in REGION, f in FUEL, y in YEAR};
#
#########                        Performance                                        #############
#
param CapacityToActivityUnit{r in REGION, t in TECHNOLOGY};
param TechWithCapacityNeededToMeetPeakTS{r in REGION, t in TECHNOLOGY};
param CapacityFactor{r in REGION, t in TECHNOLOGY, l in TIMESLICE, y in YEAR};
param AvailabilityFactor{r in REGION, t in TECHNOLOGY, y in YEAR};
param OperationalLife{r in REGION, t in TECHNOLOGY};
param ResidualCapacity{r in REGION, t in TECHNOLOGY, y in YEAR};
param InputActivityRatio{r in REGION, t in TECHNOLOGY, l in TIMESLICE, f in FUEL, m in MODE_OF_OPERATION, y in YEAR}; # KPW on 11.05.2020: added timeslice dependence to model temperature-dependant heat pump efficiency
#param InputActivityRatio{r in REGION, t in TECHNOLOGY, f in FUEL, m in MODE_OF_OPERATION, y in YEAR};
param OutputActivityRatio{r in REGION, t in TECHNOLOGY, f in FUEL, m in MODE_OF_OPERATION, y in YEAR};
#
#########                        Technology Costs                        #############
#
param CapitalCost{r in REGION, t in TECHNOLOGY, y in YEAR};
param VariableCost{r in REGION, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR};
param FixedCost{r in REGION, t in TECHNOLOGY, y in YEAR};
#
#########                           Storage                                 #############
#
param TechnologyStorage{r in REGION, t in TECHNOLOGY, s in STORAGE, m in MODE_OF_OPERATION};
#param TechnologyToStorage{r in REGION, t in TECHNOLOGY, s in STORAGE, m in MODE_OF_OPERATION};
#param TechnologyFromStorage{r in REGION, t in TECHNOLOGY, s in STORAGE, m in MODE_OF_OPERATION};
#param StorageLevelStart{r in REGION, s in STORAGE};
param StorageMaxChargeRate{r in REGION, s in STORAGE};
param StorageMaxDischargeRate{r in REGION, s in STORAGE};
param MinStorageCharge{r in REGION, s in STORAGE, y in YEAR};
param OperationalLifeStorage{r in REGION, s in STORAGE};
param CapitalCostStorage{r in REGION, s in STORAGE, y in YEAR};
#param DiscountRateStorage{r in REGION, s in STORAGE}; deactivated as per OSeMOSYS_2017_11_08_Short original. Use DiscountRate instead
param ResidualStorageCapacity{r in REGION, s in STORAGE, y in YEAR};
# TN 2016 04 Added Storage Maximum:
var StorageLevelStart{r in REGION, s in STORAGE} >= 0;
param StorageMaxCapacity{r in REGION, s in STORAGE, y in YEAR};



#
#########                        Capacity Constraints                #############
#
param CapacityOfOneTechnologyUnit{r in REGION, t in TECHNOLOGY, y in YEAR};
param TotalAnnualMaxCapacity{r in REGION, t in TECHNOLOGY, y in YEAR};
param TotalAnnualMinCapacity{r in REGION, t in TECHNOLOGY, y in YEAR};
#
#########                        Investment Constraints                #############
#
param TotalAnnualMaxCapacityInvestment{r in REGION, t in TECHNOLOGY, y in YEAR};
param TotalAnnualMinCapacityInvestment{r in REGION, t in TECHNOLOGY, y in YEAR};
#
#########                        Activity Constraints                #############
#
param TotalTechnologyAnnualActivityUpperLimit{r in REGION, t in TECHNOLOGY, y in YEAR};
param TotalTechnologyAnnualActivityLowerLimit{r in REGION, t in TECHNOLOGY, y in YEAR};
param TotalTechnologyModelPeriodActivityUpperLimit{r in REGION, t in TECHNOLOGY};
param TotalTechnologyModelPeriodActivityLowerLimit{r in REGION, t in TECHNOLOGY};
#
#########                        Reserve Margin                                #############
#
param ReserveMarginTagTechnology{r in REGION, t in TECHNOLOGY, y in YEAR};
param ReserveMarginTagFuel{r in REGION, f in FUEL, y in YEAR};
param ReserveMargin{r in REGION, y in YEAR};
#
#########                        RE Generation Target                #############
#
param RETagTechnology{r in REGION, t in TECHNOLOGY, y in YEAR};
param RETagFuel{r in REGION, f in FUEL, y in YEAR};
param REMinProductionTarget{r in REGION, y in YEAR};
##### Synchronous Generation Parameters ############

#param SGTagFuel{r in REGION, f in FUEL, y in YEAR};
#param SGMinProductionTarget{r in REGION, y in YEAR};
#param SGTagTechnology{r in REGION, t in TECHNOLOGY, y in YEAR};													
#
#########                        Emissions & Penalties                #############
#
param EmissionActivityRatio{r in REGION, t in TECHNOLOGY, e in EMISSION, m in MODE_OF_OPERATION, y in YEAR};
param EmissionsPenalty{r in REGION, e in EMISSION, y in YEAR};
param AnnualExogenousEmission{r in REGION, e in EMISSION, y in YEAR};
param AnnualEmissionLimit{r in REGION, e in EMISSION, y in YEAR};
param ModelPeriodExogenousEmission{r in REGION, e in EMISSION};
param ModelPeriodEmissionLimit{r in REGION, e in EMISSION};
# Ramping
#param MaxRampingUp{r in REGION, t in TECHNOLOGY, Y in YEAR};
#param MaxRampingDown{r in REGION, t in TECHNOLOGY, Y in YEAR};															  
#
#
#########                        Land Area Impact & Land Cost                #############
#
#param LandAreaImpactCapacity{r in REGION, t in TECHNOLOGY};
#param LandAreaImpactEnergy{r in REGION, s in STORAGE};
#param LandCost{r in REGION};
#
#########                        Multithreading                #############
#these parameters are used to write the output file names from python when calling this script
#param SelectedResults, symbolic;
param SelRes, symbolic;

#########                   Simultaneity               ##############
#
param SimultaneityTagTechnology{r in REGION, t in TECHNOLOGY, f in FUEL, y in YEAR}; #dictates which technologies must jointly supply a fuel demand


######################
#   Model Variables  #
######################
#
########                        Demands                                         #############
#
#var RateOfDemand{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}>= 0;
#var Demand{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}>= 0;
#
########                     Storage                                 #############
#
var StorageLevelTSStart{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR} >=0;
var NewStorageCapacity{r in REGION, s in STORAGE, y in YEAR} >=0;
var SalvageValueStorage{r in REGION, s in STORAGE, y in YEAR} >=0;
var StorageLevelYearStart{r in REGION, s in STORAGE, y in YEAR} >=0;
var StorageLevelYearFinish{r in REGION, s in STORAGE, y in YEAR} >=0;
var StorageLevelSeasonStart{r in REGION, s in STORAGE, ls in SEASON, y in YEAR} >=0;
var StorageLevelDayTypeStart{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, y in YEAR} >=0;
var StorageLevelDayTypeFinish{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, y in YEAR} >=0;
#var RateOfStorageCharge{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR};
#var RateOfStorageDischarge{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR};
#var NetChargeWithinYear{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR};
#var NetChargeWithinDay{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR};
#var StorageLowerLimit{r in REGION, s in STORAGE, y in YEAR}>=0;
#var StorageUpperLimit{r in REGION, s in STORAGE, y in YEAR} >=0;
#var AccumulatedNewStorageCapacity{r in REGION, s in STORAGE, y in YEAR} >=0;
#var CapitalInvestmentStorage{r in REGION, s in STORAGE, y in YEAR} >=0;
#var DiscountedCapitalInvestmentStorage{r in REGION, s in STORAGE, y in YEAR} >=0;
#var DiscountedSalvageValueStorage{r in REGION, s in STORAGE, y in YEAR} >=0;
#var TotalDiscountedStorageCost{r in REGION, s in STORAGE, y in YEAR} >=0;
#
#########                    Capacity Variables                         #############
#
var NumberOfNewTechnologyUnits{r in REGION, t in TECHNOLOGY, y in YEAR} >= 0,integer;
var NewCapacity{r in REGION, t in TECHNOLOGY, y in YEAR} >= 0;
#var AccumulatedNewCapacity{r in REGION, t in TECHNOLOGY, y in YEAR} >= 0;
#var TotalCapacityAnnual{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#
#########                    Activity Variables                         #############
#
var RateOfActivity{r in REGION, l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR};#Eliminated the >=0 constraint (PMT)
var UseByTechnology{r in REGION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL, y in YEAR}>= 0;
var Trade{r in REGION, rr in REGION, l in TIMESLICE, f in FUEL, y in YEAR};
var UseAnnual{r in REGION, f in FUEL, y in YEAR}>= 0;
#var RateOfTotalActivity{r in REGION, t in TECHNOLOGY, l in TIMESLICE, y in YEAR} >= 0;
#var TotalTechnologyAnnualActivity{r in REGION, t in TECHNOLOGY, y in YEAR} >= 0;
#var TotalAnnualTechnologyActivityByMode{r in REGION, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR}>=0;
#var TotalTechnologyModelPeriodActivity{r in REGION, t in TECHNOLOGY};
#var RateOfProductionByTechnologyByMode{r in REGION, l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, f in FUEL, y in YEAR}>= 0;
#var RateOfProductionByTechnology{r in REGION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL, y in YEAR}>= 0;
#var ProductionByTechnology{r in REGION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL, y in YEAR}>= 0;
#var ProductionByTechnologyAnnual{r in REGION, t in TECHNOLOGY, f in FUEL, y in YEAR}>= 0;
#var RateOfProduction{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR} >= 0;
#var Production{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR} >= 0;
#var RateOfUseByTechnologyByMode{r in REGION, l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, f in FUEL, y in YEAR}>= 0;
#var RateOfUseByTechnology{r in REGION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL, y in YEAR} >= 0;
#var UseByTechnologyAnnual{r in REGION, t in TECHNOLOGY, f in FUEL, y in YEAR}>= 0;
#var RateOfUse{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}>= 0;
#var Use{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}>= 0;
#var TradeAnnual{r in REGION, rr in REGION, f in FUEL, y in YEAR};
#var ProductionAnnual{r in REGION, f in FUEL, y in YEAR}>= 0;
#
#########                    Costing Variables                         #############
#
#var CapitalInvestment{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
####var DiscountedCapitalInvestment{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#
var VariableOperatingCost{r in REGION, t in TECHNOLOGY, l in TIMESLICE, y in YEAR}>= 0;
var SalvageValue{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
var DiscountedSalvageValue{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
var OperatingCost{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#var DiscountedOperatingCost{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#var AnnualVariableOperatingCost{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#var AnnualFixedOperatingCost{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#var TotalDiscountedCostByTechnology{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#var TotalDiscountedCost{r in REGION, y in YEAR}>= 0;
#var ModelPeriodCostByRegion{r in REGION} >= 0;
#
#########                        Reserve Margin                                #############
#
#var TotalCapacityInReserveMargin{r in REGION, y in YEAR}>= 0;
#var DemandNeedingReserveMargin{r in REGION,l in TIMESLICE, y in YEAR}>= 0;
#
#########                        RE Gen Target                                #############
#
#var TotalREProductionAnnual{r in REGION, y in YEAR};
#var RETotalProductionOfTargetFuelAnnual{r in REGION, y in YEAR};
#
#########                        Emissions                                        #############
#
var DiscountedTechnologyEmissionsPenalty{r in REGION, t in TECHNOLOGY, y in YEAR}>=0;
var ModelPeriodEmissions{r in REGION, e in EMISSION}>=0;
#var AnnualTechnologyEmissionByMode{r in REGION, t in TECHNOLOGY, e in EMISSION, m in MODE_OF_OPERATION, y in YEAR}>= 0;
#var AnnualTechnologyEmission{r in REGION, t in TECHNOLOGY, e in EMISSION, y in YEAR}>= 0;
#var AnnualTechnologyEmissionPenaltyByEmission{r in REGION, t in TECHNOLOGY, e in EMISSION, y in YEAR}>= 0;
#var AnnualTechnologyEmissionsPenalty{r in REGION, t in TECHNOLOGY, y in YEAR}>= 0;
#var AnnualEmissions{r in REGION, e in EMISSION, y in YEAR}>= 0;
#
#table data IN "CSV" "data.csv": s <- [FROM,TO], d~DISTANCE, c~COST;
#table capacity IN "CSV" "SpecifiedAnnualDemand.csv": [YEAR, FUEL, REGION], SpecifiedAnnualDemand~ColumnNameInCSVSheet;
#


#######################
# Constraint Costs Variables and Parameters   #
#######################
param StoredEnergyValue{r in REGION, s in STORAGE};

# END CC Section #########

######################
# Objective Function #
######################
#
minimize cost: 
sum{r in REGION, t in TECHNOLOGY, y in YEAR} 
(
	(
		(
			#generator fixed costs
			(
				(
					sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} 
						NewCapacity[r,t,yy]
				)
				+ 
				ResidualCapacity[r,t,y]
			)
			*FixedCost[r,t,y]
			
			#generator variable cost
			+ sum{m in MODE_OF_OPERATION, l in TIMESLICE} 
				RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y]
		)
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
		
		#generator capital costs
		+CapitalCost[r,t,y] * NewCapacity[r,t,y]
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
		
		#generator emissions costs
		+DiscountedTechnologyEmissionsPenalty[r,t,y]
		
		#generator salvage value
		-DiscountedSalvageValue[r,t,y]
	) 
)
+ sum{r in REGION, s in STORAGE, y in YEAR} 
(
	#storage capital costs
	CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
	/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
			
	#storage salvage value
	-SalvageValueStorage[r,s,y]
	/((1+DiscountRate[r])^(max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)+1))
);
#
#####################
# Constraints       #
#####################
#

#s.t. EQ_SpecifiedDemand{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: SpecifiedAnnualDemand[r,f,y]*SpecifiedDemandProfile[r,f,l,y] / YearSplit[l,y]=RateOfDemand[r,l,f,y];
#
#########               Capacity Adequacy A                     #############
#
#s.t. CAa1_TotalNewCapacity{r in REGION, t in TECHNOLOGY, y in YEAR}:AccumulatedNewCapacity[r,t,y] = sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy];
#s.t. CAa2_TotalAnnualCapacity{r in REGION, t in TECHNOLOGY, y in YEAR}: ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) = TotalCapacityAnnual[r,t,y];
#s.t. CAa3_TotalActivityOfEachTechnology{r in REGION, t in TECHNOLOGY, l in TIMESLICE, y in YEAR}: sum{m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y] = RateOfTotalActivity[r,t,l,y];

s.t. CAa4_Constraint_Capacity{r in REGION, l in TIMESLICE, t in TECHNOLOGY, y in YEAR: TechWithCapacityNeededToMeetPeakTS[r,t]<>0}: 
	sum{m in MODE_OF_OPERATION} 
		RateOfActivity[r,l,t,m,y] 
		<= 
		((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])
		*CapacityFactor[r,t,l,y]
		*CapacityToActivityUnit[r,t];

#Taco added CAa4b_Constraint_Capacity to constrain the negative RateOfActivity of technologies connected to storage
s.t. CAa4b_Constraint_Capacity{r in REGION, l in TIMESLICE, t in TECHNOLOGY, y in YEAR: TechWithCapacityNeededToMeetPeakTS[r,t]<>0}: sum{m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y] >= (-1)*((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*CapacityFactor[r,t,l,y]*CapacityToActivityUnit[r,t];

s.t. CAa5_TotalNewCapacity{r in REGION, t in TECHNOLOGY, y in YEAR: CapacityOfOneTechnologyUnit[r,t,y]<>0}: CapacityOfOneTechnologyUnit[r,t,y]*NumberOfNewTechnologyUnits[r,t,y] = NewCapacity[r,t,y];
#
# Note that the PlannedMaintenance equation below ensures that all other technologies have a capacity great enough to at least meet the annual average.
#
#########               Capacity Adequacy B                         #############
#
s.t. CAb1_PlannedMaintenance{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{l in TIMESLICE} sum{m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] <= sum{l in TIMESLICE} (((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*CapacityFactor[r,t,l,y]*YearSplit[l,y])* AvailabilityFactor[r,t,y]*CapacityToActivityUnit[r,t];
s.t. CAb1_PlannedMaintenance_Negative{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{l in TIMESLICE} sum{m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= sum{l in TIMESLICE} (-1)*(((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*CapacityFactor[r,t,l,y]*YearSplit[l,y])* AvailabilityFactor[r,t,y]*CapacityToActivityUnit[r,t];

#########                Energy Balance A                     #############
#
#s.t. EBa1_RateOfFuelProduction1{r in REGION, l in TIMESLICE, f in FUEL, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR: OutputActivityRatio[r,t,f,m,y] <>0}:  RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]  = RateOfProductionByTechnologyByMode[r,l,t,m,f,y];
#s.t. EBa2_RateOfFuelProduction2{r in REGION, l in TIMESLICE, f in FUEL, t in TECHNOLOGY, y in YEAR}: sum{m in MODE_OF_OPERATION: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] = RateOfProductionByTechnology[r,l,t,f,y] ;
#s.t. EBa3_RateOfFuelProduction3{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]  =  RateOfProduction[r,l,f,y];
#s.t. EBa4_RateOfFuelUse1{r in REGION, l in TIMESLICE, f in FUEL, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR: InputActivityRatio[r,t,f,m,y]<>0}: RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]  = RateOfUseByTechnologyByMode[r,l,t,m,f,y];
#s.t. EBa5_RateOfFuelUse2{r in REGION, l in TIMESLICE, f in FUEL, t in TECHNOLOGY, y in YEAR}: sum{m in MODE_OF_OPERATION: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y] = RateOfUseByTechnology[r,l,t,f,y];
#s.t. EBa6_RateOfFuelUse3{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]  = RateOfUse[r,l,f,y];
#s.t. EBa7_EnergyBalanceEachTS1{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y] = Production[r,l,f,y];
#s.t. EBa8_EnergyBalanceEachTS2{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]*YearSplit[l,y] = Use[r,l,f,y];
#s.t. EBa9_EnergyBalanceEachTS3{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: SpecifiedAnnualDemand[r,f,y]*SpecifiedDemandProfile[r,f,l,y] = Demand[r,l,f,y];
s.t. EBa10_EnergyBalanceEachTS4{r in REGION, rr in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: Trade[r,rr,l,f,y] = -Trade[rr,r,l,f,y];

#KPW on 11.05.2020: added timeslice dependance to InputActivityRatio
s.t. EBa11_EnergyBalanceEachTS5{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y] >= SpecifiedAnnualDemand[r,f,y]*SpecifiedDemandProfile[r,f,l,y] + sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: InputActivityRatio[r,t,l,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,l,f,m,y]*YearSplit[l,y] + sum{rr in REGION} Trade[r,rr,l,f,y]*TradeRoute[r,rr,f,y];
#s.t. EBa11_EnergyBalanceEachTS5{r in REGION, l in TIMESLICE, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y] >= SpecifiedAnnualDemand[r,f,y]*SpecifiedDemandProfile[r,f,l,y] + sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]*YearSplit[l,y] + sum{rr in REGION} Trade[r,rr,l,f,y]*TradeRoute[r,rr,f,y];

#
#########                Energy Balance B                         #############
#
#s.t. EBb1_EnergyBalanceEachYear1{r in REGION, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, l in TIMESLICE: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y] = ProductionAnnual[r,f,y];
#s.t. EBb2_EnergyBalanceEachYear2{r in REGION, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, l in TIMESLICE: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]*YearSplit[l,y] = UseAnnual[r,f,y];
#s.t. EBb3_EnergyBalanceEachYear3{r in REGION, rr in REGION, f in FUEL, y in YEAR}: sum{l in TIMESLICE} Trade[r,rr,l,f,y] = TradeAnnual[r,rr,f,y];
s.t. EBb4_EnergyBalanceEachYear4{r in REGION, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, l in TIMESLICE: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y] >= sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, l in TIMESLICE: InputActivityRatio[r,t,l,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,l,f,m,y]*YearSplit[l,y] + sum{l in TIMESLICE, rr in REGION} Trade[r,rr,l,f,y]*TradeRoute[r,rr,f,y] + AccumulatedAnnualDemand[r,f,y];
#KPW on 11.05.2020: added timeslice dependance to InputActivityRatio
#s.t. EBb4_EnergyBalanceEachYear4{r in REGION, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, l in TIMESLICE: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y] >= sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, l in TIMESLICE: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]*YearSplit[l,y] + sum{l in TIMESLICE, rr in REGION} Trade[r,rr,l,f,y]*TradeRoute[r,rr,f,y] + AccumulatedAnnualDemand[r,f,y];
#
#########                Accounting Technology Production/Use        #############
#
#s.t. Acc1_FuelProductionByTechnology{r in REGION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * YearSplit[l,y] = ProductionByTechnology[r,l,t,f,y];
#s.t. Acc2_FuelUseByTechnology{r in REGION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y] * YearSplit[l,y] = UseByTechnology[r,l,t,f,y];
#s.t. Acc3_AverageAnnualRateOfActivity{r in REGION, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR}: sum{l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] = TotalAnnualTechnologyActivityByMode[r,t,m,y];
####s.t. Acc4_ModelPeriodCostByRegion{r in REGION}:sum{t in TECHNOLOGY, y in YEAR}(((((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y] + sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))+CapitalCost[r,t,y] * NewCapacity[r,t,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))+DiscountedTechnologyEmissionsPenalty[r,t,y]-DiscountedSalvageValue[r,t,y]) + sum{s in STORAGE} (CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))-CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy))))) = ModelPeriodCostByRegion[r];
#
#########                Storage Equations                        #############
#
# TN 2017 02 Replaced full storage equations with a simpler version, assuming all Tslices are sequential.


#var StorageLevelTSStart(r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR} >=0;

s.t. S1_StorageLevelYearStart{r in REGION, s in STORAGE, y in YEAR}: if y = min{yy in YEAR} min(yy) then StorageLevelStart[r,s]
	else StorageLevelYearStart[r,s,y-1] + (-1)*(sum{l in TIMESLICE} (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} (RateOfActivity[r,l,t,m,y-1] * TechnologyStorage[r,t,s,m])) * YearSplit[l,y-1])
	= StorageLevelYearStart[r,s,y];


s.t. S2_StorageLevelTSStart{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}: if l = min{ll in TIMESLICE} min(ll) then StorageLevelYearStart[r,s,y] 
	else StorageLevelTSStart[r,s,l-1,y] + (-1)*(((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,l-1,t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[l-1,y])
	= StorageLevelTSStart[r,s,l,y];

s.t. SC8_StorageRefilling{s in STORAGE, r in REGION}: sum{y in YEAR, l in TIMESLICE}  (-1)*(sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} (RateOfActivity[r,l,t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[l,y] = 0;

s.t. SC9_StopModeLeakage{r in REGION, l in TIMESLICE, y in YEAR,m in MODE_OF_OPERATION,t in TECHNOLOGY, s in STORAGE: TechnologyStorage[r,t,s,1] == 1 && m != min{mm in MODE_OF_OPERATION} min(mm)}: RateOfActivity[r,l,t,m,y]=0;
# TN 2019 03 14 Changed this constraint so technologies tagged in mode 1 are restricted in all modes...



#PMT New constraint to deal with storage technologies; Date: November 8th, 2018
#Fixed by KPW on 2019-03-14 to enable multiple storage technologies.
s.t. NonStorageConstraint{r in REGION, l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR}: if sum{s in STORAGE} TechnologyStorage[r,t,s,m] == 0 then RateOfActivity[r,l,t,m,y] >=0;

#KPW original OSeMOSYS storageequations
#s.t. S1_RateOfStorageCharge{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] = RateOfStorageCharge[r,s,ls,ld,lh,y];
#s.t. S2_RateOfStorageDischarge{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] = RateOfStorageDischarge[r,s,ls,ld,lh,y];
#s.t. S3_NetChargeWithinYear{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: sum{l in TIMESLICE:Conversionls[l,ls]>0&&Conversionld[l,ld]>0&&Conversionlh[l,lh]>0}  (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyToStorage[r,t,s,m]>0} (RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh])) * YearSplit[l,y] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] = NetChargeWithinYear[r,s,ls,ld,lh,y];
#s.t. S4_NetChargeWithinDay{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: ((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh])) * DaySplit[lh,y] = NetChargeWithinDay[r,s,ls,ld,lh,y];
#s.t. S5_and_S6_StorageLevelYearStart{r in REGION, s in STORAGE, y in YEAR}: if y = min{yy in YEAR} min(yy) then StorageLevelStart[r,s]
#                                                                                                                                        else StorageLevelYearStart[r,s,y-1] + sum{ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET} sum{l in TIMESLICE:Conversionls[l,ls]>0&&Conversionld[l,ld]>0&&Conversionlh[l,lh]>0}  (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyToStorage[r,t,s,m]>0} (RateOfActivity[r,l,t,m,y-1] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y-1] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh])) * YearSplit[l,y-1] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh]
#                                                                                                                                        = StorageLevelYearStart[r,s,y];
#s.t. S7_and_S8_StorageLevelYearFinish{r in REGION, s in STORAGE, y in YEAR}: if y < max{yy in YEAR} max(yy) then StorageLevelYearStart[r,s,y+1]
#                                                                                                                                        else StorageLevelYearStart[r,s,y] + sum{ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET} sum{l in TIMESLICE:Conversionls[l,ls]>0&&Conversionld[l,ld]>0&&Conversionlh[l,lh]>0}  (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyToStorage[r,t,s,m]>0} (RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh])) * YearSplit[l,y] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh]
#                                                                                                                                        = StorageLevelYearFinish[r,s,y];
#s.t. S9_and_S10_StorageLevelSeasonStart{r in REGION, s in STORAGE, ls in SEASON, y in YEAR}: if ls = min{lsls in SEASON} min(lsls) then StorageLevelYearStart[r,s,y]
#                                                                                                                                        else StorageLevelSeasonStart[r,s,ls-1,y] + sum{ld in DAYTYPE, lh in DAILYTIMEBRACKET} sum{l in TIMESLICE:Conversionls[l,ls-1]>0&&Conversionld[l,ld]>0&&Conversionlh[l,lh]>0}  (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyToStorage[r,t,s,m]>0} (RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls-1] * Conversionld[l,ld] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls-1] * Conversionld[l,ld] * Conversionlh[l,lh])) * YearSplit[l,y] * Conversionls[l,ls-1] * Conversionld[l,ld] * Conversionlh[l,lh]
#                                                                                                                                        = StorageLevelSeasonStart[r,s,ls,y];
#s.t. S11_and_S12_StorageLevelDayTypeStart{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, y in YEAR}: if ld = min{ldld in DAYTYPE} min(ldld) then StorageLevelSeasonStart[r,s,ls,y]
#                                                                                                                                        else StorageLevelDayTypeStart[r,s,ls,ld-1,y] + sum{lh in DAILYTIMEBRACKET} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld-1] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld-1] * Conversionlh[l,lh])) * DaySplit[lh,y]) * DaysInDayType[ls,ld-1,y]
#                                                                                                                                        = StorageLevelDayTypeStart[r,s,ls,ld,y];
#s.t. S13_and_S14_and_S15_StorageLevelDayTypeFinish{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, y in YEAR}:        if ls = max{lsls in SEASON} max(lsls) && ld = max{ldld in DAYTYPE} max(ldld) then StorageLevelYearFinish[r,s,y]
#                                                                                                                                        else if ld = max{ldld in DAYTYPE} max(ldld) then StorageLevelSeasonStart[r,s,ls+1,y]
#                                                                                                                                        else StorageLevelDayTypeFinish[r,s,ls,ld+1,y] - sum{lh in DAILYTIMEBRACKET} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld+1] * Conversionlh[l,lh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld+1] * Conversionlh[l,lh])) * DaySplit[lh,y]) * DaysInDayType[ls,ld+1,y]
#                                                                                                                                        = StorageLevelDayTypeFinish[r,s,ls,ld,y];																																		
#end of original OSeMOSYS storage equations

#
##########                Storage Constraints                                #############
#
#THe following storage constraints are taken from Taco. Original constraints are commented out below
s.t. SC1_LowerLimit{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}:  MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= StorageLevelTSStart[r,s,l,y];
					

# TN April 2018 Put limit on final level of storage to restrict crazy charging and discharging in last timeslice...
s.t. SC1a_LowerLimitEndofModelPeriod{s in STORAGE, y in YEAR, r in REGION}: MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= (StorageLevelTSStart[r,s,max{ll in TIMESLICE} max(ll),y] + (-1)*(((sum{m in MODE_OF_OPERATION, t in TECHNOLOGY:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,max{ll in TIMESLICE} max(ll),t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[max{ll in TIMESLICE} max(ll),y]));

#Tacos old faulty SC1a_LowerLimitEndofModelPeriod
#s.t. SC1a_LowerLimitEndofModelPeriod{s in STORAGE, y in YEAR, r in REGION}: MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= (StorageLevelTSStart[r,s,max{ll in TIMESLICE} max(ll),y] + (((sum{m in MODE_OF_OPERATION, t in TECHNOLOGY:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,max{ll in TIMESLICE} max(ll),t,m,y] * TechnologyStorage[r,t,s,m]))));

#Should be ok since negative means from storage and positive means to storage, therefore conveying the same meaning as the original
#Problematic.. since i cant bound within positive and negative region at same time... PMT November 29th, 2018
#NewStorageCapacity is optimized to be nonZero..... PMT
#Crisis adverted MinStorageCharge is Zero.
### PMT REMOVED LOWER LIMIT NEED TO TALK WITH TACO ABOUT THIS
#Since FromStorage is represented by negative RoA of tDAM should this constraint be now designed around

s.t. SC2_UpperLimit{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}:  StorageLevelTSStart[r,s,l,y] <= (sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
																																											

# TN April 2018 Put limit on final level of storage to restrict crazy charging and discharging in last timeslice...
s.t. SC2a_UpperLimitEndofModelPeriod{s in STORAGE, y in YEAR, r in REGION}: (StorageLevelTSStart[r,s,max{ll in TIMESLICE} max(ll),y] + (-1)*(((sum{m in MODE_OF_OPERATION, t in TECHNOLOGY:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,max{ll in TIMESLICE} max(ll),t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[max{ll in TIMESLICE} max(ll),y])) <= (sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
#Tacos old faulty SC2a_UpperLimitEndofModelPeriod
#s.t. SC2a_UpperLimitEndofModelPeriod{s in STORAGE, y in YEAR, r in REGION}: (StorageLevelTSStart[r,s,max{ll in TIMESLICE} max(ll),y] + (((sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,max{ll in TIMESLICE} max(ll),t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[max{ll in TIMESLICE} max(ll),y])) <= (sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
																																																											 

#PMT implemented TechnologyStorage param; Date: November 8th, 2018
# This is probably redundant, I think (TN 2018 12 18)
s.t. SC2a_UpperLimitEndofModelPeriod_Negative{s in STORAGE, y in YEAR, r in REGION}: (StorageLevelTSStart[r,s,max{ll in TIMESLICE} max(ll),y] + (-1)*(((sum{m in MODE_OF_OPERATION, t in TECHNOLOGY:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,max{ll in TIMESLICE} max(ll),t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[max{ll in TIMESLICE} max(ll),y])) >= (-1)*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);

#Tacos old faulty SC2a_UpperLimitEndofModelPeriod_Negative
#s.t. SC2a_UpperLimitEndofModelPeriod_Negative{s in STORAGE, y in YEAR, r in REGION}: (StorageLevelTSStart[r,s,max{ll in TIMESLICE} max(ll),y] + (((sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,max{ll in TIMESLICE} max(ll),t,m,y] * TechnologyStorage[r,t,s,m])) * YearSplit[max{ll in TIMESLICE} max(ll),y])) >= -(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);

#KPW: This constraint causes stability issues with idle storage technologies. The constraints are unneccessary in our model and have since been deavtivated
#Added this constraint to combat the addition of negatives problem
#s.t. SC9b_StorageChargeRateIn{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}: (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyStorage[r,t,s,m]) >= (-1)*StorageMaxChargeRate[r,s];
#s.t. SC9c_StorageChargeRateOut{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}: (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyStorage[r,t,s,m]) <= StorageMaxDischargeRate[r,s];



#Tacos old faulty SC9b_StorageChargeRateIn and SC9c_StorageChargeRateOut
#s.t. SC9b_StorageChargeRateIn{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}: (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyStorage[r,t,s,m]) <= StorageMaxChargeRate[r,s];
#s.t. SC9c_StorageChargeRateOut{r in REGION, s in STORAGE, l in TIMESLICE, y in YEAR}: (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION:TechnologyStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyStorage[r,t,s,m]) >= (-1)*StorageMaxDischargeRate[r,s];
#PMT implemented TechnologyStorage param and made the negative bound; Date: November 8th, 2018 (This implies that from storage is now negative, since discharge is negatively bound)

# TN Max Storage Size from Storage Work...  Added 2016 04 04
s.t. SC7_StorageMaxUpperLimit{s in STORAGE, y in YEAR, r in REGION}:  (sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= StorageMaxCapacity[r, s, y];
																																																																						 
/*	KPW original OSeMOSYS Storage Constraints																																			
#s.t. SC1_LowerLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: 0 <= (StorageLevelDayTypeStart[r,s,ls,ld,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
#s.t. SC1_UpperLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: (StorageLevelDayTypeStart[r,s,ls,ld,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= 0;
#s.t. SC2_LowerLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: 0 <= if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeStart[r,s,ls,ld,y]-sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld-1] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld-1] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
#s.t. SC2_UpperLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInFirstWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeStart[r,s,ls,ld,y]-sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld-1] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld-1] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= 0;
#s.t. SC3_LowerLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}:  0 <= (StorageLevelDayTypeFinish[r,s,ls,ld,y] - sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
#s.t. SC3_UpperLimit_EndOfDailyTimeBracketOfLastInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}:  (StorageLevelDayTypeFinish[r,s,ls,ld,y] - sum{lhlh in DAILYTIMEBRACKET:lh-lhlh<0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= 0;
#s.t. SC4_LowerLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}:         0 <= if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeFinish[r,s,ls,ld-1,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]);
#s.t. SC4_UpperLimit_BeginningOfDailyTimeBracketOfFirstInstanceOfDayTypeInLastWeekConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: if ld > min{ldld in DAYTYPE} min(ldld) then (StorageLevelDayTypeFinish[r,s,ls,ld-1,y]+sum{lhlh in DAILYTIMEBRACKET:lh-lhlh>0} (((sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh]) - (sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lhlh])) * DaySplit[lhlh,y]))-(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) <= 0;

#s.t. SC5_MaxChargeConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyToStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyToStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] <= StorageMaxChargeRate[r,s];
#s.t. SC6_MaxDischargeConstraint{r in REGION, s in STORAGE, ls in SEASON, ld in DAYTYPE, lh in DAILYTIMEBRACKET, y in YEAR}: sum{t in TECHNOLOGY, m in MODE_OF_OPERATION, l in TIMESLICE:TechnologyFromStorage[r,t,s,m]>0} RateOfActivity[r,l,t,m,y] * TechnologyFromStorage[r,t,s,m] * Conversionls[l,ls] * Conversionld[l,ld] * Conversionlh[l,lh] <= StorageMaxDischargeRate[r,s];
#end of original OSeMOSYS Storage Constraints
*/
#
#########                Storage Investments                                #############
#
s.t. SI6_SalvageValueStorageAtEndOfPeriod1{r in REGION, s in STORAGE, y in YEAR: (y+OperationalLifeStorage[r,s]-1) <= (max{yy in YEAR} max(yy))}: 0 = SalvageValueStorage[r,s,y];
s.t. SI7_SalvageValueStorageAtEndOfPeriod2{r in REGION, s in STORAGE, y in YEAR: (DepreciationMethod[r]=1 && (y+OperationalLifeStorage[r,s]-1) > (max{yy in YEAR} max(yy)) && DiscountRate[r]=0) || (DepreciationMethod[r]=2 && (y+OperationalLifeStorage[r,s]-1) > (max{yy in YEAR} max(yy)))}: CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]*(1-(max{yy in YEAR} max(yy) - y+1)/OperationalLifeStorage[r,s]) = SalvageValueStorage[r,s,y];
s.t. SI8_SalvageValueStorageAtEndOfPeriod3{r in REGION, s in STORAGE, y in YEAR: DepreciationMethod[r]=1 && (y+OperationalLifeStorage[r,s]-1) > (max{yy in YEAR} max(yy)) && DiscountRate[r]>0}: CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]*(1-(((1+DiscountRate[r])^(max{yy in YEAR} max(yy) - y+1)-1)/((1+DiscountRate[r])^OperationalLifeStorage[r,s]-1))) = SalvageValueStorage[r,s,y];
#s.t. SI1_StorageUpperLimit{r in REGION, s in STORAGE, y in YEAR}: sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y] = StorageUpperLimit[r,s,y];
#s.t. SI2_StorageLowerLimit{r in REGION, s in STORAGE, y in YEAR}: MinStorageCharge[r,s,y]*(sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]+ResidualStorageCapacity[r,s,y]) = StorageLowerLimit[r,s,y];
#s.t. SI3_TotalNewStorage{r in REGION, s in STORAGE, y in YEAR}: sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy]=AccumulatedNewStorageCapacity[r,s,y];
#s.t. SI4_UndiscountedCapitalInvestmentStorage{r in REGION, s in STORAGE, y in YEAR}: CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y] = CapitalInvestmentStorage[r,s,y];
#s.t. SI5_DiscountingCapitalInvestmentStorage{r in REGION, s in STORAGE, y in YEAR}: CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy))) = DiscountedCapitalInvestmentStorage[r,s,y];
#s.t. SI9_SalvageValueStorageDiscountedToStartYear{r in REGION, s in STORAGE, y in YEAR}: SalvageValueStorage[r,s,y]/((1+DiscountRate[r])^(max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)+1)) = DiscountedSalvageValueStorage[r,s,y];
#s.t. SI10_TotalDiscountedCostByStorage{r in REGION, s in STORAGE, y in YEAR}: (CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))-CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))) = TotalDiscountedStorageCost[r,s,y];
#
#########               Capital Costs                              #############
#
#s.t. CC1_UndiscountedCapitalInvestment{r in REGION, t in TECHNOLOGY, y in YEAR}: CapitalCost[r,t,y] * NewCapacity[r,t,y] = CapitalInvestment[r,t,y];
####s.t. CC2_DiscountingCapitalInvestment{r in REGION, t in TECHNOLOGY, y in YEAR}: CapitalCost[r,t,y] * NewCapacity[r,t,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy))) = DiscountedCapitalInvestment[r,t,y];
#
#########           Salvage Value                    #############
#
s.t. SV1_SalvageValueAtEndOfPeriod1{r in REGION, t in TECHNOLOGY, y in YEAR: DepreciationMethod[r]=1 && (y + OperationalLife[r,t]-1) > (max{yy in YEAR} max(yy)) && DiscountRate[r]>0}: SalvageValue[r,t,y] = CapitalCost[r,t,y]*NewCapacity[r,t,y]*(1-(((1+DiscountRate[r])^(max{yy in YEAR} max(yy) - y+1)-1)/((1+DiscountRate[r])^OperationalLife[r,t]-1)));
s.t. SV2_SalvageValueAtEndOfPeriod2{r in REGION, t in TECHNOLOGY, y in YEAR: DepreciationMethod[r]=1 && (y + OperationalLife[r,t]-1) > (max{yy in YEAR} max(yy)) && DiscountRate[r]=0 || (DepreciationMethod[r]=2 && (y + OperationalLife[r,t]-1) > (max{yy in YEAR} max(yy)))}: SalvageValue[r,t,y] = CapitalCost[r,t,y]*NewCapacity[r,t,y]*(1-(max{yy in YEAR} max(yy) - y+1)/OperationalLife[r,t]);
s.t. SV3_SalvageValueAtEndOfPeriod3{r in REGION, t in TECHNOLOGY, y in YEAR: (y + OperationalLife[r,t]-1) <= (max{yy in YEAR} max(yy))}: SalvageValue[r,t,y] = 0;
s.t. SV4_SalvageValueDiscountedToStartYear{r in REGION, t in TECHNOLOGY, y in YEAR}: DiscountedSalvageValue[r,t,y] = SalvageValue[r,t,y]/((1+DiscountRate[r])^(1+max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)));
#
#########                Operating Costs                          #############
#
#s.t. OC1_OperatingCostsVariable{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y] = AnnualVariableOperatingCost[r,t,y];
#s.t. OC2_OperatingCostsFixedAnnual{r in REGION, t in TECHNOLOGY, y in YEAR}: ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y] = AnnualFixedOperatingCost[r,t,y];
#s.t. OC3_OperatingCostsTotalAnnual{r in REGION, t in TECHNOLOGY, y in YEAR}: (((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y] + sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y]) = OperatingCost[r,t,y];
####s.t. OC4_DiscountedOperatingCostsTotalAnnual{r in REGION, t in TECHNOLOGY, y in YEAR}: (((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y] + sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5)) = DiscountedOperatingCost[r,t,y];
#
#########               Total Discounted Costs                 #############
#
#s.t. TDC1_TotalDiscountedCostByTechnology{r in REGION, t in TECHNOLOGY, y in YEAR}: ((((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y] + sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))+CapitalCost[r,t,y] * NewCapacity[r,t,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))+DiscountedTechnologyEmissionsPenalty[r,t,y]-DiscountedSalvageValue[r,t,y]) = TotalDiscountedCostByTechnology[r,t,y];
####s.t. TDC2_TotalDiscountedCost{r in REGION, y in YEAR}: sum{t in TECHNOLOGY}((((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y] + sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))+CapitalCost[r,t,y] * NewCapacity[r,t,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))+DiscountedTechnologyEmissionsPenalty[r,t,y]-DiscountedSalvageValue[r,t,y]) + sum{s in STORAGE} (CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))-CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))) = TotalDiscountedCost[r,y];
#
#########                      Total Capacity Constraints         ##############
#
s.t. TCC1_TotalAnnualMaxCapacityConstraint{r in REGION, t in TECHNOLOGY, y in YEAR}: ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) <= TotalAnnualMaxCapacity[r,t,y];
s.t. TCC2_TotalAnnualMinCapacityConstraint{r in REGION, t in TECHNOLOGY, y in YEAR: TotalAnnualMinCapacity[r,t,y]>0}: ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) >= TotalAnnualMinCapacity[r,t,y];
#
#########                    New Capacity Constraints          ##############
#
s.t. NCC1_TotalAnnualMaxNewCapacityConstraint{r in REGION, t in TECHNOLOGY, y in YEAR}: NewCapacity[r,t,y] <= TotalAnnualMaxCapacityInvestment[r,t,y];
s.t. NCC2_TotalAnnualMinNewCapacityConstraint{r in REGION, t in TECHNOLOGY, y in YEAR: TotalAnnualMinCapacityInvestment[r,t,y]>0}: NewCapacity[r,t,y] >= TotalAnnualMinCapacityInvestment[r,t,y];
#
#########                   Annual Activity Constraints        ##############
#
s.t. AAC2_TotalAnnualTechnologyActivityUpperLimit{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{l in TIMESLICE, m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] <= TotalTechnologyAnnualActivityUpperLimit[r,t,y] ;

#deactivated AAC2_TotalAnnualTechnologyActivityUpperLimit_Negative in accordance with Tacos version 2 to fix old faulty code
#s.t. AAC2_TotalAnnualTechnologyActivityUpperLimit_Negative{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{l in TIMESLICE, m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= -TotalTechnologyAnnualActivityUpperLimit[r,t,y] ;
##KPW added the above constraint from Tacos model. He wrote: PMT add code to deal with negative ,November 29th, 2018, still positive and negative interaction can happen...

s.t. AAC3_TotalAnnualTechnologyActivityLowerLimit{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{l in TIMESLICE, m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= TotalTechnologyAnnualActivityLowerLimit[r,t,y] ;
#Tacos old faulty AAC3_TotalAnnualTechnologyActivityLowerLimit
#s.t. AAC3_TotalAnnualTechnologyActivityLowerLimit{r in REGION, t in TECHNOLOGY, y in YEAR: TotalTechnologyAnnualActivityLowerLimit[r,t,y]>0}: sum{l in TIMESLICE, m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= TotalTechnologyAnnualActivityLowerLimit[r,t,y] ;
#s.t. AAC1_TotalAnnualTechnologyActivity{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{l in TIMESLICE, m in MODE_OF_OPERATION} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] = TotalTechnologyAnnualActivity[r,t,y];
#
#########                    Total Activity Constraints         ##############
#
#TAC2_TotalModelHorizonTechnologyActivityUpperLimit below is from Victors model. It is slightly different from Tacos model, which is activated two lines below
#s.t. TAC2_TotalModelHorizonTechnologyActivityUpperLimit{r in REGION, t in TECHNOLOGY: TotalTechnologyModelPeriodActivityUpperLimit[r,t]>0}: sum{l in TIMESLICE, m in MODE_OF_OPERATION, y in YEAR} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] <= TotalTechnologyModelPeriodActivityUpperLimit[r,t] ;
s.t. TAC2_TotalModelHorizonTechnologyActivityUpperLimit{r in REGION, t in TECHNOLOGY}: sum{l in TIMESLICE, m in MODE_OF_OPERATION, y in YEAR} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] <= TotalTechnologyModelPeriodActivityUpperLimit[r,t] ;

#Removed TotalModelHorizonTechnologyActivityUpperLimit_Negative in accordance with Tacos updated storage equation (Tacos old faulty model)
#s.t. TAC2_TotalModelHorizonTechnologyActivityUpperLimit_Negative{r in REGION, t in TECHNOLOGY}: sum{l in TIMESLICE, m in MODE_OF_OPERATION, y in YEAR} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= -TotalTechnologyModelPeriodActivityUpperLimit[r,t] ;
##KPW added the above constraint from Tacos model. He wrote: Redundant but may aid in ensuring we can get the same solution between models PMT, November 29th, 2018

s.t. TAC3_TotalModelHorizenTechnologyActivityLowerLimit{r in REGION, t in TECHNOLOGY}: sum{l in TIMESLICE, m in MODE_OF_OPERATION, y in YEAR} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= TotalTechnologyModelPeriodActivityLowerLimit[r,t] ;
#Tacos old faulty TotalModelHorizenTechnologyActivityLowerLimit
#s.t. TAC3_TotalModelHorizenTechnologyActivityLowerLimit{r in REGION, t in TECHNOLOGY: TotalTechnologyModelPeriodActivityLowerLimit[r,t]>0}: sum{l in TIMESLICE, m in MODE_OF_OPERATION, y in YEAR} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >= TotalTechnologyModelPeriodActivityLowerLimit[r,t] ;

#s.t. TAC1_TotalModelHorizonTechnologyActivity{r in REGION, t in TECHNOLOGY}: sum{l in TIMESLICE, m in MODE_OF_OPERATION, y in YEAR} RateOfActivity[r,l,t,m,y]*YearSplit[l,y] = TotalTechnologyModelPeriodActivity[r,t];
#
#########                   Reserve Margin Constraint        ############## NTS: Should change demand for production
#
s.t. RM3_ReserveMargin_Constraint{r in REGION, l in TIMESLICE, y in YEAR}: sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, f in FUEL: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * ReserveMarginTagFuel[r,f,y] * ReserveMargin[r,y]<= sum {t in TECHNOLOGY} ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) * ReserveMarginTagTechnology[r,t,y] * CapacityToActivityUnit[r,t];
#s.t. RM1_ReserveMargin_TechnologiesIncluded_In_Activity_Units{r in REGION, l in TIMESLICE, y in YEAR}: sum {t in TECHNOLOGY} ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) * ReserveMarginTagTechnology[r,t,y] * CapacityToActivityUnit[r,t]         =         TotalCapacityInReserveMargin[r,y];
#s.t. RM2_ReserveMargin_FuelsIncluded{r in REGION, l in TIMESLICE, y in YEAR}:  sum{m in MODE_OF_OPERATION, t in TECHNOLOGY, f in FUEL: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * ReserveMarginTagFuel[r,f,y] = DemandNeedingReserveMargin[r,l,y];
#
#########                   RE Production Target                ############## NTS: Should change demand for production
#
#KPW The constraint below might be the old and broken RE production target. I think Victor or Taco fixed the problem, but I dont know which constraint is the correct one 
#Never mind, the constraint is correct. KPW on 19.05.2020
s.t. RE4_EnergyConstraint{r in REGION, y in YEAR}:REMinProductionTarget[r,y]*sum{l in TIMESLICE, f in FUEL} sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]* YearSplit[l,y]*RETagFuel[r,f,y] <= sum{m in MODE_OF_OPERATION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * YearSplit[l,y]*RETagTechnology[r,t,y];
#s.t. RE1_FuelProductionByTechnologyAnnual{r in REGION, t in TECHNOLOGY, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, l in TIMESLICE: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * YearSplit[l,y] = ProductionByTechnologyAnnual[r,t,f,y];
#s.t. RE2_TechIncluded{r in REGION, y in YEAR}: sum{m in MODE_OF_OPERATION, l in TIMESLICE, t in TECHNOLOGY, f in FUEL: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * YearSplit[l,y]*RETagTechnology[r,t,y] = TotalREProductionAnnual[r,y];
#s.t. RE3_FuelIncluded{r in REGION, y in YEAR}: sum{l in TIMESLICE, f in FUEL} sum{m in MODE_OF_OPERATION, t in TECHNOLOGY: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*RETagFuel[r,f,y] = RETotalProductionOfTargetFuelAnnual[r,y];
#s.t. RE5_FuelUseByTechnologyAnnual{r in REGION, t in TECHNOLOGY, f in FUEL, y in YEAR}: sum{m in MODE_OF_OPERATION, l in TIMESLICE: InputActivityRatio[r,t,f,m,y]<>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,f,m,y]*YearSplit[l,y] = UseByTechnologyAnnual[r,t,f,y];
#
#########                   Emissions Accounting                ##############
#
s.t. E5_DiscountedEmissionsPenaltyByTechnology{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{e in EMISSION, l in TIMESLICE, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*EmissionsPenalty[r,e,y]/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5)) = DiscountedTechnologyEmissionsPenalty[r,t,y];
s.t. E8_AnnualEmissionsLimit{r in REGION, e in EMISSION, y in YEAR}: sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]+AnnualExogenousEmission[r,e,y] <= AnnualEmissionLimit[r,e,y];
s.t. E9_ModelPeriodEmissionsLimit{r in REGION, e in EMISSION}:  sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] + ModelPeriodExogenousEmission[r,e] <= ModelPeriodEmissionLimit[r,e] ;
#s.t. E1_AnnualEmissionProductionByMode{r in REGION, t in TECHNOLOGY, e in EMISSION, m in MODE_OF_OPERATION, y in YEAR}: EmissionActivityRatio[r,t,e,m,y]*sum{l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]=AnnualTechnologyEmissionByMode[r,t,e,m,y];
#s.t. E2_AnnualEmissionProduction{r in REGION, t in TECHNOLOGY, e in EMISSION, m in MODE_OF_OPERATION, y in YEAR}: sum{l in TIMESLICE, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] = AnnualTechnologyEmission[r,t,e,y];
#s.t. E3_EmissionsPenaltyByTechAndEmission{r in REGION, t in TECHNOLOGY, e in EMISSION, y in YEAR: EmissionActivityRatio[r,t,e,m,y]<>0}: sum{l in TIMESLICE, m in MODE_OF_OPERATION} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*EmissionsPenalty[r,e,y] = AnnualTechnologyEmissionPenaltyByEmission[r,t,e,y];
#s.t. E4_EmissionsPenaltyByTechnology{r in REGION, t in TECHNOLOGY, y in YEAR}: sum{e in EMISSION, l in TIMESLICE, m in MODE_OF_OPERATION} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*EmissionsPenalty[r,e,y] = AnnualTechnologyEmissionsPenalty[r,t,y];
#s.t. E6_EmissionsAccounting1{r in REGION, e in EMISSION, y in YEAR}: sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] = AnnualEmissions[r,e,y];
#s.t. E7_EmissionsAccounting2{r in REGION, e in EMISSION}: sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] + ModelPeriodExogenousEmission[r,e] = ModelPeriodEmissions[r,e];
#
#########                   Simultaneity               ##############
#Constraint added so that selected technologies must be dispatched simultaniously when they would normally deliver a service a to different consumers
#examples are furnace and baseboard space heaters, that would likely be turned on by different households at the same time.
#To keep this constraint linear, simultaneity works only for ResidualCapacity (not for NewCapacity)
#constraint added by KPW on 12.05.2020
s.t. SM1_SimultaneityPerTechnology{r in REGION, t in TECHNOLOGY, l in TIMESLICE, f in FUEL, y in YEAR: SimultaneityTagTechnology[r,t,f,y]<>0}:
sum{m in MODE_OF_OPERATION: OutputActivityRatio[r,t,f,m,y] <>0 && SimultaneityTagTechnology[r,t,f,y]<>0}
RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y]*YearSplit[l,y]
* SimultaneityTagTechnology[r,t,f,y]
>=
SpecifiedAnnualDemand[r,f,y]*SpecifiedDemandProfile[r,f,l,y] 
* ResidualCapacity[r,t,y]
/
sum{tt in TECHNOLOGY: SimultaneityTagTechnology[r,tt,f,y]<>0}
ResidualCapacity[r,tt,y];
#
###########################################################################################
#
solve;

#
#
#####################################################################################################################################################################################################################################################################################################################
#
####	SHORT Summary results 	#######################################################################################################################################################################################################################################
#
###		Total costs and emissions by region	############################################################################################################################################################################################################################
#
#####################################################################################################################################################################################################################################################################################################################
#
 
#
#### Total Costs ####
#

printf "Costs in M$," >> SelRes;

printf "Total System Costs," >> SelRes;
printf "Generator Capital Costs," >> SelRes;
printf "Generator Fixed Costs," >> SelRes;
printf "Generator Variable Costs," >> SelRes;
printf "Generator Emissions Costs," >> SelRes;
printf "Generator Salvage Value," >> SelRes;
printf "Storage Capital Costs," >> SelRes;
printf "Storage Salvage Value" >> SelRes;
printf "\n" >> SelRes;

printf "Discounted," >> SelRes;

#Total Discounted System Costs (optimization function - this output should match the cplex optimal solution)
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR} 
	(
		(
			(
				#generator fixed costs
				(
					(
						sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} 
							NewCapacity[r,t,yy]
					)
					+ 
					ResidualCapacity[r,t,y]
				)
				*FixedCost[r,t,y]
				
				#generator variable cost
				+ sum{m in MODE_OF_OPERATION, l in TIMESLICE} 
					RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y]
			)
			/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
			
			#generator capital costs
			+CapitalCost[r,t,y] * NewCapacity[r,t,y]
			/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
					
			#generator emissions costs
			+DiscountedTechnologyEmissionsPenalty[r,t,y]
			
			#generator salvage value
			-DiscountedSalvageValue[r,t,y]
		) 
	)		
	+ sum{r in REGION, s in STORAGE, y in YEAR} 
	(
		#storage capital costs
		CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
						
		#storage salvage value
		-SalvageValueStorage[r,s,y]
		/((1+DiscountRate[r])^(max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)+1))
	)
	>> SelRes;

#Disounted Generator Capital Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		(CapitalCost[r,t,y] * NewCapacity[r,t,y])
		# Discount Capital Costs
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
	)
	>> SelRes;
	
#Disounted Generator Fixed Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y]
		# Discount Fixed Costs
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
	)
	>> SelRes;
	
#Disounted Generator Variable Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		(sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])
		# Discount Variable Costs
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
	)
	>> SelRes;

#Discounted Generator Emissions Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		DiscountedTechnologyEmissionsPenalty[r,t,y]
	)
	>> SelRes;

#Disounted Generator Salvage Value
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(	
		DiscountedSalvageValue[r,t,y]
	)
	>> SelRes;
	
#Disounted Storage Capital Costs
printf "%g,", 
	sum{r in REGION, s in STORAGE, y in YEAR}
	(
		CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
		# Discount Storage Capital Costs
		/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
	)
	>> SelRes;

#Disounted Storage Salvage Value
printf "%g,", 
	sum{r in REGION, s in STORAGE, y in YEAR}
	(
		SalvageValueStorage[r,s,y]
		# Discount Storage Salvage Value
		/((1+DiscountRate[r])^(max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)+1))
	)
	>> SelRes;

#Non-Discounted Costs

printf "\n" >> SelRes;

printf "Non-Discounted," >> SelRes;

#Total Non-Discounted System Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR} 
	(
		(
			(
				#generator fixed costs
				(
					(
						sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} 
							NewCapacity[r,t,yy]
					)
					+ 
					ResidualCapacity[r,t,y]
				)
				*FixedCost[r,t,y]
				
				#generator variable cost
				+ sum{m in MODE_OF_OPERATION, l in TIMESLICE} 
					RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y]
			)
			
			#generator capital costs
			+CapitalCost[r,t,y] * NewCapacity[r,t,y]
			
			#generator emissions costs
			+sum{e in EMISSION, l in TIMESLICE, m in MODE_OF_OPERATION} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*EmissionsPenalty[r,e,y]
			
			#generator salvage value
			-SalvageValue[r,t,y]
		) 
	)		
	+ sum{r in REGION, s in STORAGE, y in YEAR} 
	(
		#storage capital costs
		CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
				
		#storage salvage value
		-SalvageValueStorage[r,s,y]
	)
	
	>> SelRes;

#Non-Disounted Generator Capital Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		(CapitalCost[r,t,y] * NewCapacity[r,t,y])
	)
	>> SelRes;
	
#Non-Disounted Generator Fixed Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y]
	)
	>> SelRes;
	
#Non-Disounted Generator Variable Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		(sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])
	)
	>> SelRes;

#Non-Discounted Generator Emissions Costs
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(
		sum{e in EMISSION, l in TIMESLICE, m in MODE_OF_OPERATION} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*EmissionsPenalty[r,e,y]
	)
	>> SelRes;

#Non-Disounted Generator Salvage Value
printf "%g,", 
	sum{r in REGION, t in TECHNOLOGY, y in YEAR}
	(	
		SalvageValue[r,t,y]
	)
	>> SelRes;
	
#Non-Disounted Storage Capital Costs
printf "%g,", 
	sum{r in REGION, s in STORAGE, y in YEAR}
	(
		CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
	)
	>> SelRes;

#Non-Disounted Storage Salvage Value
printf "%g,", 
	sum{r in REGION, s in STORAGE, y in YEAR}
	(
		SalvageValueStorage[r,s,y]
	)
	>> SelRes;	

printf "\n" >> SelRes;
printf "\n" >> SelRes;


#
######## Breakdown per Region ############
#

for {r in REGION} 	
{
	printf "Summary for Region: ," >> SelRes;
	printf "%s", r >> SelRes;
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	
	#
	#### 	Emissions	####
	#

	printf "Emissions" >> SelRes;
	printf "\n" >> SelRes;
	for {e in EMISSION} 	
	{
		printf "%s,", e >> SelRes;
		printf "%g,", sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION, y in YEAR: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] + ModelPeriodExogenousEmission[r,e] >> SelRes;
		printf "\n" >> SelRes;	
	}


	#
	####	Total Annual Power Capacity	###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Total Annual Power Capacity (GW)" >> SelRes;
	printf "\n" >> SelRes;
	for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%g", y >> SelRes;
		for { t in TECHNOLOGY } 
			{
				printf ",%g", ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) >> SelRes;
			}
		printf "\n" >> SelRes;
	}


	#
	####	Total Annual Energy Storage Capacity	###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Total Annual Energy Storage Capacity (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {s in STORAGE} {printf ",%s", s >> SelRes;}
	printf "\n" >> SelRes;
	for { y in YEAR } 
	{
		printf "%g", y >> SelRes;
		for { s in STORAGE } 
		{
			printf ",%g", ((sum{yy in YEAR: y-yy < OperationalLifeStorage[r,s] && y-yy>=0} NewStorageCapacity[r,s,yy])+ ResidualStorageCapacity[r,s,y]) >> SelRes;
		}
		printf "\n" >> SelRes;
	}
						
	#
	####	New Annual Power Capacity	###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "New Annual Power Capacity (GW)" >> SelRes;
	printf "\n" >> SelRes;
	for {t in TECHNOLOGY} 	{printf ",%s", t >> SelRes;}
	printf "\n" >> SelRes;
	for { y in YEAR } 	
	{
		printf "%g", y >> SelRes;
		for { t in TECHNOLOGY } 	
		{
			printf ",%g", NewCapacity[r,t,y] >> SelRes;
		}
		printf "\n" >> SelRes;
	}
						
	#
	### Annual Fuel Generation per fuel type###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Annual Fuel Generation per fuel type (GWh)" >> SelRes;
	printf "\n" >> SelRes;
    for {y in YEAR}
    {
        printf "," >> SelRes;
        for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
        printf "\n" >> SelRes;
        for { f in FUEL }
        {
            printf "%g,", y >> SelRes;
            printf "%s", f >> SelRes;
            for { t in TECHNOLOGY } 
            {
                printf ",%g", sum{m in MODE_OF_OPERATION, l in TIMESLICE: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * YearSplit[l,y] >> SelRes;
            }
            printf "\n" >> SelRes;
        }
    }
    
	#
	####	Annual Capacity Factor	per fuel type ###
	#
    printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Annual Capacity Factor	per fuel type (fraction)" >> SelRes;
	printf "\n" >> SelRes;
	for {y in YEAR}
    {
        printf "," >> SelRes;
        for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
        printf "\n" >> SelRes;
        for { f in FUEL }
        {
            printf "%g,", y >> SelRes;
            printf "%s", f >> SelRes;
            for { t in TECHNOLOGY } 
            {
                printf ",%g", sum{m in MODE_OF_OPERATION, l in TIMESLICE: OutputActivityRatio[r,t,f,m,y] <>0 && (((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y]) > 0)} (RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*OutputActivityRatio[r,t,f,m,y]) / (((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*8760) >> SelRes; 
            }
            printf "\n" >> SelRes;
        }
    }				

	#
	###		Total Annual Emissions	###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Annual Emissions (Mt)" >> SelRes;
	printf "\n" >> SelRes;
	for {e in EMISSION} {printf ",%s", e >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR } 	
	{
		printf "%g", y >> SelRes;
		for {e in EMISSION} 
		{
			printf ",%g", sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >> SelRes;
		}
		printf "\n" >> SelRes;
	}
	#
	### Annual Emissions by Technology ###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Annual Emissions by Technology (Mt)" >> SelRes;
	printf "\n" >> SelRes;
    for {y in YEAR}
    {
        printf "," >> SelRes;
        for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
        printf "\n" >> SelRes;
        for {e in EMISSION}
        {
            printf "%g,", y >> SelRes;
            printf "%s", e >> SelRes;
            for { t in TECHNOLOGY } 
            {
                printf ",%g", sum{l in TIMESLICE, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] >> SelRes;
            }
            printf "\n" >> SelRes;
        }
    }
    
	#
	###		Emission Intensity	###
	#
#	printf "\n" >> SelRes;
#	printf "\n" >> SelRes;
#	printf "Emission Intensity (gCO2/kWh)" >> SelRes;
#	printf "\n" >> SelRes;
#	for {e in EMISSION} {printf ",%s", e >> SelRes;}
#	printf "\n" >> SelRes;
#	for {y in YEAR } 	
#	{
#		printf "%g", y >> SelRes;
#		for {e in EMISSION}	
#		{
#			printf ",%g", sum{l in TIMESLICE, t in TECHNOLOGY, m in MODE_OF_OPERATION: EmissionActivityRatio[r,t,e,m,y]<>0} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y] / SpecifiedAnnualDemand[r,'dELEC',y] *1000000 >> SelRes;
#		}
#		printf "\n" >> SelRes;
#	}
	
    #
	###		Total Annual Exogenous Fuel Demand	###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Annual Exogenous Fuel Demand (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {f in FUEL} {printf ",%s", f >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR } 	
	{
		printf "%g", y >> SelRes;
		for {f in FUEL} 
		{
			printf ",%g", SpecifiedAnnualDemand[r,f,y] >> SelRes;
		}
		printf "\n" >> SelRes;
	}
    
    #
	###		Total Annual Endogenous Fuel Demand per Technology	###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Annual Endogenous Fuel Demand per Technology (GWh)" >> SelRes;
	printf "\n" >> SelRes;
    for {y in YEAR}
    {
        printf "," >> SelRes;
        for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
        printf "\n" >> SelRes;
        for { f in FUEL }
        {
            printf "%g,", y >> SelRes;
            printf "%s", f >> SelRes;
            for { t in TECHNOLOGY } 
            {
                printf ",%g", sum{l in TIMESLICE, m in MODE_OF_OPERATION: InputActivityRatio[r,t,l,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,l,f,m,y] * YearSplit[l,y] >> SelRes;
            }
            printf "\n" >> SelRes;
        }
    }
								
	#Exogenous demand for each fuel per time slice
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Exogenous demand for fuel type (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%s", y >> SelRes;
		
		for {l in TIMESLICE}
		{
			printf ",%s", l >> SelRes;
		}
		printf "\n" >> SelRes;

		for {f in FUEL}
		{
			printf"%s",f >> SelRes;
		
			for { l in TIMESLICE} 
			{
				printf ",%g",  SpecifiedAnnualDemand[r,f,y] * SpecifiedDemandProfile[r,f,l,y] / (YearSplit[l,y]*8760) >> SelRes;
			}
			
			printf "\n" >> SelRes;
		}				   
	}
    
    #Endogenous demand for fuel per Technology and Time Slice
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Endogenous fuel demand per Technology and Time Slice (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf ",%s", y >> SelRes;
		
		for {l in TIMESLICE}
		{
			printf ",%s", l >> SelRes;
		}
		printf "\n" >> SelRes;
		
		for {f in FUEL}
        {
            for {t in TECHNOLOGY}
            {
                printf"%s",f >> SelRes;
                printf",%s",t >> SelRes;
            
                for { l in TIMESLICE} 
                {
                    printf ",%g", sum{m in MODE_OF_OPERATION: InputActivityRatio[r,t,l,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*InputActivityRatio[r,t,l,f,m,y] * YearSplit[l,y] >> SelRes;
                }
                
                printf "\n" >> SelRes;
            }
        }
		
	}
    
											
	#Fuel Generation per Technology and Time Slice (GWh)
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Fuel Generation per Technology and Time Slice (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf ",%s", y >> SelRes;
		
		for {l in TIMESLICE}
		{
			printf ",%s", l >> SelRes;
		}
		printf "\n" >> SelRes;
		
		for {f in FUEL}
        {
            for {t in TECHNOLOGY}
            {
                printf"%s",f >> SelRes;
                printf",%s",t >> SelRes;
            
                for { l in TIMESLICE} 
                {
                    printf ",%g", sum{m in MODE_OF_OPERATION: OutputActivityRatio[r,t,f,m,y] <>0} RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,f,m,y] * YearSplit[l,y] >> SelRes;
                }
                
                printf "\n" >> SelRes;
            }
        }
		
	}
			

	#Storage Level at Start of Time Slice
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Storage Level at Start of Time Slice (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%s", y >> SelRes;
		
		for {l in TIMESLICE}
		{
			printf ",%s", l >> SelRes;
		}
		printf "\n" >> SelRes;
		
		for {s in STORAGE}
		{
			printf"%s",s >> SelRes;
		
			for { l in TIMESLICE} 
			{
				printf ",%g", StorageLevelTSStart[r,s,l,y] >> SelRes;
			}
			
			printf "\n" >> SelRes;
		}
		
	}

	#Storage Level at start and end of modelling period (variable chosen by optimization)
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Storage Level Start and End (GWh)" >> SelRes;
	printf "\n" >> SelRes;
	for {s in STORAGE}
	{
		printf "%s", s >> SelRes;
		printf ",%g", StorageLevelStart[r, s] >> SelRes;
		printf "\n" >> SelRes;
	}
	
	################# CURTAILMENT ####################
	#
	#####CURTAILED Electricity Generation dELEC per Technology and Time Slice (GWh)
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "CURTAILED Electricity Generation dELEC per Technology and Time Slice (GWh) (VRE ONLY!)" >> SelRes;
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%s", y >> SelRes;
		
		for {l in TIMESLICE}
		{
			printf ",%s", l >> SelRes;
		}
		printf "\n" >> SelRes;
		
		for {t in TECHNOLOGY}
		{
			printf"%s",t >> SelRes;
		
			for { l in TIMESLICE} 
			{
				printf ",%g", sum{m in MODE_OF_OPERATION: OutputActivityRatio[r,t,'dELEC',m,y] <>0}
				(
					((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])
					*(CapacityFactor[r,t,l,y]*CapacityToActivityUnit[r,t]*OutputActivityRatio[r,t,'dELEC',m,y] * YearSplit[l,y]) 
					- (RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,'dELEC',m,y] * YearSplit[l,y])
				)	>> SelRes;
			}
			
			printf "\n" >> SelRes;
		}
		
	}
	#
	### Annual CURTAILED Electricity Generation to meet dELEC###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "CURTAILED Annual Electricity Generation for dELEC (GWh) (VRE ONLY!)" >> SelRes;
	printf "\n" >> SelRes;
	for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
	printf "\n" >> SelRes;
	for { y in YEAR } 
	{
		printf "%g", y >> SelRes;
		for { t in TECHNOLOGY } 
		{
			printf ",%g", sum{m in MODE_OF_OPERATION, l in TIMESLICE: OutputActivityRatio[r,t,'dELEC',m,y] <>0} 
			(
				((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])
				*(CapacityFactor[r,t,l,y]*CapacityToActivityUnit[r,t]*OutputActivityRatio[r,t,'dELEC',m,y] * YearSplit[l,y]) 
				- (RateOfActivity[r,l,t,m,y]*OutputActivityRatio[r,t,'dELEC',m,y] * YearSplit[l,y])
			)	>> SelRes;
		}
		printf "\n" >> SelRes;
	}
	#
	###DISCOUNTED total technology-specific costs (M$)###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Discounted total TECHNOLOGY-specific costs (M$)" >> SelRes;
	printf "\n" >> SelRes;
	for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%g", y >> SelRes;
		for { t in TECHNOLOGY } 
			{
				printf ",%g",
				(
					(
						(
							# generator fixed costs
							(
								(
									sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} 
										NewCapacity[r,t,yy]
								)
								+ 
								ResidualCapacity[r,t,y]
							)
							*FixedCost[r,t,y]
							
							# generator variable cost
							+ sum{m in MODE_OF_OPERATION, l in TIMESLICE} 
								RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y]
						)
						/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
						
						#generator capital costs
						+CapitalCost[r,t,y] * NewCapacity[r,t,y]
						/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
						
						#generator emissions costs
						+DiscountedTechnologyEmissionsPenalty[r,t,y]
						
						#generator salvage value
						-DiscountedSalvageValue[r,t,y]
					) 
				) >> SelRes;
			}
		printf "\n" >> SelRes;
	}
	#
	###NON-DISCOUNTED total technology-specific costs (M$)###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Non-discounted total TECHNOLOGY-specific costs (M$)" >> SelRes;
	printf "\n" >> SelRes;
	for {t in TECHNOLOGY} {printf ",%s", t >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%g", y >> SelRes;
		for { t in TECHNOLOGY } 
			{
				printf ",%g",
				(
					(
						(
							#generator fixed costs
							(
								(
									sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} 
										NewCapacity[r,t,yy]
								)
								+ 
								ResidualCapacity[r,t,y]
							)
							*FixedCost[r,t,y]
							
							#generator variable cost
							+ sum{m in MODE_OF_OPERATION, l in TIMESLICE} 
								RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y]
						)
						
						#generator capital costs
						+CapitalCost[r,t,y] * NewCapacity[r,t,y]
											
						#generator emissions costs
						+sum{e in EMISSION, l in TIMESLICE, m in MODE_OF_OPERATION} EmissionActivityRatio[r,t,e,m,y]*RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*EmissionsPenalty[r,e,y]
									
						#generator salvage value
						-SalvageValue[r,t,y]
					) 
				) >> SelRes;
			}
		printf "\n" >> SelRes;
	}
	#
	###DISCOUNTED total storage-specific costs (M$)###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Discounted total STORAGE-specific costs (M$)" >> SelRes;
	printf "\n" >> SelRes;
	for {s in STORAGE} {printf ",%s", s >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%g", y >> SelRes;
		for { s in STORAGE } 
			{
				printf ",%g",
				(
					#storage capital costs
					CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
					/((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
							
					#storage salvage value
					-SalvageValueStorage[r,s,y]
					/((1+DiscountRate[r])^(max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)+1))
				
				) >> SelRes;
			}
		printf "\n" >> SelRes;
	}
	#
	###NON-DISCOUNTED total storage-specific costs (M$)###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Non-discounted total STORAGE-specific costs (M$)" >> SelRes;
	printf "\n" >> SelRes;
	for {s in STORAGE} {printf ",%s", s >> SelRes;}
	printf "\n" >> SelRes;
	for {y in YEAR}
	{
		printf "%g", y >> SelRes;
		for { s in STORAGE } 
			{
				printf ",%g",
				(
					#storage capital costs
					CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
																	
					#storage salvage value
					-SalvageValueStorage[r,s,y]	
				) >> SelRes;
			}
		printf "\n" >> SelRes;
	}      
    #
	###DISCOUNTED technology- and item-specific costs (M$)###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Discounted TECHNOLOGY- and ITEM-specific costs (M$)" >> SelRes;
	printf "\n" >> SelRes;
    printf "Year," >> SelRes;
    printf "Technology," >> SelRes;
    printf "Capital Costs," >> SelRes;
    printf "Fixed Costs," >> SelRes;
    printf "Variable Costs," >> SelRes;
    printf "Emissions Costs," >> SelRes;
    printf "Salvage Value," >> SelRes;
    printf "\n" >> SelRes;
    for {y in YEAR}
	{
		for { t in TECHNOLOGY } 
			{
                printf "%g,", y >> SelRes; #print the year in the first cell of each row
				printf "%s,", t >> SelRes; #print the technology name into the second cell
                #now print all the item values
                
                #Disounted Generator Capital Costs
                printf "%g,", 
                    (
                        (CapitalCost[r,t,y] * NewCapacity[r,t,y])
                        # Discount Capital Costs
                        /((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
                    )
                    >> SelRes;
                    
                #Disounted Generator Fixed Costs
                printf "%g,", 
                    (
                        ((sum{yy in YEAR: y-yy < OperationalLife[r,t] && y-yy>=0} NewCapacity[r,t,yy])+ ResidualCapacity[r,t,y])*FixedCost[r,t,y]
                        # Discount Fixed Costs
                        /((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
                    )
                    >> SelRes;
                    
                #Disounted Generator Variable Costs
                printf "%g,", 
                    (
                        (sum{m in MODE_OF_OPERATION, l in TIMESLICE} RateOfActivity[r,l,t,m,y]*YearSplit[l,y]*VariableCost[r,t,m,y])
                        # Discount Variable Costs
                        /((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)+0.5))
                    )
                    >> SelRes;

                #Discounted Generator Emissions Costs
                printf "%g,", 
                    (
                        DiscountedTechnologyEmissionsPenalty[r,t,y]
                    )
                    >> SelRes;

                #Disounted Generator Salvage Value
                printf "%g,", 
                    (	
                        DiscountedSalvageValue[r,t,y]
                    )
                    >> SelRes;
                printf "\n" >> SelRes;
			}
	} 
    #
	###DISCOUNTED storage- and item-specific costs (M$)###
	#
	printf "\n" >> SelRes;
	printf "\n" >> SelRes;
	printf "Discounted STORAGE- and ITEM-specific costs (M$)" >> SelRes;
	printf "\n" >> SelRes;
    printf "Year," >> SelRes;
    printf "Storage," >> SelRes;
    printf "Capital Costs," >> SelRes;
    printf "Salvage Value," >> SelRes;
    printf "\n" >> SelRes;
    for {y in YEAR}
	{
		for { s in STORAGE } 
			{
                printf "%g,", y >> SelRes; #print the year in the first cell of each row
				printf "%s,", s >> SelRes; #print the storage name into the second cell
                #now print all the item values
                
                #Disounted Storage Capital Costs
                printf "%g,",
                    (
                        CapitalCostStorage[r,s,y] * NewStorageCapacity[r,s,y]
                        # Discount Storage Capital Costs
                        /((1+DiscountRate[r])^(y-min{yy in YEAR} min(yy)))
                    )
                    >> SelRes;

                #Disounted Storage Salvage Value
                printf "%g,", 
                    (
                        SalvageValueStorage[r,s,y]
                        # Discount Storage Salvage Value
                        /((1+DiscountRate[r])^(max{yy in YEAR} max(yy)-min{yy in YEAR} min(yy)+1))
                    )
                    >> SelRes;
                printf "\n" >> SelRes;
			}
	}
    printf "\n" >> SelRes;
}

end;