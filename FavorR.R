#import
library(lubridate)
library(tidyverse)
library(rocheBCE)
library(magrittr)
library(tidyverse)
library(dplyr)
library(ggplot2)
dm <- read.bce('/opt/BIOSTAT/sdtm/cdp99997/ts00010/dm.sas7bdat')
AE <- read.bce('/opt/BIOSTAT/sdtm/cdp99997/ts00010/ae.sas7bdat')
ex <- read.bce('/opt/BIOSTAT/sdtm/cdp99997/ts00010/ex.sas7bdat')
tr <- read.bce('/opt/BIOSTAT/sdtm/cdp99997/ts00010/tr.sas7bdat')

# question1--------------
dm1<-dplyr::distinct(dm,USUBJID,.keep_all=TRUE)
sum <- dm %>% group_by(ARM) %>% summarise(No_of_Patients=n())
# question2----------------
dm <- mutate(dm,Baseline_Age=as.integer((as.Date(RFSTDTC)-as.Date(BRTHDTC))/365+1))
ggplot(data = dm, mapping = aes(x=SEX, y=Baseline_Age))+stat_boxplot(geom ='errorbar', width=0.3)+geom_boxplot(fill="plum")+theme_bw()+
  stat_summary(fun.y = "mean",geom="point",shape=8,size=3,na.rm = TRUE)+
  labs(title = "Box Plot of Test Results:Safety-Evaluable Patients")
# question3----------------
AE_dm <- dm %>% select(USUBJID,ARM)%>% left_join(AE,by="USUBJID")
sumAE <- AE_dm %>% filter(AEDECOD=="Fatigue")%>%dplyr::distinct(USUBJID,.keep_all=TRUE)%>%group_by(ARM)%>% summarise(Fatigue_in_Patients=n())
sumAE
# question4----------------
AE_cough<-AE_dm %>% filter(AEDECOD=="Cough")%>%mutate(AE_Duration_Days=as.integer(as.Date(AEENDTC)-as.Date(AESTDTC)))%>%
  select(USUBJID,AEDECOD,AE_Duration_Days,AESTDTC,AEENDTC)
AE_cough_recurrent<- AE_cough%>%group_by(USUBJID)%>% filter(n()>1)
# question5----------------
AE_discontinue_ARM<-AE_dm%>%mutate(AE_Duration_Days=as.Date(AEENDTC)-as.Date(AESTDTC))%>%
  filter(AEACN=="DRUG WITHDRAWN"|AEACN=="DRUG INTERRUPTED")%>%
  select(USUBJID,AEDECOD,AE_Duration_Days,AEACN,ARM)
AE_discontinue<-select(AE_discontinue_ARM,-ARM)
ggplot(data = AE_discontinue_ARM, mapping = aes(x=ARM, y=AE_Duration_Days))+stat_boxplot(geom ='errorbar', width=0.3)+geom_boxplot(fill="plum")+theme_bw()+
  stat_summary(fun.y = "mean",geom="point",shape=8,size=3,na.rm = TRUE)+
  labs(title = "Box Plot of Safety-Evaluable Patientd ")
# question6----------------
AE_patients_Num<-AE_dm %>% dplyr::distinct(USUBJID,.keep_all=TRUE)%>%
  group_by(ARM) %>% summarise(No_of_Patients=n())
AE_patients_Num
# question7----------------
dm_duration<-dm%>% mutate(study_duration_days=as.integer(as.Date(RFENDTC)-as.Date(RFSTDTC)+1))

ggplot(data = dm_duration, mapping = aes(x=SEX, y=study_duration_days))+stat_boxplot(geom ='errorbar', width=0.3)+geom_boxplot()+theme_bw()+
  stat_summary(fun.y = "mean",geom="point",shape=8,size=3,na.rm = TRUE)+
  labs(title = "Box Plot of Safety-Evaluable Patients ")

ggplot(data = dm_duration, mapping = aes(x=Baseline_Age, y=study_duration_days,color=SEX,shape=SEX))+
  geom_point()+theme_bw()+labs(title = "Shift Study Duration to Age Safety-Evaluable Patients ")
# question8----------------
ex_duration<- ex %>% mutate(EXSTDTC=ifelse(str_length(EXSTDTC)==16,str_c(EXSTDTC,":59"),
                                           no=ifelse(str_length(EXSTDTC)==10,str_c(EXSTDTC,"T23:59:59"),no=NA)))%>%
                     mutate(EXENDTC=ifelse(str_length(EXENDTC)==16,str_c(EXENDTC,":59"),
                                           no=ifelse(str_length(EXENDTC)==10,str_c(EXENDTC,"T23:59:59"),no=NA)))%>%
                     mutate(Explosure_Duration_Hours=round(as.integer((ymd_hms(EXENDTC)-ymd_hms(EXSTDTC)))/3600,digits = 2))%>%
                     select(USUBJID,EXTRT,EXTPTREF,Explosure_Duration_Hours)%>%
                     filter(Explosure_Duration_Hours!=0)
head(ex_duration)
# question9----------------
tr_select<- tr%>%filter(TRCAT == "TARGET LESIONS")%>%spread(key = TRTESTCD,value = TRSTRESN)%>%
  mutate(LDIAM=ifelse(is.na(LDIAM),0,no=LDIAM),
  PDIAM=ifelse(is.na(PDIAM),0,no=PDIAM))%>%
  mutate(DIAM=LDIAM+PDIAM)
tr_sum<-tr_select%>%group_by(USUBJID,VISITNUM,TRDTC)%>%summarise(sum=sum(DIAM))%>%arrange(desc(TRDTC))%>%distinct(USUBJID,VISITNUM,.keep_all=TRUE)
tr_baseline<-tr_sum %>% arrange(VISITNUM)%>% group_by(USUBJID)%>% slice(1)%>% rename(base=sum)%>%select(USUBJID,base)
ex_first_treat<-ex%>%filter(EXTPTREF=="VISIT 1")%>%select(USUBJID,EXRFTDTC)%>%distinct(USUBJID,EXRFTDTC)
tr_change<-tr_sum %>%left_join(tr_baseline,by="USUBJID")%>%mutate(change=as.double(sum-base)/base*100)
tr_change_duration<-tr_change%>%left_join(ex_first_treat,by="USUBJID")
tr_change_duration$Time_Days <- as.integer(as.Date(tr_change_duration$TRDTC)-as.Date(tr_change_duration$EXRFTDTC))
tr_lable<-tr_change_duration%>%arrange(desc(Time_Days))%>%group_by(USUBJID)%>%slice(1)%>%
  mutate(id=str_c("id-",str_sub(USUBJID,17,23)))
ggplot(tr_change_duration,mapping = aes(Time_Days,change))+
  geom_point(aes(color=USUBJID),size=3,show.legend = F)+
  geom_line(aes(color=USUBJID),size=1,show.legend = F)+theme_bw()+
  geom_text(data=tr_lable,aes(label=id),hjust=-0.2, size=3.6)+
  labs(x="Time(Days)",y="Change(%) From Baseline",
       title = "Percentage of Change from Baseline of Sum Diametera of Tumor Lesion for Each Subject Over Time")+ylim(c(-150,250))
