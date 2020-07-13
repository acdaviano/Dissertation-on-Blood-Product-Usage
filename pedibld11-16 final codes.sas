ods pdf file = 'C:\Users\ADaviano 2\Documents\Memorial Hermann\Pedi Blood\Pedi1116contentsAll.pdf';
proc contents data = hermann.pedi1116all;
run;
ods pdf close;

/*large dataset proc print*/
proc print data = hermann.pedi1116all (obs = 10);
run;

/***************************************************************************************************/
/* CLEANED AND UPDATED DATA SET IMPORT 12/28/2017*/
proc import out = Hermann.Pedi1116D 
	datafile = 'C:\Users\ADaviano 2\Documents\Memorial Hermann\Pedi Blood\JT.AD.PEDI6.xlsx' 
	dbms = xlsx replace;
	getnames = yes;
run;
/***************************************************************************************************/

/*creating dataset variables and formats*/
data hermann.pedi1116d2;
	set hermann.pedi1116d;
	if fluids_type = 'FFP' then Fluidtype = 3;
	if fluids_type = 'RBC' then Fluidtype = 2;
	if PH_FFP = 'FFP' then Fluidtype = 3;
	if PH_RBC = 'RBC' then Fluidtype = 2;
	if fluids_type = 'PLATE' then Fluidtype = 4; 
	if fluids_type = 'CRYO' or fluids_type = 'ALBUM' or fluids_type = 'THAM' then Fluidtype = 5; 
	if fluids_loc = 'HELI' or ph_rbc_loc = 'HELI' or ph_ffp_loc = 'HELI' or ph_CRYST = 'CRYST' 
	or fluids_loc ='SCENE' or fluids_loc ='A8PH' or fluids_loc ='3WJP' or fluids_loc ='PTA' then Fluidloc = 1;
	else do Fluidloc = 0;
	end;
	if PH_FFP = 'FFP' or PH_RBC = 'RBC' or fluids_type = 'RBC' or fluids_type = 'FFP' 
	or fluids_type = 'PLATE' or PRBC_0_4_HR = 1-9999 or fluids_type = 'CRYO' or fluids_type = 'ALBUM' 
	or fluids_type = 'THAM' then BLDPGVN = 1;
	else do BLDPGVN = 0;
	end;
run;

data hermann.pedi1116d3;
	set hermann.pedi1116d2;
	if Fluidtype = . then Fluidtype = 1;
	Format Height Weight 3.;
run;

data hermann.pedi1116d4;
	set hermann.pedi1116d;
	if outcome = 'D' then out = 0;
	if outcome = 'A' then out = 1;
	if sex = 'M' then sex1 = 1;
	if sex = 'F' then sex1 = 0;
	if transport = 'HEL' then TransT = 1;
	if transport = 'AMB' then TransT = 0;
	if ED_fast = 'POS' then Fast = 1;
	if ED_fast = 'POSITIVE' then Fast = 1;
	if ED_fast = 'ABNORMAL' then Fast = 1;
	if ED_fast = 'pos' then Fast = 1;
	if ED_fast = 'POS RUQ' then Fast = 1;
	if ED_fast = 'FLUID PR' then Fast = 1;
	if ED_fast = 'RUQ +' then Fast = 1;
	if ED_fast = 'POS RT F' then Fast = 1;
	if ED_fast = '+(SUPRAP' then Fast = 1;
	if ED_fast = 'RUQ INDE' then Fast = 1;
	if ED_fast = 'LUQ QUES' then Fast = 1;
	if ED_fast = 'NEG' then Fast = 0;
	if ED_fast = 'NEGATIVE' then Fast = 0;
	if ED_fast = '?' then Fast = 2;
	if ED_fast = 'QUESTION' then Fast = 2;
	if ED_fast = '#NAME?' then Fast = 2;
	if ED_fast = 'NO CARDI' then Fast = 2;
	if ED_fast = 'UNABLE T' then Fast = 2;
	if ED_fast = 'INDETERM' then Fast = 2;
	if ph_fast_result = 'POS' then Fast = 1;
	if ph_fast_result = 'ABN' then Fast = 1;
	if ph_fast_result = 'LUQ' then Fast = 1;
	if ph_fast_result = 'RUQ' then Fast = 1;
	if ph_fast_result = 'NEG' then Fast = 0;
	if ph_fast_result = '?' then Fast = 2;
	if ph_fast_result = 'QUE' then Fast = 2;
	if ph_fast_result = '#NA' then Fast = 2;
	if ph_fast = 'FAST' or ED_fast = 'POS' or ED_fast = 'POSITIVE' or 
	ED_fast = 'ABNORMAL' or ED_fast = 'pos' or ED_fast = 'POS RUQ' or 
	ED_fast = 'FLUID PR' or ED_fast = 'RUQ +' or ED_fast = 'POS RT F' or 
	ED_fast = '+(SUPRAP' or ED_fast = 'RUQ INDE' or ED_fast = 'LUQ QUES' or 
	ED_fast = 'NEG' or ED_fast = 'NEGATIVE' or ED_fast = '?' or 
	ED_fast = 'QUESTION' or ED_fast = '#NAME?' or ED_fast = 'NO CARDI' or 
	ED_fast = 'UNABLE T' or ED_fast = 'INDETERM' or ph_fast_result = 'POS' or 
	ph_fast_result = 'ABN' or ph_fast_result = 'LUQ' or 
	ph_fast_result = 'RUQ' or ph_fast_result = 'NEG' or 
	ph_fast_result = '?' or ph_fast_result = 'QUE' or 
	ph_fast_result = '#NA' then FASTCOM = 1;
	else do FASTCOM = 0;
	end;
	if 0 < age < 1 then age1 = 1;
	if 1 <= age < 5 then age1 = 2;
	if 5 <= age < 10 then age1 = 3;
	if 10 <= age < 13 then age1 = 4;
	if 13 <= age <= 17 then age1 = 5;
	if Trauma_type = 'B' then TMAT = 0;
	if Trauma_type = 'P' then TMAT = 1;
	if ethnicity = 'H' then ETHN = 1;
	if ethnicity = 'N' then ETHN = 0;
	if ethnicity = 'U' then ETHN = .;
	if race = 'W' then race1 = 1;
	if race = 'BL' then race1 = 2;
	if race = 'H' then race1 = 3;
	if race = 'A' then race1 = 3;
	if race = 'O' then race1 = 3;
	if race = 'UNK' then race1 = .;
	if race = 'U' then race1 = .;
	if race = 'W' then race2 = 1;
	if race = 'BL' then race2 = 0;
	if race = 'H' then race2 = 0;
	if race = 'A' then race2 = 0;
	if race = 'O' then race2 = 0;
	if race = 'UNK' then race2 = .;
	if race = 'U' then race2 = .;
	PHMAP = (((2 * PH_DBP)+ PH_SBP) / 3);
	EDMAP = (((2 * ED_DBP)+ ED_SBP) / 3);
	if vent = 0 then INTN = 0;
	if vent = . then INTN = .;
	if PH_INTUBATION = 'Y' THEN INTN = 1;
	if PH_INTUBATION = 'N' THEN INTN = 0;
	if PH_INTUBATION = 'UNK' THEN INTN = .;
	if ED_INTUBATION = 'Y' THEN INTN = 1;
	if ED_INTUBATION = 'N' THEN INTN = 0;
	if ED_INTUBATION = 'UNK' THEN INTN = .;
	if Vent ne 0 THEN INTN = 1;
	if transfer_ = 'Y' then Transfer = 1;
	if transfer_ = 'N' then transfer = 0;
	attrib newarriv format=datetime15.;
	newarriv=input(put(hosp_arriv_date,date8.)||put(hosp_arriv_time,hhmm10.),datetime.);
	attrib newdeath format=datetime15.;
	newdeath=input(put(death_date,date8.)||put(death_time,hhmm10.),datetime.);
