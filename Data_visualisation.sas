/*********************************************/
/** Data Visualisation - Micah **/
/** 1.0 base Heart_data table**/
/*********************************************/
Data heart_data;
INFORMAT num number32. exang $32. ca $32. thal $32. restecg $2.  ;
INFILE  "/home/u49669986/Math 1322/Assignment 2/prepared_heart_disease.csv" DELIMITER= "," FIRSTOBS= 2 DSD ;
INPUT id ccf age sex$ painloc painexer relrest pncaden cp trestbps htn chol smoke$ cigs years fbs dm famhist restecg ekgmo ekgday ekgyr dig prop nitr pro diuretic proto thaldur thaltime met thalach thalrest tpeakbps tpeakbpd dummy trestbpd exang xhypo oldpeak slope rldv5 rldv5e ca restckm exerckm restef restwm exeref exerwm thal thalsev thalpul earlobe cmo cday cyr lmt ladprox laddist diag cxmain ramus om1 om2 rcaprox rcadist lvx1 lvx2 lvx3 lvx4 lvf cathef junk name$ num;
FORMAT ;
RUN;

/** 1.1 PROC SQL*/
LIBNAME A2 '/home/u49669986/sasuser.v94';
DATA a2.heart_data;
    Set heart_data;
Run;

/** 1.2 PROC SQL- Create view with groups**/
Title 'Vw_Heart';
PROC SQL;
CREATE TABLE A2.vw_heart AS
SELECT * , 

CASE 	WHEN num = 0 then '<50%'
 		WHEN num = 1 then '>50%'
		Else 'Null'
		END as Diagnosis,

CASE 	WHEN sex = '1' then 'M'
		WHEN sex = '0' then 'F' 
		Else 'Null'
		END as gender,
		
CASE
	When slope = 1 THEN	'Upsloping'
	WHEN slope = 2 THEN 'Flat'
	WHEN slope = 3 THEN 'DownSloping'
	ELSE 'null'
	END as slope_v,

CASE 	When age < 35 then '[18-34]'
		When age >= 35 and age<45 then '[35-44]'
		When age >=45 and age <55 then '[45-54]'
		When age >=55 and age <65 then '[55-64]'
		When age >=65 and age <75 then '[65-74]'
		When age >=75 then '[75+]'
		Else 'Null'
		END as age_group,
	
CASE 
		WHEN Thalach <=80 	THEN '[<=80]'
		WHEN thalach >80 	and Thalach <=100 THEN '[81-100]'
		WHEN thalach >100 	and Thalach <=120 THEN '[101-120]'
		WHEN thalach >120 	and Thalach <=140 THEN '[121-140]'
		WHEN thalach >140 	and Thalach <=160 THEN '[141-160]'
		WHEN thalach >160 	and Thalach <=180 THEN '[161-180]'
		WHEN thalach >180 	and Thalach <=200 THEN '[181-200]'
		When thalach > 200 THEN '[>200]'
		ELSE 'NULL'
		END as Thalach_group,
	
CASE
		WHEN cigs >0 	and cigs <11 THEN '[<=10]'
		WHEN cigs >=11 	and cigs <20 THEN '[11-20]'
		WHEN cigs >=21 	and cigs <30 THEN '[21-30]'
		WHEN cigs >=31 	and cigs <40 THEN '[131-40]'
		WHEN cigs >=40 	THEN '[40+]'
		Else 'None'
		END as cigs_group,
		
CASE When Years = 0 then '[0]'
		WHEN Years > 0 and Years <=5 THEN '[1-5]'
		WHEN Years > 5 and Years <=10 THEN '[6-10]'
		When Years > 10 and Years <=15 THEN '[11-15]'
		WHEN Years > 15 and Years <=20 then '[16-20]'
		WHEN years > 20 and YEARS <=25 THEN '[21-25]'
		WHEN YEARS > 25 THEN '[26+]'
		Else 'None'
		END as years_group,

Case WHEN cp = 1 THEN 'Typical Angina'
	WHEN cp = 2 THEN 'Atypical Angina'
	WHEN cp = 3 THEN 'Non-Anginal Pain'
	WHEN cp = 4	THEN 'Asymptomatic'
	else 'Null'
	END as chest_pain
	
from a2.heart_data;
Quit;

