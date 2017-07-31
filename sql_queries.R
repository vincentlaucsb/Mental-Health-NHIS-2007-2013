# Naming Convention:
# Anything prefixed with nhis --> Original data
# Anything without            --> Subset of variables I'm using

# Reminders:
# Adjust weights when aggregating (currently only done for Sample Adult)

# Consult data documentation for full variable definitions
# Lots of binary variables (Yes/No) are coded as 1 = Yes, 2 = No
# These SQL queries should recode them to 1 = Yes, 0 = No

# DATA_RANGE <- c("2006", "2007", "2008", "2009", "2011", "2012", "2013")
# 2006 has income coded differently --> drop it for now
DATA_RANGE <- c("2007", "2008", "2009", "2011", "2012", "2013")
DISAB_RANGE <- c("2012", "2013")

# %s = Year
query.person_gen <- "
  SELECT
    fpx,
    hhx || '.' || fmx || '.' || fpx as person_id,
    hhx || '.' || fmx as family_id,

    -- Basic Info
    (sex = 1)::integer as male,
    srvy_yr,
    intv_qrt,
    (srvy_yr::text || '.' || intv_qrt::text) as qrt_yr,
  
    -- Government Assistance
    (ptanf = 1)::integer as welfare,
    (powben = 1)::integer as other_welfare,
    (pwic = '1')::integer as wic,
  
    /* Race Recode
       ---------------------
      Original Definition:
      1 Hispanic
      2 Non-Hispanic White
      3 Non-Hispanic Black
      4 Non-Hispanic Asian
      5 Non-Hispanic All other race groups
    */
  
    hiscodi3 as race,
    (hiscodi3 = 1)::integer as hispanic,
    (hiscodi3 = 2)::integer as white,
    (hiscodi3 = 3)::integer as black,
    (hiscodi3 = 4)::integer as asian,
    (hiscodi3 = 5)::integer as other_race,
  
    wtfa as weight
    -- intv_mon
    FROM nhis_person_%s
"

# Generate query to get variables I want from year
query.sample_adult_gen <- function(year) {
  # Account for changing variable names in 2013 NHIS
  if (year == "2013") {
    worthless_var_name = "asiwthls"
    hopeless_var_name = "asihopls"
    sleep_var_name = "asisleep"
  } else {
    worthless_var_name = "worthls"
    hopeless_var_name = "hopeless"
    sleep_var_name = "sleep"
  }
  
  return(sprintf("
    SELECT
      hhx || '.' || fmx || '.' || fpx as person_id,
      age_p::integer as age,      -- No missing values because of it's importance

      -- Divide weights by number of years we're aggregating by
      wtfa_sa as weight_sa_raw,
      wtfa_sa/%s as weight_sa,

      -- Marital Status
      (r_maritl = 1)::integer as married,

      -- Employment
      doinglwa as job_status,
      (doinglwa = '3')::integer as looking_for_work,
      
      whynowka as not_working,
      (whynowka = '3')::integer as retired,
      (whynowka = '9')::integer as not_working_disabled,

      (everwrk = '1')::integer as ever_worked,

      -- Pain
      (paineck = 1)::integer as neck_pain,
      (painlb = 1)::integer as back_pain,

      %s as worthless,

      -- Create a binary variable
      -- 1: Felt worthless at least once
      -- 0: Never felt worthless
      (%s != 5)::integer as worthless_once,

      %s as hopeless,

      -- Create a binary variable
      -- 1: Felt hopeless at least once
      -- 0: Never felt hopeless
      (%s != 5)::integer as hopeless_once,

      -- Depression or Anxiety
      aflhca17 as dep_diff,
      altime17 as dep_time,

      -- Hours of Sleep
      %s as sleep,
      (%s < 6 OR %s > 10) as abnormal_sleep,

      -- Alcohol Use
      alc1yr, alclife, alc12mno, alc12mtp, alc12mwk, alcstat, alc5upno, alc5upyr,

      -- Recode alc12mwk and alc12mno    
      multi_replace(alc12mwk, ARRAY['95'], ARRAY['0'], '0')::integer as alc12mwk2,
      multi_replace(alc12mno, ARRAY[''], ARRAY[''], '0')::integer as alc12mno2
  
      FROM nhis_sample_adult_%s
      
      WHERE %s < 6        -- Remove missing income values
        AND %s < 25       -- Remove missing sleep values
        AND doinglwa < 8  -- Remove missing job status values
        AND r_maritl < 9  -- Remove missing marital status values
        
      -- Remove missing values (but keep nulls)
        AND (alc12mwk::integer < 96 OR alc12mwk IS NULL)  -- Alcohol Use
        AND (everwrk::integer < 7 OR everwrk IS NULL)     -- Job status
    ", length(DATA_RANGE), worthless_var_name, worthless_var_name,
       hopeless_var_name,
       hopeless_var_name, sleep_var_name, sleep_var_name, sleep_var_name,
       year, worthless_var_name, sleep_var_name))
}

