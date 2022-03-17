Data preprocessed_heart_data;
INFORMAT num number32. ca $32. thal $32. restecg $2.  ;
INFILE  "/home/u49669986/Math 1322/Assignment 2/prepared_heart_disease.csv" DELIMITER= "," FIRSTOBS= 2 DSD ;
INPUT id ccf age sex painloc painexer relrest pncaden cp trestbps htn chol smoke$ cigs years fbs dm famhist restecg ekgmo ekgday ekgyr dig prop nitr pro diuretic proto thaldur thaltime met thalach thalrest tpeakbps tpeakbpd dummy trestbpd exang xhypo oldpeak slope rldv5 rldv5e ca restckm exerckm restef restwm exeref exerwm thal thalsev thalpul earlobe cmo cday cyr lmt ladprox laddist diag cxmain ramus om1 om2 rcaprox rcadist lvx1 lvx2 lvx3 lvx4 lvf cathef junk name$ num;
FORMAT ;
RUN;


/* ----------------------------------------------------------------------- */
/* Chi-square Hypotheses Test  */
/* ------------------------------------------------------------------------*/
PROC FREQ DATA = preprocessed_heart_data;
TABLES num*exang 
/CHISQ expected nocol norow;


/* ----------------------------------------------------------------------- */
/* T-Test Hypotheses Test  */
/* ------------------------------------------------------------------------*/
proc ttest data= preprocessed_heart_data;
class num;
var thalach;
run;


/* ----------------------------------------------------------------------- */
/* ANOVA Hypotheses Test  */
/* ------------------------------------------------------------------------*/
PROC ANOVA data = preprocessed_heart_data;
CLASS cp;
model trestbps = cp;
run;


/* ----------------------------------------------------------------------- */
/* Logistic Regression  */
/* ------------------------------------------------------------------------*/
proc logistic data = preprocessed_heart_data;
MODEL num =  cp sex oldpeak thalach age exang chol trestbps;
run;