run;

proc sort data = hermann.pedi1116d4;
	by PT_NUMB;
run;

proc sort data = hermann.pedi1116d3;
	by PT_NUMB;
run;

data hermann.pedi1116d5;
merge hermann.pedi1116d4 hermann.pedi1116d3;
	by PT_NUMB;
run;

proc format;
	picture duration low-high = '%n:%0H:%0M:%0S' (datatype=time);
run;

data _null_;
/* create a variable whose value is duration since the beginning of the current month */
duration = datetime() - mdy(month(today()),1,year(today()))*24*60*60;
put 'In Days:Hours:Minutes:Seconds: ' duration duration. /
	'In Hours:Minutes:Seconds: ' duration time9.;
run;

data hermann.pedi1116all;
	set hermann.pedi1116d5;
	format PHMAP 3.;
	format EDMAP 3. timetodeath duration.;
	array _char PH_SBP PH_DBP PH_HR;
	array _num 3 PH_SBP1 PH_DBP1 PH_HR1;
	do i=1 to dim(_char);
	_num(i) = input(_char(i),best3.);
	end;
	drop i;
	if Fast = 1 and fastcom = 1 then FASTCOMPOS = 1;
	else do FASTCOMPOS = 0;
	end;
	if Fast = 0 or Fast = 2 and fastcom = 1 then FASTCOMNEG = 1;
	else do FASTCOMNEG = 0;
	end;
	if fastcom = 0 or Fast = . then FASTNOTCOM = 1;
	else do FASTNOTCOM = 0;
	end;
	if ais_head GE 4 then SHI = 1;
	else do SHI = 0;
	end;
	if cod_option = 'HEAD.INJ' or cod_option = 'HGE~HEAD' then CondHI = 1;
	else do condHI=0;
	end;
	timetodeath= newdeath-newarriv;
	if edmap < 60 then map2 = 1;
	if 60 <= edmap < 90 then map2 = 2;
	if 90 <= edmap then map2 = 3;
	if edmap = . then map2 = .;
	if ed_sbp < 90 then sbp2 = 1;
	if 90 <= ed_sbp < 130 then sbp2 = 2;
	if 130 <= ed_sbp then sbp2 = 3;
	if ed_sbp = . then sbp2 = .;
	if ed_hr < 60 then hr2 = 1;
	if 60 <= ed_hr < 100 then hr2 = 2;
	if 100 <= ed_hr < 140 then hr2 = 3;
	if 140 <= ed_hr then hr2 = 4;
	if ed_hr = . then hr2 = .;
	if height < 110 then ht2 = 1;
	if 110 <= height < 130 then ht2 = 2;
	if 130 <= height < 150 then ht2 = 3;
	if 150 <= height < 170 then ht2 = 4;
	if 170 <= height then ht2 = 5;
	if height = . then ht2 = .;
	if weight < 20 then wt2 = 1;
	if 20 <= weight < 40 then wt2 = 2;
	if 40 <= weight < 60 then wt2 = 3;
	if 60 <= weight < 80 then wt2 = 4;
	if 80 <= weight then wt2 = 5;
	if weight = . then wt2 = .;
	if iss < 16 then iss2 = 1;
	if 16 <= iss < 24 then iss2 = 2;
	if 24 <= iss then iss2 = 3;
	if iss = . then iss2 = .;
	if height < 103 then ht3 = 1;
	if 103 <= height < 134 then ht3 = 2;
	if 134 <= height < 151 then ht3 = 3;
	if 151 <= height then ht3 = 4;
	if height = . then ht3 = .;
	if weight < 17 then wt3 = 1;
	if 17 <= weight < 29 then wt3 = 2;
	if 29 <= weight < 46 then wt3 = 3;
	if 46 <= weight then wt3 = 4;
	if weight = . then wt3 = .;
	if fluidtype = 5 then fluidtype = 4;