query.family_gen <- "
  SELECT
    hhx || '.' || fmx as family_id,
    (flngintv = 1)::integer as english,
    fm_size as family_size,
    
    /* Family Income Recode
     ---------------------
     Original Definition:
     01 $0 - $34,999
     02 $35,000 - $49,999
     03 $50,000 - $74,999
     04 $75,000 - $99,999
     05 $100,000 and over
     06 $0 - $49,999 (no further detail)
     07 $50,000 and over (no further detail)
     08 $50,000 - $99,999 (no further detail)
     99 Unknown

     New Definition: Create dummies for 01-05, drop rest
    */

    incgrp2 as fam_income,
    (incgrp2 = 1)::integer as fam_income0_35k,
    (incgrp2 = 2)::integer as fam_income35_50k,
    (incgrp2 = 3)::integer as fam_income50_75k,
    (incgrp2 = 4)::integer as fam_income75_100k,
    (incgrp2 = 5)::integer as fam_income101k

    FROM nhis_family_%s

    -- Remove missing income values
    WHERE incgrp2 < 6
"

query.dep_gen <- "
  SELECT
  *,

  -- Race Names --
  multi_replace(race::text,
    ARRAY['1', '2', '3', '4', '5'],
    ARRAY['Hispanic, any race',
    'Non-Hispanic White',
    'Non-Hispanic Black',
    'Non-Hispanic Asian',
    'Non-Hispanic Other Race']) as race_name,
  
  -- Income Group Names --
  multi_replace(fam_income::text,
    ARRAY['1', '2', '3', '4', '5'],
    ARRAY['$0 - $34,999',
          '$35,000 - $49,999',
          '$50,000 - $74,999',
          '$75,000 - $99,999',
          '$100,000 and over']) as fam_income_name

  FROM
  -- Person Level File
    person_%s

  JOIN
    -- Sample Adult File
    sample_adult_%s
    USING (person_id)

  JOIN
    -- Family Level File
    family_%s
    USING (family_id)"

query.adult_disab_gen <- "
  SELECT * FROM
    person_%s
  JOIN
    family_%s
    USING (family_id)
  JOIN
    sample_adult_%s
    USING (person_id)
  JOIN
    (SELECT
      hhx || '.' || fmx || '.' || fpx as person_id,
  
      -- Divide weights by number of years we're aggregating over
      wtfa_afd/%s as weight_afd,
  
      (hear_1r = 1)::integer as hearing_aid,
      (mob_2r = 1)::integer as mobility_aid,
      ub_2 as hand_disability,
      anx_1, anx_2, anx_3r::integer,
      dep_1, dep_2, dep_3r::integer
      FROM nhis_adult_disability_%s
  
    -- Remove missing values
    WHERE anx_1 < 6
      AND dep_1 < 6
      AND hear_1r < 3
      AND mob_2r < 3
      AND ub_2 < 3) as adult_disab
  USING (person_id)"