/*********************************************/
/** 1.3 PROC SQL- group catogory- average Num**/
/*********************************************/
ods graphics on;
Title 'Age Group ordered by % of Patients Diagnosed';
PROC SQL;
CREATE TABLE A2.vw_agegroup AS
SELECT 
age_group as Age, COUNT(id) as Patients , 
ROUND(avg(num),0.1) as Diagnosed format percent12.1
from a2.vw_heart
group by age_group
order by Diagnosed desc;
select * from A2.vw_agegroup;
Quit;

Title 'Exercise Induced Angina by % of Patients Diagnosed';
PROC SQL;
CREATE TABLE A2.vw_exang AS
SELECT 
	case when exang like '%1%' THEN 'YES'
	when exang  like '%0%' then 'No'
	Else 'NULL' end as Exang,
 COUNT(id) as Patients , 
ROUND(avg(num),0.1) as Diagnosed format percent12.1
from a2.vw_heart
group by Exang
order by Diagnosed desc;
select * from  A2.vw_exang;
Quit;


Title 'Chest Pain by % of Patients Diagnosed';
PROC SQL;
CREATE TABLE A2.vw_chestpain AS
SELECT 
chest_pain as ChestPain, COUNT(id) as Patients, 
ROUND(avg(num),0.1) as Diagnosed format percent12.1
from a2.vw_heart
group by chest_pain
order by Diagnosed desc;
select * from  A2.vw_chestpain;
Quit;

Title 'Resting Electrocardiographic Results by % of Patients Diagnosed';
PROC SQL;
CREATE TABLE A2.vw_restecg AS
SELECT
	case 
	when restecg like '%0%' THEN 'Normal'
	when restecg  like '%1%' then 'ST-T Abnormality'
	when restecg  like '%2%' then 'Probable or Definite'
	Else 'NULL' end as Restecg,
COUNT(id) as Patients , 
ROUND(avg(num),0.1) as Diagnosed format percent12.1
from a2.vw_heart
group by Restecg
Order by Diagnosed desc;
select * from  A2.vw_restecg;
Quit;

Title 'Peak Exercise Slope by % of Patients Diagnosed';
PROC SQL;
CREATE TABLE A2.vw_slope AS
SELECT
slope_v as Slope, COUNT(id) as Patients , 
ROUND(avg(num),0.1) as Diagnosed format percent12.1
from a2.vw_heart
group by slope_v
Order by Diagnosed desc;
select * from   A2.vw_slope;
Quit;

Title 'Heart Defect (thal) by % of Patients Diagnosed';
PROC SQL;
CREATE TABLE A2.vw_thal AS
SELECT
case 
	when thal like '%3%' THEN 'Normal'
	when thal like '%6%' THEN 'Fixed Defect'
	when thal like '%7%' THEN 'Reversable Defect'
	else 'null' end as Thal , COUNT(id) as Patients , 
ROUND(avg(num),0.1) as Diagnosed format percent12.1
from a2.vw_heart
group by Thal
Order by Diagnosed desc;
select * from   A2.vw_thal;
Quit;
 

/*********************************************/
/**2.0 basic outputs**/
/*********************************************/
/**2.1 Scatter Age**/
/**2.1.1**/

Title 'Age vs Resting Blood Pressure by Diagnosis';
Footnote 'M = Male F= Female';
Proc sgplot data = A2.vw_heart;
Scatter x = age y = trestbps / group = Diagnosis markerchar=gender;
reg x = age y = trestbps / group=diagnosis  nomarkers;
Xaxis label = 'Age';
Yaxis label =  'Blood Pressure(mm Hg)';
RUN;

/**2.1.2**/
Title 'Age vs Cholesterol by Diagnosis';
Footnote 'M = Male F= Female';
Proc sgplot data = A2.vw_heart;
Scatter x = age y = chol / group = Diagnosis markerchar=gender;
reg x = age y = chol / group=diagnosis  nomarkers;
Xaxis label = 'Age';
Yaxis label =  'Cholesterol (mg/dl)';
RUN;

/**2.1.3**/
Title 'Age vs Maximum Heart Rate by Diagnosis';
Footnote 'M = Male F= Female';
Proc sgplot data = A2.vw_heart;
Scatter x = age y = thalach / group = Diagnosis markerchar=gender;
reg x = age y = thalach / group=diagnosis  nomarkers;
Xaxis label = 'Age';
Yaxis label =  'Max Heart Rate';
RUN;