run;

data hermann.pedi1116all2;
	set hermann.pedi1116all;
	where bldpgvn = 1;
run;


/*CHANGE CHAR TO NUM FOR VAR*/
data hermann.pedi1116i;
	set hermann.pedi1116;
	array _char race2 racen age fast_numeric post_p initial_map post_map;
	array _num 3 race21 racen1 age1 fast_numeric1 post_p1 Initial_map1 post_map1;
	do i=1 to dim(_char);
	_num(i) = input(_char(i),best3.);
	end;
	drop i;
run;
/****************************************************************************************************/

/* petitioning for missing variables 12/2017*/

data hermann.pedi1116AllMiss;
	merge hermann.pedi1116miss hermann.pedi1116miss1 hermann.pedi1116miss2 hermann.pedi1116miss3 hermann.pedi1116miss4;
run;
ods pdf file = 'C:\Users\ADaviano 2\odrive\Amazon Cloud Drive\School Back up\Texas A&M Health Science Center Work\Research and School Work\Memorial Hermann\Data outputs\MissingVariables.pdf';
proc print data = hermann.pedi1116allmiss;
run;
ods pdf close;
/***************************************************************************************************/

/* Aim 1 descriptive stats by category*/

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	var out INTN ISS PHMAP EDMAP fastcompos fastcomneg fastnotcom SHI condhi death_time ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class fluidtype;
	where bldpgvn = 1;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	var out INTN ISS PHMAP hr2 wt3 ht3 sbp2 map2 iss2 EDMAP fastcompos fastcomneg fastnotcom SHI condhi death_time ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
run;

proc sort data = hermann.pedi1116all;
	by bldpgvn;
run;

proc SORT data = hermann.pedi1116all;
	by trans_agency;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	output out=hermann.pediallmeansBLDonlyByLOC(drop=_type_ _freq_) n= mean= median= p25= p75= qrange= std= mode= max= min= nmiss= / autoname;
	where fluidtype ne 1;
	var out INTN ISS PHMAP fluidtype fluidloc fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class fluidloc;
	by bldpgvn;
run;

proc means data = hermann.pedi1116all2 n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	output out=hermann.pediallmeans2BLDonlyByLOC(drop=_type_ _freq_) n= mean= median= p25= p75= qrange= std= mode= max= min= nmiss= / autoname;
	var out INTN ISS PHMAP fluidtype ht3 wt3 iss2 map2 hr2 fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	by fluidloc;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	output out=hermann.pediallmeansBLDBYLOC(drop=_type_ _freq_) n= mean= median= p25= p75= qrange= std= mode= max= min= nmiss= / autoname;
	var out INTN ISS PHMAP fluidtype fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class fluidloc;
	by bldpgvn;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	output out=hermann.pediallmeansBYBLD(drop=_type_ _freq_) n= mean= median= p25= p75= qrange= std= mode= max= min= nmiss= / autoname;
	var out INTN ISS PHMAP fluidtype fluidloc fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class bldpgvn;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 maxdec=2;
	output out=hermann.pediallmeansBLDOnly(drop=_type_ _freq_) n= mean= median= p25= p75= qrange= std= mode= max= min= nmiss= / autoname;
	where fluidtype ne 1;
	var out INTN ISS PHMAP fluidtype fluidloc fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class bldpgvn;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 p99 maxdec=2;
	output out=hermann.pediallmeansNOBLD(drop=_type_ _freq_) n= mean= median= p25= p75= qrange= std= mode= max= min= nmiss=/ autoname;
	where fluidtype = 1;
	var out INTN ISS PHMAP fluidtype fluidloc fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class bldpgvn;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3 p99 maxdec=2;
	output out=hermann.pediallmeans(drop=_type_ _freq_) n= mean= median= p25= p75= p99= std= mode= max= min= nmiss= / autoname;
	var out bldpgvn INTN ISS PHMAP fluidtype fluidloc fastcompos fastcomneg fastnotcom SHI condhi timetodeath EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
run;

proc sort data = hermann.pedi1116all;
	by timetodeath;
run;

proc means data = hermann.pedi1116all n nmiss mean clm mode max min std median q1 q3  maxdec=2;
	output out=hermann.pediallmeansdeathtime(drop=_type_ _freq_) n= mean= median= p25= p75= std= mode= max= min= nmiss= / autoname;
	where death_time le 86400;
	var out INTN ISS PHMAP fluidtype fluidloc fastcompos fastcomneg fastnotcom SHI condhi death_time EDMAP ed_sbp age age1 bmi weight height transfer ed_hr ph_sbp1 PH_HR1 ais_face ais_head ais_chest ais_abd ais_extrem ais_extern race1 race2 ethn sex1 FAST FASTCOM transt tmat LOS VENT ICU_TOTAL;
	class bldpgvn;
run;
/****************************************************************************************************/
proc sort data = hermann.pedi1116all2;
	by fluidloc;
run;

proc sort data = hermann.pedi1116all;
	by bldpgvn;
