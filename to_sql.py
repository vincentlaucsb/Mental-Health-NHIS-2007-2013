import sqlify

# ==== Person Files ====
# sqlify.csv_to_pg(
    # 'data/36147-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2013',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/36146-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2012',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/36145-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2011',
    # header=0, na_values=' ')
    
# # 2010 Data Missing
    
# sqlify.csv_to_pg(
    # 'data/28721-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2009',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/27341-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2008',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/27201-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2007',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/20681-0003-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_person_2006',
    # header=0, na_values=' ')

# sqlify.txt_to_pg(
    # '04606-0003-Data.txt',
    # database='nhis',
    # delimiter=' ',
    # name='nhis_person_2005',
    # na_values=' ')
    
# sqlify.txt_to_pg(
    # '04349-0003-Data.txt',
    # database='nhis',
    # delimiter=' ',
    # name='nhis_person_2004',
    # na_values=' ')
    
# sqlify.txt_to_pg(
    # '04222-0003-Data.txt',
    # database='nhis',
    # delimiter=' ',
    # name='nhis_person_2003',
    # na_values=' ')
    
# sqlify.txt_to_pg(
    # '04176-0003-Data.txt',
    # database='nhis',
    # delimiter=' ',
    # name='nhis_person_2002',
    # na_values=' ')
    
# sqlify.txt_to_pg(
    # '03605-0003-Data.txt',
    # database='nhis',
    # delimiter=' ',
    # name='nhis_person_2001',
    # na_values=' ')
    
# sqlify.txt_to_pg(
    # '03381-0003-Data.txt',
    # database='nhis',
    # delimiter=' ',
    # name='nhis_person_2000',
    # na_values=' ')
    
# ==== Sample Adult Files ====
# sqlify.csv_to_pg(
    # 'data/sample_adult/36147-0004-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_sample_adult_2013',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/sample_adult/36146-0004-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_sample_adult_2012',
    # header=0, na_values=' ')
    
sqlify.csv_to_pg(
    'data/sample_adult/36145-0004-Data.tsv',
    database='nhis',
    delimiter='\t',
    name='nhis_sample_adult_2011',
    header=0, na_values=' ')
    
# 2010 Data Missing
    
sqlify.csv_to_pg(
    'data/sample_adult/28721-0004-Data.tsv',
    database='nhis',
    delimiter='\t',
    name='nhis_sample_adult_2009',
    header=0, na_values=' ')
    
sqlify.csv_to_pg(
    'data/sample_adult/27341-0004-Data.tsv',
    database='nhis',
    delimiter='\t',
    name='nhis_sample_adult_2008',
    header=0, na_values=' ')
    
sqlify.csv_to_pg(
    'data/sample_adult/27201-0004-Data.tsv',
    database='nhis',
    delimiter='\t',
    name='nhis_sample_adult_2007',
    header=0, na_values=' ')
    
# ==== Disability Files ====
# sqlify.csv_to_pg(
    # 'data/disability/36147-0008-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_adult_disability_2013',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/disability/36146-0008-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_adult_disability_2012',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/disability/36145-0007-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_adult_disability_2011',
    # header=0, na_values=' ')
    
# ==== Family Data Files ====
# sqlify.csv_to_pg(
    # 'data/family/36147-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2013',
    # header=0, na_values=' ')
    
# sqlify.csv_to_pg(
    # 'data/family/36146-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2012',
    # header=0, na_values=' '
# )

# sqlify.csv_to_pg(
    # 'data/family/36145-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2011',
    # header=0, na_values=' '
# )

# sqlify.csv_to_pg(
    # 'data/family/28721-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2009',
    # header=0, na_values=' '
# )

# sqlify.csv_to_pg(
    # 'data/family/27341-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2008',
    # header=0, na_values=' '
# )

# sqlify.csv_to_pg(
    # 'data/family/27201-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2007',
    # header=0, na_values=' '
# )

# sqlify.csv_to_pg(
    # 'data/family/20681-0002-Data.tsv',
    # database='nhis',
    # delimiter='\t',
    # name='nhis_family_2006',
    # header=0, na_values=' '
# )