data cleveland;
infile "/home/u49669986/Math 1322/Assignment 2/cleveland.data" delimiter=" ";
input  id
ccf
age
sex
painloc
painexer
relrest
pncaden
cp
trestbps
htn
chol
smoke
cigs
years
fbs
dm
famhist
restecg
ekgmo
ekgday
ekgyr
dig
prop
nitr
pro
diuretic
proto
thaldur
thaltime
met
thalach
thalrest
tpeakbps
tpeakbpd
dummy
trestbpd
exang
xhypo
oldpeak
slope
rldv5
rldv5e
ca
restckm
exerckm
restef
restwm
exeref
exerwm
thal
thalsev
thalpul
earlobe
cmo
cday
cyr
num
lmt
ladprox
laddist
diag
cxmain
ramus
om1
om2
rcaprox
rcadist
lvx1
lvx2
lvx3
lvx4
lvf
cathef
junk
name$
 ;
RUN;


data switzerland;
infile "/home/u49669986/Math 1322/Assignment 2/switzerland.data" delimiter=" ";
input id
ccf
age
sex
painloc
painexer
relrest
pncaden
cp
trestbps
htn
chol
smoke
cigs
years
fbs
dm
famhist
restecg
ekgmo
ekgday
ekgyr
dig
prop
nitr
pro
diuretic
proto
thaldur
thaltime
met
thalach
thalrest
tpeakbps
tpeakbpd
dummy
trestbpd
exang
xhypo
oldpeak
slope
rldv5
rldv5e
ca
restckm
exerckm
restef
restwm
exeref
exerwm
thal
thalsev
thalpul
earlobe
cmo
cday
cyr
num
lmt
ladprox
laddist
diag
cxmain
ramus
om1
om2
rcaprox
rcadist
lvx1
lvx2
lvx3
lvx4
lvf
cathef
junk
name$
 ;
RUN;
run;


data long_beach_va;
infile "/home/u49669986/Math 1322/Assignment 2/long-beach-va.data" delimiter="";
input id
ccf
age
sex
painloc
painexer
relrest
pncaden
cp
trestbps
htn
chol
smoke
cigs
years
fbs
dm
famhist
restecg
ekgmo
ekgday
ekgyr
dig
prop
nitr
pro
diuretic
proto
thaldur
thaltime
met
thalach
thalrest
tpeakbps
tpeakbpd
dummy
trestbpd
exang
xhypo
oldpeak
slope
rldv5
rldv5e
ca
restckm
exerckm
restef
restwm
exeref
exerwm
thal
thalsev
thalpul
earlobe
cmo
cday
cyr
num
lmt
ladprox
laddist
diag
cxmain
ramus
om1
om2
rcaprox
rcadist
lvx1
lvx2
lvx3
lvx4
lvf
cathef
junk
name$
 ;
RUN;

data hungarian;
infile "/home/u49669986/Math 1322/Assignment 2/hungarian.data" delimiter=" ";
input id
ccf
age
sex
painloc
painexer
relrest
pncaden
cp
trestbps
htn
chol
smoke
cigs
years
fbs
dm
famhist
restecg
ekgmo
ekgday
ekgyr
dig
prop
nitr
pro
diuretic
proto
thaldur
thaltime
met
thalach
thalrest
tpeakbps
tpeakbpd
dummy
trestbpd
exang
xhypo
oldpeak
slope
rldv5
rldv5e
ca
restckm
exerckm
restef
restwm
exeref
exerwm
thal
thalsev
thalpul
earlobe
cmo
cday
cyr
num
lmt
ladprox
laddist
diag
cxmain
ramus
om1
om2
rcaprox
rcadist
lvx1
lvx2
lvx3
lvx4
lvf
cathef
junk
name$
 ;
RUN;

proc sql;
insert into cleveland
select * 
from switzerland;
quit;

proc sql;
insert into cleveland
select * 
from long_beach_va;
quit;

proc sql;
insert into cleveland
select * 
from hungarian;
quit;

proc sql;
create table heart_disease as
select id,
ccf,
age,
sex,
painloc,
painexer,
relrest,
pncaden,
cp,
trestbps,
htn,
chol,
smoke,
cigs,
years,
fbs,
dm,
famhist,
restecg,
ekgmo,
ekgday,
ekgyr,
dig,
prop,
nitr,
pro,
diuretic,
proto,
thaldur,
thaltime,
met,
thalach,
thalrest,
tpeakbps,
tpeakbpd,
dummy,
trestbpd,
exang,
xhypo,
oldpeak,
slope,
rldv5,
rldv5e,
ca,
restckm,
exerckm,
restef,
restwm,
exeref,
exerwm,
thal,
thalsev,
thalpul,
earlobe,
cmo,
cday,
cyr,
lmt,
ladprox,
laddist,
diag,
cxmain,
ramus,
om1,
om2,
rcaprox,
rcadist,
lvx1,
lvx2,
lvx3,
lvx4,
lvf,
cathef,
junk,
name,
num
from cleveland
where (num eq 0 or num eq 1);
quit;

data heart_disease;
set heart_disease;
array variables id -- junk;
do over variables;
if variables eq -9 then variables = .;
end;
run; 

proc format;
value missfmt . = "Missing" other = "Not missing";
run;


data heart_disease;
set heart_disease;
array categorical sex relrest prop;
do over categorical;
if categorical ^= 0 and categorical ^= 1 and categorical ^= . then delete;
end;
run;

data heart_disease;
set heart_disease;
if slope ^= 1 and slope ^= 2 and slope ^= 3 and slope ^= . then delete;
run;

data heart_disease;
set heart_disease;
if chol = 0 then delete;
run;

data heart_disease;
set heart_disease;
if thal ^= 3 and thal ^= 6 and thal ^= 7 and thal ^= . then delete;
run;

proc freq data=heart_disease;
tables painloc;
run;


proc export data=heart_disease
    outfile="/home/u49669986/Math 1322/Assignment 2/prepared_heart_disease.csv"
    dbms=csv;
run;


proc import datafile = '/home/u49669986/Math 1322/Assignment 2/prepared_heart_disease.csv'
 out = work.trial
 dbms = CSV
 ;
run;