run;
/***************************************************************************************************/
/* diagnostics on individual variables and the outcomes*/
proc freq data = hermann.pedi1116all; 
	tables trans_agency / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	tables trans_agency / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	tables race1 / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class race1 (ref = '1')/param = ref;
	model bldpgvn (event = "1")= race1/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class race1 (ref = '1')/param = ref;
	model fluidloc (event = "1")= race1/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	tables age1 / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	tables age1 / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class age1 (ref = '5')/param = ref;
	model bldpgvn (event = "1")= age1/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class age1 (ref = '5')/param = ref;
	model fluidloc (event = "1")= age1/ cl;
run;

proc freq data = hermann.pedi1116all; 
	table BldPGvn / measures cmh relrisk chisq exact missing;
run;


proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table fluidloc / measures cmh relrisk chisq exact missing;
run;

proc sort data = hermann.pedi1116all;
	by bldpgvn;
run;

proc freq data = hermann.pedi1116all;
	by bldpgvn; 
	table fluidtype / measures cmh relrisk exact missing;
run;

proc freq data = hermann.pedi1116all2;
	by fluidloc; 
	table fluidtype / measures cmh relrisk exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class fluidtype (ref = '1')/param = ref;
	model bldpgvn (event = "1")= fluidtype/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class fluidtype (ref = '1')/param = ref;
	model fluidloc (event = "1")= fluidtype/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table INTN / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table INTN / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class intn (ref = '0')/param = ref;
	model bldpgvn (event = "1")= intn/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class intn (ref = '0')/param = ref;
	model fluidloc (event = "1")= intn/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table ethn / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table ethn / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class ethn (ref = '0')/param = ref;
	model bldpgvn (event = "1")= ethn/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class ethn (ref = '0')/param = ref;
	model fluidloc (event = "1")= ethn/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table sex1 / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table sex1 / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class sex1 (ref = '0')/param = ref;
	model bldpgvn (event = "1")= sex1/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class sex1 (ref = '0')/param = ref;
	model fluidloc (event = "1")= sex1/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table transt / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table transt / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class transt (ref = '0')/param = ref;
	model bldpgvn (event = "1")= transt/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class transt (ref = '0')/param = ref;
	model fluidloc (event = "1")= transt/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table tmat / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table tmat / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class tmat (ref = '1')/param = ref;
	model bldpgvn (event = "1")= tmat/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class tmat (ref = '1')/param = ref;
	model fluidloc (event = "1")= tmat/ cl;
run;

proc freq data = hermann.pedi1116all; 
	table map2/ measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table map2/ measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class map2 (ref = '2')/param = ref;
	model bldpgvn (event = "1")= map2/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class map2 (ref = '2')/param = ref;
	model fluidloc (event = "1")= map2/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table sbp2 / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table sbp2 / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class sbp2 (ref = '2')/param = ref;
	model bldpgvn (event = "1")= sbp2/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class sbp2 (ref = '2')/param = ref;
	model fluidloc (event = "1")= sbp2/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table hr2 / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table hr2 / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class hr2 (ref = '2')/param = ref;
	model bldpgvn (event = "1")= hr2/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class hr2 (ref = '2')/param = ref;
	model fluidloc (event = "1")= hr2/ cl;
run;

/*proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table ht2 / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class ht2 (ref = '5')/param = ref;
	model bldpgvn (event = "1")= ht2/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class ht2 (ref = '5')/param = ref;
	model fluidloc (event = "1")= ht2/ cl;
run;*/

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table ht3 / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table ht3 / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class ht3 (ref = '4')/param = ref;
	model bldpgvn (event = "1")= ht3/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class ht3 (ref = '4')/param = ref;
	model fluidloc (event = "1")= ht3/ cl;
run;

/*proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table wt2 / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class wt2 (ref = '3')/param = ref;
	model bldpgvn (event = "1")= wt2/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class wt2 (ref = '3')/param = ref;
	model fluidloc (event = "1")= wt2/ cl;
run;*/

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table wt3 / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table wt3 / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	class wt3 (ref = '4')/param = ref;
	model bldpgvn (event = "1")= wt3/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class wt3 (ref = '4')/param = ref;
	model fluidloc (event = "1")= wt3/ cl;
run;


proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table iss2 / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table iss2 / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class iss2 (ref = '1')/param = ref;
	model bldpgvn (event = "1")= iss2/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class iss2 (ref = '1')/param = ref;
	model fluidloc (event = "1")= iss2/ cl;
run;



proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table shi / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table fastcom / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table shi / measures cmh relrisk chisq exact missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table fastcom / measures cmh relrisk chisq exact missing;
run;

proc logistic data = hermann.pedi1116all;
	
	model bldpgvn (event = "1")= weight/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	
	model fluidloc (event = "1")= height/ cl;
run;

proc logistic data = hermann.pedi1116all;
	
	model bldpgvn (event = "1")= age/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	
	model fluidloc (event = "1")= age/ cl;
run;

proc logistic data = hermann.pedi1116all;
	
	model bldpgvn (event = "1")= edMAP/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	
	model fluidloc (event = "1")= edMAP / cl;
run;

proc logistic data = hermann.pedi1116all;
	
	model bldpgvn (event = "1")= ed_hr/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	
	model fluidloc (event = "1")= ed_hr/ cl;
run;

proc logistic data = hermann.pedi1116all;
	
	model bldpgvn (event = "1")= iss/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	
	model fluidloc (event = "1")= iss/ cl;
run;

proc logistic data = hermann.pedi1116all;
	
	model bldpgvn (event = "1")= ed_SBP/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	
	model fluidloc (event = "1")= ed_SBP/ cl;
run;

proc freq data = hermann.pedi1116all; 
	by bldpgvn;
	table transfer / measures cmh relrisk chisq missing;
run;