/**2.1.4**/
Title 'Age vs Oldpeak by Diagnosis';
Footnote 'M = Male F= Female';
Proc sgplot data = A2.vw_heart;
Scatter x = age y = oldpeak / group = Diagnosis markerchar=gender;
reg x = age y = oldpeak / group=diagnosis  nomarkers;
Xaxis label = 'Age';
Yaxis label =  'OldPeak';
RUN;
 

/*********************************************/
/**2.2 Box Plot by groups**/
/**2.2.1**/

Title 'Distribution of Max Heart Rate Grouped By Diagnosis';
Proc SGPLOT data=A2.vw_heart;
VBOX thalach / category= diagnosis group=gender dataskin=gloss;
Yaxis label =  'Max Heart Rate';
RUN;

/**2.2.2**/
Title 'Distribution of Daily Cigs Grouped by Diagnosis';
Proc SGPLOT data=A2.vw_heart;
VBOX cigs / category= diagnosis group=gender dataskin=gloss;
Yaxis label = 'Daily Cigarettes Consumed';
RUN;

/**2.2.2**/
Title 'Distribution of Resting Blood Pressure grouped by Diagnosis';
Proc SGPLOT data=A2.vw_heart;
VBOX trestbps / category= diagnosis group=gender dataskin=gloss;
Yaxis label = 'Resting Blood Pressure on Admission (mm Hg)';
RUN;

/**2.2.3**/
Title 'Distribution of Resting Blood Pressure (bpd) by Diagnosis';
Proc SGPLOT data=A2.vw_heart;
VBOX trestbpd / category= diagnosis group=gender dataskin=gloss;
Yaxis label = 'Resting Blood Pressure (mm Hg)';
RUN;

/**2.2.4**/
Title 'Distribution of Oldpeak grouped by Diagnosis';
Proc SGPLOT data=A2.vw_heart;
VBOX oldpeak / category= diagnosis group=gender dataskin=gloss;
Yaxis label = 'ST depression induced by Exercise';
RUN;

/**2.2.5**/
Title 'Resting Heart Rate grouped by Diagnosis';
Proc SGPLOT data=A2.vw_heart;
VBOX thalrest / category= diagnosis group=gender dataskin=gloss;
Yaxis label = 'Resting HeartRate';
RUN;

/*********************************************/
/**2.3 bar graph & Categorical**/
/**2.3.1**/
Title 'Chest Pain Type vs Diagnosis';
Proc sgplot data = A2.vw_heart;
VBAR chest_pain/  GROUP=diagnosis 	groupdisplay=cluster
    stat=mean dataskin=gloss;
  	XAXIS display=(nolabel noticks) ; 
  	YAXIS grid;
    XAXIS LABEL= 'Chest Pain Type';
	YAXIS LABEL= 'Count';
RUN;

/**2.3.2**/
Title 'Exercise Induced Angina group by Diagnosis';
Proc sgplot data = A2.vw_heart;
VBAR exang/  GROUP=diagnosis 	groupdisplay=cluster
    stat=mean dataskin=gloss;
  	XAXIS display=(nolabel noticks) ; 
  	YAXIS grid;
    XAXIS LABEL= 'Exercise Induced Angina (Exang)';
	YAXIS LABEL= 'Count';
RUN;

/**2.3.3**/
Title 'Resting Electrocardiographic vs Diagnosis';
Proc sgplot data = A2.vw_heart;
VBAR restecg/  GROUP=diagnosis 	groupdisplay=cluster
    stat=mean dataskin=gloss;
  	XAXIS display=(nolabel noticks) ; 
  	YAXIS grid;
    XAXIS LABEL= 'Resting Electrocardiopgraphic (restecg)';
	YAXIS LABEL= 'Count';
RUN;

/**2.3.4**/
Title 'Slope of Peak Exercise ST vs Diagnosis';
Proc sgplot data = A2.vw_heart;
VBAR Slope_v/  GROUP=diagnosis 	groupdisplay=cluster
    stat=mean dataskin=gloss;
  	XAXIS display=(nolabel noticks) ; 
  	YAXIS grid;
    XAXIS LABEL= 'Slope';
	YAXIS LABEL= 'Count';
RUN;

/**2.3.5**/
Title 'Age Group by Diagnosis';
Proc sgplot data = A2.vw_heart;
VBAR Age_group/  GROUP=diagnosis 	groupdisplay=cluster
    stat=mean dataskin=gloss;
  	XAXIS display=(nolabel noticks) ; 
  	YAXIS grid;
    XAXIS LABEL= 'Age Group';
	YAXIS LABEL= 'Count';
