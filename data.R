# Data Wrangling
library(dplyr)
library(reshape2)

# Statistical Analysis: Regression
library(survey)
library(forecast)

# Statistical Analysis: Trees
library(tree)
library(randomForest)

# Visualization and Reporting
library(pander)
library(gridExtra)
library(ggplot2)
library(stargazer)

#
# SQL queries not needed (saved to 'dep.csv')
# 
# # ==== Load NHIS Data from Postgres Database ====
# source('postgres_pw.R')  # Get Postgres password and user name
# source('sql_queries.R')
# 
# nhis_db <- src_postgres("nhis", user=postgres_user, password=password)
# 
# # ==== Load Person File for Each Year ====
# # Create a bunch of temporary tables
# for (yr in DATA_RANGE) {
#   compute(
#     tbl(nhis_db,
#         sql(sprintf(
#           query.person_gen,
#           yr)
#         )),
#     name=sprintf("person_%s", yr))
# }
# 
# # ==== Load Adult Disability File for Each Year ====
# # Keep this for loop separate from above to allow for easier debugging
# for (yr in DATA_RANGE) {
#   compute(
#     tbl(nhis_db,
#         sql(sprintf(
#           query.sample_adult_gen(yr),
#           yr)
#         )),
#     name=sprintf("sample_adult_%s", yr))
# }
# 
# # ==== Load Family File for Each Year ====
# # Keep this for loop separate from above to allow for easier debugging
# for (yr in DATA_RANGE) {
#   compute(
#     tbl(nhis_db,
#         sql(sprintf(
#           query.family_gen,
#           yr)
#         )),
#     name=sprintf("family_%s", yr))
# }
# 
# # ==== Create Aggregate Depression File for Each Year ====
# # Keep this for loop separate from above to allow for easier debugging
# for (yr in DATA_RANGE) {
#   compute(
#     tbl(nhis_db,
#         sql(sprintf(
#           query.dep_gen,
#           yr, yr, yr)
#         )),
#     name=sprintf("depression_%s", yr))
# }
# 
# # ==== Not Used: Create Aggregate Disability File for 2012-2013 ====
# # Keep this for loop separate from above to allow for easier debugging
# # for (yr in DISAB_RANGE) {
# #   compute(
# #     tbl(nhis_db,
# #         sql(sprintf(
# #           query.adult_disab_gen,
# #           yr, yr, yr, length(DISAB_RANGE), yr)
# #         )),
# #     name=sprintf("adult_disab_%s", yr))
# # }
# 
# # ==== Not Used: Create temporary table for aggregate disability data ====
# # compute(tbl(nhis_db, sql("
# #                          SELECT * FROM
# #                          adult_disab_2012 UNION ALL
# #                          SELECT * FROM
# #                          adult_disab_2013")),
# #         name="adult_disab_all")
# #
# # disab <- collect(tbl(nhis_db, sql("SELECT * FROM adult_disab_all")))
# 
# # ==== Load 2007-2013 Depression Data ====
# # Create temporary table for aggregate depression data
# compute(tbl(nhis_db, sql("
#                          SELECT * FROM
#                          depression_2007 UNION ALL
#                          SELECT * FROM
#                          depression_2008 UNION ALL
#                          SELECT * FROM
#                          depression_2009 UNION ALL
#                          SELECT * FROM
#                          depression_2011 UNION ALL
#                          SELECT * FROM
#                          depression_2012 UNION ALL
#                          SELECT * FROM
#                          depression_2013")),
#   name="depression_all")
# 
# # Get aggregate data
# dep <- collect(tbl(nhis_db, sql("SELECT * FROM depression_all")), n=Inf)
# 
# # Add column which determines assignment to test set
# set.seed(420)
# dep[, "test"] <- ifelse(runif(n=nrow(dep), min=0, max=1) <= 0.2, yes=1, no=0)
# 
# # ==== Save Aggregated Depression Data to CSV ====
# write.csv(dep, "dep.csv")

# ==== Load Data from Saved CSV Instead of SQL ====
dep <- read.csv('dep.csv', header=TRUE)

# ==== Testing and training set labels ====
dep.train_labels.worthless <- dep %>%
  filter(test == 0) %>%
  select(worthless_once)

dep.test_labels.worthless <- dep %>%
  filter(test == 1) %>%
  select(worthless_once)

dep.train_labels.hopeless <- dep %>%
  filter(test == 0) %>%
  select(hopeless_once)

dep.test_labels.hopeless <- dep %>%
  filter(test == 1) %>%
  select(hopeless_once)

dep.train_labels.sleep <- dep %>%
  filter(test == 0) %>%
  select(abnormal_sleep)

dep.test_labels.sleep <- dep %>%
  filter(test == 1) %>%
  select(abnormal_sleep)

# ==== Logistic Regression ====
dep_design = svydesign(ids=~0,
                       data=dep %>% filter(test == 0),
                       weights=dep %>% filter(test == 0) %>% select(weight_sa))

# Create a shorthand for running a GLM with my default desired parameters
dep_glm <- function(frml) {
  return(svyglm(frml, 
                design=dep_design,
                family=binomial(link='logit'),
                method="glm.fit"))
}