proc freq data = hermann.pedi1116all2; 
	by fluidloc;
	table transfer / measures cmh relrisk chisq missing;
run;

proc logistic data = hermann.pedi1116all;
	class transfer (ref = '1')/param = ref;
	model bldpgvn (event = "1")= transfer/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class transfer (ref = '1')/param = ref;
	model fluidloc (event = "1")= transfer/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class fastcom (ref = '0')/param = ref;
	model bldpgvn (event = "1")= fastcom/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class fastcom (ref = '0')/param = ref;
	model fluidloc (event = "1")= fastcom/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class fastcompos (ref = '0')/param = ref;
	model bldpgvn (event = "1")= fastcompos/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class fastcompos (ref = '0')/param = ref;
	model fluidloc (event = "1")= fastcompos/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class fastcomneg (ref = '0')/param = ref;
	model bldpgvn (event = "1")= fastcomneg/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class fastcomneg (ref = '0')/param = ref;
	model fluidloc (event = "1")= fastcomneg/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class SHI (ref = '1')/param = ref;
	model bldpgvn (event = "1")= SHI/ cl;
run;

proc logistic data = hermann.pedi1116all2;
	class SHI (ref = '1')/param = ref;
	model fluidloc (event = "1")= SHI/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class bldpgvn (ref = '0')/param = ref;
	model bldpgvn (event = "1")= bldpgvn/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class bldpgvn (ref = '0')/param = ref;
	model fluidloc (event = "1")= bldpgvn/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class fluidloc (ref = '0')/param = ref;
	model bldpgvn (event = "1")= fluidloc/ cl;
run;

proc logistic data = hermann.pedi1116all;
	class fluidloc (ref = '0')/param = ref;
	model fluidloc (event = "1")= fluidloc/ cl;
run;
/****************************************************************************************************/

/*Paper 3 analysis (correlation between MAP and the clinical and demographic variables used in papers 1 and 2)*/
/* this will include stratifications for Males and Females*/


/*checking the distribution for normality*/
proc univariate data = hermann.pedi1116all;
	var edmap;
	qqplot edmap/normal;
	histogram edmap/normal;
run;

proc univariate data = hermann.pedi1116all;
	var AGE;
	qqplot AGE/normal;
	histogram AGE/normal;
run;

proc univariate data = hermann.pedi1116all;
	var HT3;
	qqplot HT3/normal;
	histogram HT3/normal;
run;

proc univariate data = hermann.pedi1116all;
	var WT3;
	qqplot WT3/normal;
	histogram WT3/normal;
run;

/* MAP is not normal per the univariate analysis using spearman*/
ods graphics on;
proc corr data = hermann.pedi1116all plots = scatter spearman ;
	var edmap height weight ed_hr age;
run;
ods graphics off;

/*categorical variables used in spearman ?*/
proc corr data = hermann.pedi1116all plots = scatter spearman;
	var map2 ht3 wt3 iss2 hr2 transt tmat intn age1 transfer fastcom shi sex1 ethn fluidtype race1;
run;

proc sort data = hermann.pedi1116all;
	by sex1;
run;

/* correlation by sex*/
proc corr data = hermann.pedi1116all plots = scatter spearman;
	by sex1;
	var edmap height weight ed_hr age;
run;


/* Wilcoxon Mann Whitney U test for transt tmat intn transfer fastcom shi ethn*/
proc npar1way data = hermann.pedi1116all wilcoxon median;
	class sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class transt;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class tmat;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class intn;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class transfer;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class fastcom;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class shi;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon median;
	class ethn;
	var edMAP;
run;



/* Wilcoxon Mann Whitney U test by sex for transt tmat intn transfer fastcom shi ethn*/
proc npar1way data = hermann.pedi1116all wilcoxon;
	class sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class transt;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class tmat;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class intn;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class transfer;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class fastcom;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class shi;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class ethn;
	by sex1;
	var edMAP;
run;


/* kruskal wallis*/
proc npar1way data = hermann.pedi1116all wilcoxon;
	class race1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class fluidtype;
	var edMAP;
run;


/* kruskal wallis by sex*/
proc npar1way data = hermann.pedi1116all wilcoxon;
	class race1;
	by sex1;
	var edMAP;
run;

proc npar1way data = hermann.pedi1116all wilcoxon;
	class fluidtype;
	by sex1;
	var edMAP;
run;

/****************************************************************************************************/
/* Aim 2 models logistic and genmod, even though the same results are output*/

/*selecting the most influential variables from all of them based on the DAG input and a priori*/
proc logistic data = hermann.pedi1116all covout outest= hermann.alldispaper2betas;
	class intn (ref = '0') shi (ref = '1')  fastcomneg (ref = '1') fastcom (ref = '0') 
 	fluidtype (ref = '1') transfer (ref = '1') sex1 (ref = '0') ethn (ref = '1')
	map2 (ref = '2') sbp2 (ref = '3') hr2 (ref = '3') ht2 (ref = '5') wt2 (ref = '5') iss2 (ref = '1')
 	condhi (ref = '1') transt (ref = '0') age1 (ref = '5') race1 (ref = '1') race2 (ref = '1') tmat (ref = '1')/param = ref;
	model bldpgvn (event = "1")= /*edmap iss ed_hr weight height age transt fastcompos fastcomneg iss2*/   
	map2 wt2 ht2 hr2 age1 intn  shi transfer ethn fastcom 
	sex1 tmat/ selection = backward slentry= 0.3 SLSTAY=0.35 details lackfit rsq ctable;
run;

