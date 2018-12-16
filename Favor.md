FavoR
================
2018-12-15

Question 1
----------

Count the number of subjects respectively in each treatment arm.(dm.sas7bdat)

| ARM      |  No\_of\_Patients|
|:---------|-----------------:|
| GDC-0449 |                98|
| Placebo  |               101|

Question 2
----------

You can include R code in the document as follows:In dm.sas7bdat, generate baseline age variable (DM.RFSTDTC - DM.BRTHDTC + 1, Subject Reference Start Date/Time minus Date/Time of Birth plus 1) for each subject and make a corresponding boxplot group by sex.

![](Favor_files/figure-markdown_github/summary-1.png)

Question 3
----------

How many subject had "Fatigue" (AE.AEDECOD, 'Dictionary-Derived Term') Adverse Event in this Study ?

| ARM      |  Fatigue\_in\_Patients|
|:---------|----------------------:|
| GDC-0449 |                     70|
| Placebo  |                     74|

Question 4
----------

What is the duration (day as unit) for each subject who had 'Cough' Adverse Event (AE.AEDECOD, 'Dictionary-Derived Term')? In additional, is there any subject who had recurrent 'Cough' events?

| USUBJID               | AEDECOD |  AE\_Duration\_Days| AESTDTC    | AEENDTC    |
|:----------------------|:--------|-------------------:|:-----------|:-----------|
| SHH4429G-S19914-16102 | Cough   |                   6| 2009-02-17 | 2009-02-23 |
| SHH4429G-S19914-16102 | Cough   |                   8| 2008-11-15 | 2008-11-23 |
| SHH4429G-S19916-15950 | Cough   |                   6| 2008-08-05 | 2008-08-11 |
| SHH4429G-S19916-15950 | Cough   |                  NA| 2008-10-27 |            |
| SHH4429G-S19916-15951 | Cough   |                   3| 2008-06-20 | 2008-06-23 |
| SHH4429G-S19917-15551 | Cough   |                 136| 2010-01-04 | 2010-05-20 |

| USUBJID               | AEDECOD |  AE\_Duration\_Days| AESTDTC    | AEENDTC    |
|:----------------------|:--------|-------------------:|:-----------|:-----------|
| SHH4429G-S19914-16102 | Cough   |                   6| 2009-02-17 | 2009-02-23 |
| SHH4429G-S19914-16102 | Cough   |                   8| 2008-11-15 | 2008-11-23 |
| SHH4429G-S19916-15950 | Cough   |                   6| 2008-08-05 | 2008-08-11 |
| SHH4429G-S19916-15950 | Cough   |                  NA| 2008-10-27 |            |
| SHH4429G-S20395-15401 | Cough   |                  78| 2009-01-30 | 2009-04-18 |
| SHH4429G-S20395-15401 | Cough   |                   8| 2009-04-18 | 2009-04-26 |

Question 5
----------

What adverse events leaded to drug withdrawn or drug interrupted (AE.AEACN)? Calculate the duration(day as unit) for those Adverse Events respectively. Is there any difference in the these kinds of AE duration between treatment arms? Hint: Boxplot; statistical tests

| USUBJID               | AEDECOD                 | AE\_Duration\_Days | AEACN            | ARM     |
|:----------------------|:------------------------|:-------------------|:-----------------|:--------|
| SHH4429G-S19914-16101 | Delusion                | NA                 | DRUG WITHDRAWN   | Placebo |
| SHH4429G-S19914-16101 | Hallucination           | NA                 | DRUG WITHDRAWN   | Placebo |
| SHH4429G-S19914-16101 | Leukopenia              | 7 days             | DRUG INTERRUPTED | Placebo |
| SHH4429G-S19914-16101 | Lymphopenia             | 7 days             | DRUG INTERRUPTED | Placebo |
| SHH4429G-S19914-16101 | Neutropenia             | 7 days             | DRUG INTERRUPTED | Placebo |
| SHH4429G-S19914-16101 | Catheter Site Infection | 13 days            | DRUG INTERRUPTED | Placebo |

    ## Don't know how to automatically pick scale for object of type difftime. Defaulting to continuous.

![](Favor_files/figure-markdown_github/AE_discontinue_ARM-1.png)

Question 6
----------

Merge ae.sas7bdat and dm.sas7bdat by patient ID, find out how many subjects had at least one adverse event in each treatment arm respectively.

| ARM      |  No\_of\_Patients|
|:---------|-----------------:|
| GDC-0449 |                98|
| Placebo  |               101|
| NA       |                NA|
| NA       |                NA|
| NA       |                NA|
| NA       |                NA|

Question 7
----------

In dm.sas7bdat, Calculate study durations of each subject (DM.RFENDTC - DM.RFSTDTC + 1). Use graphs to demonstrate if the following assumptions exist:

          Is there any potential difference of durations between female and male?
          Is there any relationship between durations and ages?

![](Favor_files/figure-markdown_github/dm_duration-1.png)![](Favor_files/figure-markdown_github/dm_duration-2.png)

![](Favor_files/figure-markdown_github/dm_duration1-1.png) \#\# Question 8

In ex.sas7bdat, calculate duration of exposure per subject per treatment and be careful about the DataType. If the time part is missing, you may think about the following imputation rules.

    If time is completely missing, impute time with 23:59:59
    If partially missing, impute with 23 for missing hours, 59 for missing minutes, 59 for missing seconds.

| USUBJID               | EXTRT          | EXTPTREF |  Explosure\_Duration\_Hours|
|:----------------------|:---------------|:---------|---------------------------:|
| SHH4429G-S19914-16100 | 5-FLUOROURACIL | VISIT 1  |                       23.85|
| SHH4429G-S19914-16100 | 5-FLUOROURACIL | VISIT 2  |                       46.50|
| SHH4429G-S19914-16100 | 5-FLUOROURACIL | VISIT 3  |                       23.92|
| SHH4429G-S19914-16100 | 5-FLUOROURACIL | VISIT 4  |                       48.00|
| SHH4429G-S19914-16100 | 5-FLUOROURACIL | VISIT 5  |                       46.17|
| SHH4429G-S19914-16100 | 5-FLUOROURACIL | VISIT 9  |                       45.67|

Question 9
----------

In tr.sas7bdat dataset, plot the graph of percentage of change from baseline of sum diametera of tumor lesion for each subject over timeb.

    a The sum diameter of tumor lesion is calculated by the sum of Longest Diameter and Perpendicular Diameter for all target lesions.

    b Use relavent study day and it is defined as Tumor Identification date minus first treatment date plus one (  TR.TRDTC - EX.EXSTDC + 1 ).

![](Favor_files/figure-markdown_github/tr_change-1.png)

Thank you.