RUN;


/*********************************************/
/**2.4 histogram by groups**/
/**2.4.1**/

Title 'Distribution of Age by Diagnosis';
Proc sgplot data=A2.vw_heart;
where diagnosis in ('<50%','>50%');
Histogram Age / group= diagnosis transparency=0.5 dataskin=gloss;
density Age / type=kernel group=diagnosis;
Xaxis label= 'Age';
RUN;

/**2.4.2**/
Title 'Distribution of Daily Cigarettes by Diagnosis';
Proc sgplot data=A2.vw_heart;
where diagnosis in ('<50%','>50%');
Histogram cigs / group= diagnosis transparency=0.5 dataskin=gloss;
density cigs / type=kernel group=diagnosis;
Xaxis label= 'Daily Cigarettes Consumed';
RUN;

/**2.4.3**/
Title 'Distribution of Cholesterol by Diagnosis';
Proc sgplot data=A2.vw_heart;
where diagnosis in ('<50%','>50%');
Histogram chol / group= diagnosis transparency=0.5 dataskin=gloss;
density chol / type=kernel group=diagnosis;
Xaxis label= 'Cholesterol';
RUN;

/**2.4.4**/
Title 'Distribution of Resting Blood Pressure by Diagnosis';
Proc sgplot data=A2.vw_heart;
where diagnosis in ('<50%','>50%');
Histogram trestbps / group= diagnosis transparency=0.5 dataskin=gloss;
density trestbps / type=kernel group=diagnosis;
Xaxis label= 'Resting Blood Pressure (mm Hg)';
RUN;

/**2.4.5**/
Title 'Distribution of Maximum Heart Rate by Diagnosis';
Proc sgplot data=A2.vw_heart;
where diagnosis in ('<50%','>50%');
Histogram thalach / group= diagnosis transparency=0.5 dataskin=gloss;
density thalach / type=kernel group=diagnosis;
Xaxis label= 'Maximum Heart Rate Achieved';
RUN;

Title 'Distribution of Resting Heart Rate by Diagnosis';
Proc sgplot data=A2.vw_heart;
where diagnosis in ('<50%','>50%');
Histogram thalrest / group= diagnosis transparency=0.5 dataskin=gloss;
density thalrest / type=kernel group=diagnosis;
Xaxis label= 'Resting Heart Rate';
RUN;

/*********************************************/
/**3.0 Group data**/
/*********************************************/
/**3.0.1 base view average all**/
PROC SQL;
Create table A2.vw_group as
SELECT num, diagnosis, age_group/**, gender, chest_pain, thalach_group, famhist, slope_v**/,
COUNT(id) 					as a_count,
ROUND(avg(chol),0.1) 		as a_chol,
ROUND(avg(thalach),0.1) 	as a_thalach,
ROUND(avg(cigs),1) 			as a_cigs,
ROUND(AVG(trestbps),1) 		as a_trestbps,
ROUND(AVG(trestbpd),1) 		as a_trestbpd,
ROUND(AVG(thalrest),1) 		as a_thalrest,
ROUND(AVG(oldpeak),1) 		as a_oldpeak
FROM A2.vw_heart 
GROUP BY num, diagnosis, Age_group;
QUIT;
RUN;

/**3.0.2 Sex_ split_m**/
PROC SQL;
Create table A2.vw_m as
SELECT  num, diagnosis, Age_group/**, gender, chest_pain, thalach_group, famhist, slope_v**/,
COUNT(id) 					as m_count,
ROUND(avg(chol),0.1) 		as m_chol,
ROUND(avg(thalach),0.1) 	as m_thalach,
ROUND(avg(cigs),1) 			as m_cigs,
ROUND(AVG(trestbps),1) 		as m_trestbps,
ROUND(AVG(trestbpd),1) 		as m_trestbpd,
ROUND(AVG(thalrest),1) 		as m_thalrest,
ROUND(AVG(oldpeak),1) 		as m_oldpeak
FROM A2.vw_heart 
Where gender like '%M%'
GROUP BY  num, diagnosis, Age_group;
QUIT;