/*this is to see any outliers and influential points that either have not been address, or should be 
addressed if they have not already been confirmed as real values*/
ods listing close;
ods graphics on;
proc logistic data = hermann.pedi1116all simple covout outest= hermann.alldispaper2betasI;
	class intn (ref = '0') shi (ref = '1') transfer (ref = '1') ht2 (ref = '4') map2 (ref = '2')/param = ref;
	model bldpgvn (event = "1") = map2 intn shi age1 transfer ht2 iss2 / lackfit influence iplots;
	OUTPUT OUT=hermann.alldispaper2predI H=hat XBETA=xbeta DFBETAS=dfbetas P=phat 
	LOWER=lcl UPPER=ucl PRED=pred C=c CBAR=cbar DIFDEV=difdev DIFCHISQ=difchisq 
	predprob=(individual crossvalidate);
run;
ods graphics off;
ods html close;

proc corr data = hermann.pedi1116all spearman;
	var edmap height;
run;

/*Analysis of the final fitted model and the most significant variables are used from selection and
influence vetting*/
proc logistic data = hermann.pedi1116all simple covout outest= hermann.alldispaper2betas4;
	class intn (ref = '0') shi (ref = '1') age1 (ref = '5') transfer (ref = '1') ht2 (ref = '5') iss2 (ref = '1')map2 (ref = '2')/param = ref;
	model bldpgvn (event = "1") = map2 intn transfer SHI ht2 iss2 age1/ technique=newton nocheck 
	clodds=wald orpvalue clparm=wald nocheck cl ctable outroc=roc 
	lackfit pprob=0.5 rsq corrb cl;
	/*exact 'edmap, age, height, '
	intercept edmap age height/estimate=both;*/
	OUTPUT OUT=hermann.alldispaper2pred2  RESDEV=resdev RESCHI=reschi H=hat 
	p=phat lower=lcl upper=ucl PRED=pred PREDPROB=(individual crossvalidate);
	/*test map2=ht2;*/
	store out = hermann.alldispaper2F;
run;

proc means data=hermann.alldispaper2pred2 min max std mean mode median;
run;

PROC UNIVARIATE DATA=hermann.alldispaper2pred2;  
	HISTOGRAM resdev reschi/NORMAL(COLOR=red W=3 PERCENT=20 40 60 80 MIDPERCENTS)
	CFILL= blue CFRAME = yellow;          
RUN;

/*best blood product given model fit
out of all of  the variables = edmap intn shi ed_hr fastcomneg transfer ethn iss condhi transt bmi weight sex1 race2 age height tmat*/
proc genmod data = hermann.pedi1116all desc;
 class pt_numb intn (ref = '0') shi (ref = '1') fastcomneg (ref = '1') transfer (ref = '1') sex1 (ref = '0') 
 ethn (ref = '1') condhi (ref = '1') transt (ref = '0') race2 (ref = '1') tmat (ref = '1')/param = ref;
 model bldpgvn= edmap intn shi transfer iss age ed_hr transt fastcomneg ethn tmat weight sex1/ dist = bin link = logit type3 cl lrci;
 repeated subject = pt_numb / type = unstr;
run;

proc genmod data = hermann.pedi1116all desc;
 class pt_numb race1 (ref = '1') sex1 (ref = '0') age1 (ref = '5') transt (ref = '0') 
 tmat(ref = '0') intn (ref = '0') ethn (ref = '1') fastcom (ref = '0')/param = ref;
 model bldpgvn = edmap ed_sbp sex1 race1 age age1 ethn transt weight height tmat ISS ed_hr intn 
 Fastcom/ dist = b link = logit type3 cl lrci;
 repeated subject = pt_numb / corr = indep;
 run;

proc genmod data = hermann.pedi1116all desc;
 class pt_numb /*race1 (ref = '1') sex1 (ref = '0')*/ age1 (ref = '5') transt (ref = '0') /*tmat(ref = '0')*/ intn (ref = '0') /*ethn (ref = '1') fastcom (ref = '0')*//param = ref;
 model bldpgvn = edmap /*sex1 race1*/ age1 /*ethn*/ transt /*weight*/ height /*tmat ISS*/ ed_hr intn /*Fastcom*// dist = bin link = logit type3 cl lrci;
 /*estimate 'Relative Risk of blunt trauma having an influence on the location fluids are given' tmat 1 -1 / exp;*/
 estimate 'Relative Risk of being transported by Helicopter having an influence on the location fluids are given' transt -1 1 / exp;
 estimate 'Relative Risk of the mean arterial pressure having an influence on the location fluids are given' edmap 1 -1 / exp;
 estimate 'Relative Risk of intubation having an influence on the location fluids are given' intn 1 -1 / exp;
 /*estimate 'Relative Risk of being male having an influence on the location fluids are given' sex1 -1 1 / exp;
 estimate 'Relative Risk of being white having an influence on the location fluids are given' race2 -1 1 / exp;
 estimate 'Relative Risk of the ISS having an influence on the location fluids are given' ISS 1 -1 / exp;
 estimate 'Relative Risk of Weight having an influence on the location fluids are given' weight 1 -1 / exp;*/
 estimate 'Relative Risk of Height having an influence on the location fluids are given' height 1 -1 / exp;
 estimate 'Relative Risk of infant Age over teenage having an influence on the location fluids are given' age1 1 0 0 0 -1 / exp;
 estimate 'Relative Risk of toddler Age over teenage having an influence on the location fluids are given' age1 0 1 0 0 -1 / exp;
 estimate 'Relative Risk of child Age over teenage having an influence on the location fluids are given' age1 0 0 1 0 -1 / exp;
 estimate 'Relative Risk of pre-teen Age over teenage having an influence on the location fluids are given' age1 0 0 0 1 -1 / exp;
run;

