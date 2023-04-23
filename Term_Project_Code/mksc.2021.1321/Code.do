"Replication Code"
Paper: "Frontiers: Virus Shook the Streaming Star: Estimating the COVID-19 Impact on Music Consumption"
Authors: Jaeung Sim, Daegon Cho, Youngdeok Hwang, Rahul Telang 

{1. "Notes on Variables"
* Panel/Diff-in-Diff Structure *
 country_index: The index of countries
 country_name: Country names (string)
 continent: Continent names (string)
 week: The order of weeks within the research period
 month: Month of the year
 year: Year to which the week belongs
 ymd: The beginning date of each week
 week_of_period: The order of weeks within each of "treated"==0 and "treated"==1
 treated: 0 if 1<="week"<=52, 1 if 53<="week"<=104
 after: 0 if 1<="week_of_period"<=40, 1 if 41<="week_of_period"<=52

* Spotify's Weekly Top 200 Streaming Counts * 
 // Source: https://spotifycharts.com/
 num_streams: The sum of weekly top 200 songs' streaming counts
 ln_num_streams: The log-transformed value of "num_streams"

* ECDC COVID-19 Statistics *
 // Source: https://www.ecdc.europa.eu/en/geographical-distribution-2019-ncov-cases
 cases: No. of weekly COVID-19 cases
 deaths: No. of weekly COVID-19 deaths
 cases_per_million: No. of weekly COVID-19 cases per million population
 deaths_per_million: No. of weekly COVID-19 deaths per million population

* Oxford COVID-19 Government Response Tracker *
 // Source: https://www.bsg.ox.ac.uk/research/research-projects/covid-19-government-response-tracker
 // Containment and closure policies (ordinal scale)
 // Taking the maximum within each week
 // For more details, please refer to Table A2 (Appendix A) or https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md
 C1_Schoolclosing: Record closings of schools and universities
 C2_Workplaceclosing: Record closings of workplaces
 C3_Cancelpublicevents: Record cancelling public events
 C4_Restrictionsongatherings: Record limits on gatherings
 C5_Closepublictransport: Record closing of public transport
 C6_Stayathomerequirements: Record orders to "shelter-in-place" and otherwise confine to the home
 C7_Restrictionsoninternalmove: Record restrictions on internal movement between cities/regions
 C8_Internationaltravelcontrols: Record restrictions on international travel (Note: this records policy for foreign travellers, not citizens)
 
 // Containment and closure policies (binary scale)
 // For more details, please refer to Table A2 (Appendix A)
 d_restrict_school: Record closings of schools and universities
 d_restrict_workpl: Record closings of workplaces
 d_restrict_events: Record cancelling public events
 d_restrict_gather: Record limits on gatherings
 d_restrict_transp: Record closing of public transport
 d_restrict_stayat: Record orders to "shelter-in-place" and otherwise confine to the home
 d_restrict_inside: Record restrictions on internal movement between cities/regions
 d_restrict_outsid: Record restrictions on international travel (Note: this records policy for foreign travellers, not citizens)
 
* Google's COVID-19 Community Mobility Reports
 // Source: https://www.google.com/covid19/mobility/
 // Taking the average for each week
 // For more details, please refer to https://www.google.com/covid19/mobility/data_documentation.html?hl=en
 retail_and_recreation: Mobility trends for places like restaurants, cafes, shopping centers, theme parks, museums, libraries, and movie theaters
 grocery_and_pharmacy: Mobility trends for places like grocery markets, food warehouses, farmers markets, specialty food shops, drug stores, and pharmacies
 parks: Mobility trends for places like local parks, national parks, public beaches, marinas, dog parks, plazas, and public gardens
 transit_stations: Mobility trends for places like public transport hubs such as subway, bus, and train stations
 workplaces: Mobility trends for places of work
 residential: Mobility trends for places of residence

* Apple's Mobility Trends Reports
 // Source: https://covid19.apple.com/mobility
 // A relative volume of directions requests compared to a baseline volume on January 13th, 2020
 // Taking the average for each week
 apple_driving: Request type is 'driving'
 apple_transit: Request type is 'transit'
 apple_walking: Request type is 'walking'
}
{2. "Tables in the manuscript"
use Dataset, clear

* Table 1 *
quietly outreg2 using Table1.doc, append sum(log) keep(num_streams treated after cases_per_million deaths_per_million)

* Table 2 (Overall R-squared) *
reghdfe ln_num_streams treated after c.treated#c.after, absorb(country_index) vce(cluster country_index)
 outreg2 using Table2_overall.doc, append
reghdfe ln_num_streams treated after c.treated#c.after, absorb(country_index week_of_period) vce(cluster country_index)
 outreg2 using Table2_overall.doc, append
reghdfe ln_num_streams treated after c.treated#c.after, absorb(country_index country_index#treated country_index#week_of_period) vce(cluster country_index)
 outreg2 using Table2_overall.doc, append

* Table 3 (Overall R-squared) *
reghdfe ln_num_streams d_restrict_school cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_workpl cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_events cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_gather cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_transp cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_stayat cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_inside cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append
reghdfe ln_num_streams d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_overall.doc, append

* Table 4 (Overall R-squared) *
reghdfe ln_num_streams retail_and_recreation d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index week) vce(cluster country_index)
 outreg2 using Table4_overall.doc, append
