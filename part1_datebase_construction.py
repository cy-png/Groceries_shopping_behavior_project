#first step: import data

import pymysql
import pandas as pd
from sqlalchemy import create_engine
db = pymysql.connect(host='localhost',
user='root',
password='test123!',
db='db_consumer_panel',
charset='utf8mb4',
cursorclass=pymysql.cursors.DictCursor)
engine = create_engine('mysql+pymysql://root:test123!@localhost/db_consumer_panel')

df1 = pd.read_csv("/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/dta_at_hh_.csv", sep=',')
pd.io.sql.to_sql(df1, 'dta_at_hh', con=engine, index=False, if_exists='replace')

df2 = pd.read_csv("/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/dta_at_prod_id.csv", sep=',')
pd.io.sql.to_sql(df2, 'dta_at_prod_id', con=engine, index=False, if_exists='replace')

df3= pd.read_csv("/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/dta_at_TC.csv", sep=',')
data1=df3[0:4000000]
data2=df3[4000000:7596145]
pd.io.sql.to_sql(data1,'dta_at_TC', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(data2,'dta_at_TC', con=engine, index=False, if_exists='append')

df4= pd.read_csv("/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/dta_at_TC_upc.csv", sep=',')
print (df4)
print(df4.columns)
print(df4.shape)
d11=df4[0:2000000]
d12=df4[2000000:4000000]
d13=df4[4000000:6000000]
d14=df4[6000000:8000000]
d15=df4[8000000:10000000]
d21=df4[10000000:12000000]
d22=df4[12000000:14000000]
d23=df4[14000000:16000000]
d24=df4[16000000:18000000]
d25=df4[18000000:20000000]
d31=df4[20000000:22000000]
d32=df4[22000000:24000000]
d33=df4[24000000:26000000]
d34=df4[26000000:28000000]
d35=df4[28000000:30000000]
d41=df4[30000000:32000000]
d42=df4[32000000:34000000]
d43=df4[34000000:36000000]
d44=df4[36000000:38000000]
d45=df4[38000000:39504224]

pd.io.sql.to_sql(d11,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d12,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d13,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d14,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d15,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d21,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d22,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d23,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d24,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d25,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d31,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d32,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d33,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d34,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d35,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d41,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d42,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d43,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d44,'dta_at_TC_upc', con=engine, index=False, if_exists='append')
pd.io.sql.to_sql(d45,'dta_at_TC_upc', con=engine, index=False, if_exists='append')



# second step: adjust the column format
from sqlalchemy import create_engine, Table, Column, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base

with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER  TABLE dta_at_TC MODIFY COLUMN hh_id int(11) DEFAULT NULL COMMENT 'comments';")


# third step: create primary key and foreign key
with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER TABLE dta_at_hh ADD PRIMARY KEY(hh_id);")   

with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER TABLE dta_at_prod_id ADD PRIMARY KEY(prod_id);")   

with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER TABLE dta_at_TC ADD PRIMARY KEY(TC_id);")   

with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER TABLE dta_at_TC ADD CONSTRAINT FR_TChh FOREIGN KEY(hh_id) REFERENCES dta_at_hh(hh_id);")

with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER TABLE dta_at_TC_upc ADD CONSTRAINT FR_TCupc FOREIGN KEY(TC_id) REFERENCES dta_at_TC(TC_id);")

with db:
   cHandler=db.cursor()
   cHandler.execute("ALTER TABLE dta_at_TC_upc ADD CONSTRAINT FR_TCupcprod FOREIGN KEY(prod_id) REFERENCES dta_at_prod_id(prod_id);")
   