proc genmod data = hermann.pedi1116all desc;
 class pt_numb /*race1 (ref = '1') sex1 (ref = '0')*/ age1 (ref = '5') fluidloc (ref = '0') /*transt (ref = '0') tmat(ref = '0')*/ intn (ref = '0') /*ethn (ref = '1') fastcom (ref = '0')*//param = ref;
 model bldpgvn = edmap /*sex1 race1*/ age1 fluidloc /*ethn transt weight*/ height /*tmat ISS*/ ed_hr intn /*Fastcom*// dist = bin link = logit type3 cl lrci;
 repeated subject = pt_numb / corr = indep;
 /*estimate 'Relative Risk of blunt trauma having an influence on the location fluids are given' tmat 1 -1 / exp;
 estimate 'Relative Risk of being transported by Helicopter having an influence on the location fluids are given' transt -1 1 / exp;*/
 estimate 'Relative Risk of the mean arterial pressure having an influence on the location fluids are given' edmap 1 -1 / exp;
 estimate 'Relative Risk of intubation having an influence on the location fluids are given' intn 1 -1 / exp;
 /*estimate 'Relative Risk of being male having an influence on the location fluids are given' sex1 -1 1 / exp;
 estimate 'Relative Risk of being white having an influence on the location fluids are given' race2 -1 1 / exp;
 estimate 'Relative Risk of the ISS having an influence on the location fluids are given' ISS 1 -1 / exp;
 estimate 'Relative Risk of Weight having an influence on the location fluids are given' weight 1 -1 / exp;*/
 estimate 'Relative Risk of Height having an influence on the location fluids are given' height 1 -1 / exp;
 estimate 'Relative Risk of infant Age over teenage having an influence on the location fluids are given' age1 1 0 0 0 -1 / exp;
 estimate 'Relative Risk of toddler Age over teenage having an influence on the location fluids are given' age1 0 1 0 0 -1 / exp;
 estimate 'Relative Risk of child Age over teenage having an influence on the location fluids are given' age1 0 0 1 0 -1 / exp;
 estimate 'Relative Risk of pre-teen Age over teenage having an influence on the location fluids are given' age1 0 0 0 1 -1 / exp;
run;

/****************************************************************************************************/

/* Aim 3 models logistic and genmod, again they are the same but with some estimate differences*/

/*selecting the most influential variables from all of them based on the DAG input and a priori*/
proc logistic data = hermann.pedi1116all covout outest= hermann.alldispaper2betas;
	class intn (ref = '0') shi (ref = '1') fastcomneg (ref = '1') fastcom (ref = '0') 
 	fastcompos (ref = '0') transfer (ref = '1') sex1 (ref = '0') ethn (ref = '1') 
 	condhi (ref = '1') transt (ref = '0') race1 (ref = '1') race2 (ref = '1') tmat (ref = '1')/param = ref;
	model fluidloc (event = "1") = edmap intn shi ed_hr transfer ethn condhi fastcom /*fastcompos fastcomneg*/
	weight sex1 race2 race1 age height tmat/ selection = backward SLENTRY=0.3 
	SLSTAY=0.35 details lackfit rsq ctable;
run;

/*this is to see any outliers and influential points that either have not been address, or should be 
addressed if they have not already been confirmed as real values*/
ods listing close;
ods graphics on;
proc logistic data = hermann.pedi1116all simple covout outest= hermann.alldispaper2betasI;
	class intn (ref = '0') shi (ref = '1') sex1 (ref = '0') ethn (ref = '1') transt (ref = '0') 
	race2 (ref = '1')/param = ref;
	model fluidloc (event = "1") = edmap intn ed_hr weight height fastcomneg fastcom 
	fastcompos race2 sex1/ lackfit influence iplots;
	OUTPUT OUT=hermann.alldispaper2predI H=hat XBETA=xbeta DFBETAS=dfbetas P=phat 
	LOWER=lcl UPPER=ucl PRED=pred C=c CBAR=cbar DIFDEV=difdev DIFCHISQ=difchisq 
	predprob=(individual crossvalidate);
run;
ods graphics off;
ods html close;

/*Analysis of the final fitted model and the most significant variables are used from selection and
influence vetting*/
proc logistic data = hermann.pedi1116all simple covout outest= hermann.alldispaper2betas;
	class intn (ref = '0') shi (ref = '1') sex1 (ref = '0') ethn (ref = '1') transt (ref = '0') 
	race2 (ref = '1')/param = ref;
	model fluidloc (event = "1") = edmap intn ed_hr weight height fastcomneg fastcom 
	fastcompos race2 sex1/ technique=newton 
	nocheck clodds=wald clparm=wald orpvalue ctable outroc=roc lackfit pprob=0.5 rsq corrb cl;
	exact 'edmap, ed_hr, weight, height'
	intercept edmap ed_hr weight height/estimate=both;
	OUTPUT OUT=hermann.alldispaper2pred2  RESDEV=resdev RESCHI=reschi H=hat 
	p=phat lower=lcl upper=ucl PRED=pred PREDPROB=(individual crossvalidate);
	test edmap=ed_hr;
	store out = hermann.alldispaper2F;
run;


proc means data=hermann.alldispaper2pred min max std mean mode median;
run;

PROC UNIVARIATE DATA=hermann.alldispaper2pred;  
	HISTOGRAM resdev reschi/NORMAL(COLOR=red W=3 PERCENT=20 40 60 80 MIDPERCENTS)
	CFILL= blue CFRAME = yellow;          
RUN;

proc freq data = hermann.pedi1116all; 
	table bloodpgiven * fluidloc * outcome1  / measures cmh relrisk chisq exact;
run;