reghdfe ln_num_streams grocery_and_pharmacy d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index week) vce(cluster country_index)
 outreg2 using Table4_overall.doc, append
reghdfe ln_num_streams parks d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index week) vce(cluster country_index)
 outreg2 using Table4_overall.doc, append
reghdfe ln_num_streams transit_stations d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index week) vce(cluster country_index)
 outreg2 using Table4_overall.doc, append
reghdfe ln_num_streams workplaces d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index week) vce(cluster country_index)
 outreg2 using Table4_overall.doc, append
reghdfe ln_num_streams residential d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index week) vce(cluster country_index)
 outreg2 using Table4_overall.doc, append
}
{3. "Regressions to obtain within R-squared"
* Table 2 (Within R-squared) *
use Dataset, clear
xtset country_index week
xtdata week ln_num_streams treated after week_of_period, fe clear 

reghdfe ln_num_streams treated after c.treated#c.after, noabsorb vce(cluster country_index)
 outreg2 using Table2_within.doc, append
reghdfe ln_num_streams treated after c.treated#c.after, absorb(week_of_period) vce(cluster country_index)
 outreg2 using Table2_within.doc, append
reghdfe ln_num_streams treated after c.treated#c.after, absorb(country_index#treated country_index#week_of_period) vce(cluster country_index)
 outreg2 using Table2_within.doc, append

* Table 3 (Within R-squared) *
use Dataset, clear
xtset country_index week
xtdata week ln_num_streams treated after week_of_period cases_per_million deaths_per_million d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid, fe clear 
 
reghdfe ln_num_streams d_restrict_school cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_workpl cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_events cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_gather cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_transp cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_stayat cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_inside cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append
reghdfe ln_num_streams d_restrict_outsid cases_per_million deaths_per_million, absorb(country_index#treated country_index#week_of_period week) vce(cluster country_index)
 outreg2 using Table3_within.doc, append

* Table 4 (Within R-squared) *
use Dataset, clear
xtset country_index week
xtdata week ln_num_streams treated after week_of_period cases_per_million deaths_per_million d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid retail_and_recreation grocery_and_pharmacy parks transit_stations workplaces residential, fe clear 

reghdfe ln_num_streams retail_and_recreation d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(week) vce(cluster country_index)
 outreg2 using Table4_within.doc, append
reghdfe ln_num_streams grocery_and_pharmacy d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(week) vce(cluster country_index)
 outreg2 using Table4_within.doc, append
reghdfe ln_num_streams parks d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(week) vce(cluster country_index)
 outreg2 using Table4_within.doc, append
reghdfe ln_num_streams transit_stations d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(week) vce(cluster country_index)
 outreg2 using Table4_within.doc, append
reghdfe ln_num_streams workplaces d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(week) vce(cluster country_index)
 outreg2 using Table4_within.doc, append
reghdfe ln_num_streams residential d_restrict_school d_restrict_workpl d_restrict_events d_restrict_gather d_restrict_transp d_restrict_stayat d_restrict_inside d_restrict_outsid cases_per_million deaths_per_million, absorb(week) vce(cluster country_index)
 outreg2 using Table4_within.doc, append
}