/**3.0.3 Sex_ split_f**/
PROC SQL;
Create table A2.vw_f as
SELECT  num, diagnosis, Age_group,
COUNT(id) 					as f_count,
ROUND(avg(chol),0.1) 		as f_chol,
ROUND(avg(thalach),0.1) 	as f_thalach,
ROUND(avg(cigs),1) 			as f_cigs,
ROUND(AVG(trestbps),1) 		as f_trestbps,
ROUND(AVG(trestbpd),1) 		as f_trestbpd,
ROUND(AVG(thalrest),1) 		as f_thalrest,
ROUND(AVG(oldpeak),1) 		as f_oldpeak
FROM A2.vw_heart 
Where gender like '%F%'
GROUP BY  num, diagnosis, Age_group;
QUIT;

/**3.0.4 Join Group All table heart_gA**/
Title 'Variable Avereages, All & Gender vs Age group';
PROC SQL;
Create table A2.rpt_heart as
Select 
a.num,
a.Age_group, a.diagnosis,

a.a_count, 
a_chol, 
a_thalach, 
a_cigs, 
a_trestbps, 

m_count, 
m_chol, 
m_thalach, 
m_cigs, 
m_trestbps, 

f_count, 
f_chol, 
f_thalach, 
f_cigs, 
f_trestbps

FROM A2.vw_group a 
	LEFT JOIN A2.vw_m b on  	a.diagnosis = b.diagnosis and a.Age_group = b.Age_group
	LEFT JOIN A2.vw_f c on 		a.diagnosis = c.diagnosis and a.Age_group = c.Age_group 
ORDER by diagnosis ASC, Age_group;
/**select * from A2.rpt_heart where num = 1**/;
QUIT;

/**3.1 Visual- All Average variable by age group for >50%**/
/**3.1.1 chol**/

PROC SGPLOT DATA = A2.rpt_heart(where= (num = 1));
SERIES X = Age_group Y = a_chol / LEGENDLABEL = 'All' DATALABEL =a_chol;
SERIES X = Age_group Y = m_chol / LEGENDLABEL = 'Male' DATALABEL =m_chol;
SERIES X = Age_group Y = f_chol/  LEGENDLABEL = 'Female' DATALABEL =f_chol;
XAXIS LABEL= 'Age Group';
YAXIS LABEL= 'Chol (mg/dl)';
TITLE 'Ave Cholesterol by Age Group of Diagnosis >50%';
RUN;

/**3.1.2 Thalach**/
PROC SGPLOT DATA = A2.rpt_heart(where= (num = 1));
SERIES X = Age_group Y = a_thalach / LEGENDLABEL = 'All' DATALABEL = a_thalach;
SERIES X = Age_group Y = m_thalach / LEGENDLABEL = 'Male' DATALABEL = m_thalach;
SERIES X = Age_group Y = f_thalach/  LEGENDLABEL = 'Female' DATALABEL = f_thalach;
XAXIS LABEL= 'Age Group';
YAXIS LABEL= 'Max Heart Rate';
TITLE 'Max Heart by Age Group Rate of Diagnosis >50%';
RUN;

/**3.1.3 trestbps resting blood pressure**/
PROC SGPLOT DATA = A2.rpt_heart(where= (num = 1));
SERIES X = Age_group Y = a_trestbps / LEGENDLABEL = 'All'  DATALABEL =a_trestbps;
SERIES X = Age_group Y = m_trestbps / LEGENDLABEL = 'Male'  DATALABEL = m_trestbps;
SERIES X = Age_group Y = f_trestbps/  LEGENDLABEL = 'Female'  DATALABEL = f_trestbps;
XAXIS LABEL= 'Age Group';
YAXIS LABEL= 'Resting Blood PRessure';
TITLE 'Ave Resting Blood Pressure and Age Group and  of Diagnosis >50%';
RUN;

PROC SGPLOT DATA = A2.rpt_heart(where= (num = 1));
SERIES X = Age_group Y = a_cigs/ LEGENDLABEL = 'All'  DATALABEL = a_cigs;
SERIES X = Age_group Y = m_cigs/ LEGENDLABEL = 'Male'  DATALABEL =m_cigs;
SERIES X = Age_group Y = f_cigs/  LEGENDLABEL = 'Female'  DATALABEL =f_cigs;
XAXIS LABEL= 'Age Group';
YAXIS LABEL= 'Cigs Daily ';
TITLE 'Daily Cigs by Age Group of Diagnosis >50%';
RUN;
 