/*best blood product given model fit
out of all of  the variables = edmap intn shi ed_hr fastcomneg transfer ethn iss condhi transt bmi weight sex1 race2 age height tmat*/
proc genmod data = hermann.pedi1116all desc;
 class pt_numb intn (ref = '0') shi (ref = '1') fastcomneg (ref = '1') fastcom (ref = '0') 
 fastcompos (ref = '0') transfer (ref = '1') sex1 (ref = '0') ethn (ref = '1') 
 condhi (ref = '1') transt (ref = '0') race2 (ref = '1') tmat (ref = '1')/param = ref;
 model fluidloc= edmap intn shi ed_hr transt sex1 race2 ethn/ dist = bin link = logit type3 cl lrci;
 repeated subject = pt_numb / type = unstr;
 estimate 'Relative Risk of FAST having an influence on survival outcome' intn 1 -1/ exp;
run; 

proc genmod data = hermann.pedi1116all desc;
 class pt_numb race1 (ref = '1') sex1 (ref = '0') age1 (ref = '5') transt (ref = '0') 
 tmat(ref = '0') intn (ref = '0') ethn (ref = '1') fastcom (ref = '0')/param = ref;
 model bldpgvn = edmap ed_sbp sex1 race1 age1 ethn transt weight height tmat ISS ed_hr intn 
 Fastcom/ dist = p link = log type3 cl lrci;
 repeated subject = pt_numb / corr = indep;
 run;

proc genmod data = hermann.pedi1116all desc;
 class pt_numb /*race1 (ref = '1') sex1 (ref = '0')*/ age1 (ref = '5') transt (ref = '0') /*tmat(ref = '0')*/ intn (ref = '0') /*ethn (ref = '1') fastcom (ref = '0')*//param = ref;
 model bldpgvn = edmap /*sex1 race1*/ age1 /*ethn*/ transt /*weight*/ height /*tmat ISS*/ ed_hr intn /*Fastcom*// dist = bin link = logit type3 cl lrci;
 /*estimate 'Relative Risk of blunt trauma having an influence on the location fluids are given' tmat 1 -1 / exp;*/
 estimate 'Relative Risk of being transported by Helicopter having an influence on the location fluids are given' transt -1 1 / exp;
 estimate 'Relative Risk of the mean arterial pressure having an influence on the location fluids are given' edmap 1 -1 / exp;
 estimate 'Relative Risk of intubation having an influence on the location fluids are given' intn 1 -1 / exp;
 /*estimate 'Relative Risk of being male having an influence on the location fluids are given' sex1 -1 1 / exp;
 estimate 'Relative Risk of being white having an influence on the location fluids are given' race2 -1 1 / exp;
 estimate 'Relative Risk of the ISS having an influence on the location fluids are given' ISS 1 -1 / exp;
 estimate 'Relative Risk of Weight having an influence on the location fluids are given' weight 1 -1 / exp;*/
 estimate 'Relative Risk of Height having an influence on the location fluids are given' height 1 -1 / exp;
 estimate 'Relative Risk of infant Age over teenage having an influence on the location fluids are given' age1 1 0 0 0 -1 / exp;
 estimate 'Relative Risk of toddler Age over teenage having an influence on the location fluids are given' age1 0 1 0 0 -1 / exp;
 estimate 'Relative Risk of child Age over teenage having an influence on the location fluids are given' age1 0 0 1 0 -1 / exp;
 estimate 'Relative Risk of pre-teen Age over teenage having an influence on the location fluids are given' age1 0 0 0 1 -1 / exp;
run;

proc genmod data = hermann.pedi1116all desc;
 class pt_numb /*race1 (ref = '1') sex1 (ref = '0')*/ age1 (ref = '5') fluidloc (ref = '0') /*transt (ref = '0') tmat(ref = '0')*/ intn (ref = '0') /*ethn (ref = '1') fastcom (ref = '0')*//param = ref;
 model bldpgvn = edmap /*sex1 race1*/ age1 fluidloc /*ethn transt weight*/ height /*tmat ISS*/ ed_hr intn /*Fastcom*// dist = bin link = logit type3 cl lrci;
 repeated subject = pt_numb / corr = indep;
 /*estimate 'Relative Risk of blunt trauma having an influence on the location fluids are given' tmat 1 -1 / exp;
 estimate 'Relative Risk of being transported by Helicopter having an influence on the location fluids are given' transt -1 1 / exp;*/
 estimate 'Relative Risk of the mean arterial pressure having an influence on the location fluids are given' edmap 1 -1 / exp;
 estimate 'Relative Risk of intubation having an influence on the location fluids are given' intn 1 -1 / exp;
 /*estimate 'Relative Risk of being male having an influence on the location fluids are given' sex1 -1 1 / exp;
 estimate 'Relative Risk of being white having an influence on the location fluids are given' race2 -1 1 / exp;
 estimate 'Relative Risk of the ISS having an influence on the location fluids are given' ISS 1 -1 / exp;
 estimate 'Relative Risk of Weight having an influence on the location fluids are given' weight 1 -1 / exp;*/
 estimate 'Relative Risk of Height having an influence on the location fluids are given' height 1 -1 / exp;
 estimate 'Relative Risk of infant Age over teenage having an influence on the location fluids are given' age1 1 0 0 0 -1 / exp;
 estimate 'Relative Risk of toddler Age over teenage having an influence on the location fluids are given' age1 0 1 0 0 -1 / exp;
 estimate 'Relative Risk of child Age over teenage having an influence on the location fluids are given' age1 0 0 1 0 -1 / exp;
 estimate 'Relative Risk of pre-teen Age over teenage having an influence on the location fluids are given' age1 0 0 0 1 -1 / exp;
run;
