#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 31 16:00:56 2019

@author: cyfile
"""
import matplotlib.pyplot as plt
import pandas as pd



# a(4.2)1.Product per Department
Pro_Depar = pd.read_csv("~/Desktop/Brandeis/2019_Fall_Semester/BUS211F_Big_Data/Final_Project/PLOT_ProPerDepar.csv", sep=',')
fig, ax = plt.subplots()
ax.bar(Pro_Depar.index, Pro_Depar["Count"], color="yellow", alpha=0.6)
plt.xticks(range(0,11), Pro_Depar["Department"], rotation = 90)
ax.set_ylabel("Number of Products")
plt.show()

# a(4.2)2.Module per Department
Mod_Depar = pd.read_csv("~/Desktop/Brandeis/2019_Fall_Semester/BUS211F_Big_Data/Final_Project/PLOT_ModPerDepar.csv", sep=',')
fig, ax = plt.subplots()
ax.bar(Mod_Depar.index, Mod_Depar["Count"], color="purple", alpha=0.6)
plt.xticks(range(0,11), Mod_Depar["Department"], rotation = 90)
ax.set_ylabel("Number of Modules")
plt.show()


# b2
# b2i
q2_1 = pd.read_csv("D:/Brandeis/BIG DATA 2019/final project/PLOT_b2i1.csv", sep=',')
q2_1_1 = pd.DataFrame(q2_1)
q2_1_1['income'] = ['Under $5 yearly income', '$5k-$7.9k','$8k-$9.9k',
      '$10k-$11.9k','$12k-$14.9k','$15k-$19.9k','$20k-$24.9k',
      '$25k-$29.9k','$30k-$34.9k','$35k-$39.9k','$40k-$44.9k',
      '$55k-$59.9k','$60k-$64.9k','$65k-$69.9k','$70k-$99.9k',
      '$100.0k or more']
q2_1_1.columns = ['number','income']
fig, ax= plt.subplots()
fig.set_size_inches(18.5,10.5)
ax.barh(q2_1_1['income'],q2_1_1['number'])
ax.set_xlabel('number of household')
ax.set_ylabel('household income',)
ax.set_xticklabels(q2_1_1['number'],rotation=90)
fig.savefig("C:/Users/admin/Desktop/hh_income.png")
plt.show()

q2_1 = pd.read_csv("D:/Brandeis/BIG DATA 2019/final project/PLOT_b2i2.csv", sep=',')
q2_1_2 = pd.DataFrame(q2_1)
q2_1_2['income'] = ['Under $5 yearly income', '$5k-$7.9k','$8k-$9.9k',
      '$10k-$11.9k','$12k-$14.9k','$15k-$19.9k','$20k-$24.9k',
      '$25k-$29.9k','$30k-$34.9k','$35k-$39.9k','$40k-$44.9k',
      '$55k-$59.9k','$60k-$64.9k','$65k-$69.9k','$70k-$99.9k',
      '$100.0k or more']
q2_1_2.columns = ['number','income']
fig, ax= plt.subplots()
fig.set_size_inches(18.5,10.5)
ax.barh(q2_1_2['income'],q2_1_2['number'])
ax.set_xlabel('number of household')
ax.set_ylabel('household income',)
ax.set_xticklabels(q2_1_2['number'],rotation=90)
fig.savefig("C:/Users/admin/Desktop/hh_income_2.png")
plt.show()

# b2ii
q2_2 = pd.read_csv("D:/Brandeis/BIG DATA 2019/final project/PLOT_b2ii.csv", sep=',')
q2_2_1 = pd.DataFrame(q2_2)
q2_2_1['TC_retailer_code'] = q2_2_1.index
q2_2_1.columns = ['number','TC_retailer_code']
q2_2_1['number'].sum()
q2_2_1 = q2_2_1.nlargest(5,'number')
q2_2_1 = q2_2_1.append([{'TC_retailer_code':'Others','number':53}],ignore_index = True)
labels = q2_2_1['TC_retailer_code']
sizes = q2_2_1['number']
colors = ['lightblue', 'gray', 'lightgreen', 'lightcoral', 'orchid', 'lightsalmon']
explode = (0.1, 0, 0, 0, 0, 0)
fig, ax= plt.subplots()
fig.set_size_inches(18.5,10.5)
patches,l_text, p_text = plt.pie(sizes, explode=explode, labels=labels, 
                                 colors=colors, autopct='%1.1f%%', 
                                 shadow=False, startangle=90, pctdistance=0.7)
for t in p_text:
    t.set_size=(0.5)
plt.axis('equal')
fig.savefig("C:/Users/admin/Desktop/hh_loyalist.png")
plt.legend(loc='upper right')
plt.show()

# b2iii
q2_3 = pd.read_csv("D:/Brandeis/BIG DATA 2019/final project/PLOT_b2iii.csv", sep=',')
q2_3_1 = pd.DataFrame(q2_3)
q2_3_1['state'] = q2_3_1.index
q2_3_1.columns = ['number','state']
q2_3_1['number'].sum()
q2_3_1 = q2_3_1.nlargest(5,'number')
q2_3_1 = q2_3_1.append([{'state':'Other States','number':471}],ignore_index = True)
labels = q2_3_1['state']
sizes = q2_3_1['number']
colors = ['lightblue', 'gray', 'lightgreen', 'lightcoral', 'orchid', 'lavender']
explode = (0.1, 0, 0, 0, 0, 0)
fig, ax= plt.subplots()
fig.set_size_inches(10.5,10.5)
patches,l_text, p_text = plt.pie(sizes, explode=explode, labels=labels, colors=colors, autopct='%1.1f%%', shadow=False, startangle=90)
for t in p_text:
    t.set_size=(0.5)
fig.savefig("C:/Users/admin/Desktop/hh_state.png")
plt.show()


# b3.i. Average number of items purchased on a given month.
PATH  = "/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/"
B3_1_new  = pd.read_csv(PATH + 'B3_1_new.csv', sep=',')
fig, ax = plt.subplots()
# Plot a bar-chart of gold medals
ax.bar(B3_1_new["TC_date"], B3_1_new["AVG(prod_number)"], color = 'orange', 
       alpha = 0.7)
ax.set_xticklabels(B3_1_new["TC_date"], rotation = 90)
# Set the y-axis label
ax.set_ylabel("Average Number of Items Purchased")
plt.show()


# b3.ii. Average number of items purchased on a given month.
PATH  = "/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/"
B3_2  = pd.read_csv(PATH + 'B3_2.csv', sep=',')
# Create a Figure and an Axes with plt.subplots
fig, ax = plt.subplots()
# Plot MLY-PRCP-NORMAL from seattle_weather against the MONTH
ax.bar(B3_2["TC_date"], B3_2["AVG(TC_number)"], alpha = 0.7)
ax.set_xticklabels(B3_2["TC_date"], rotation = 90)
ax.set_ylabel("Average Number of Shopping Trips")
# Call the show function
plt.show()


# b3.iii. Average number of days between 2 consecutive shopping trips.
import seaborn as sns
PATH  = "/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/"
B3_3  = pd.read_csv(PATH + 'B3_3.csv', sep=',')
df    = B3_3
# Create a Figure and an Axes with plt.subplots
p1    = sns.kdeplot(df['AVG(TIME_GAP)'], shade=True, color="r")




# c1 plot by R

# c2
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("C2.csv")
fig, ax = plt.subplots()
ax.scatter(df["AvgPrice"], df['NumOfItem'], s=10)

ax.set_xlabel("Average Price")
ax.set_ylabel("Number of Item")
mpl.rcParams['agg.path.chunksize'] = 100000


#c3.1
# Import dataset 
PATH  = "/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/"
C3_1  = pd.read_csv(PATH + 'C3_1.csv', sep=',')
fig, ax = plt.subplots()
ax.bar(C3_1["department_at_prod_id"], C3_1["private"], label="Private_label", 
       color = "pink")
ax.bar(C3_1["department_at_prod_id"], C3_1["total"], bottom=C3_1["private"], 
       label = "Total", color = "lightblue")
ax2 = ax.twinx()
ax2.plot(C3_1["department_at_prod_id"], C3_1["percentage"], 
         color = "purple", alpha = 0.5)
ax.set_xticklabels(C3_1["department_at_prod_id"], rotation = 90)
ax.set_xlabel("Department")
ax2.set_ylabel("Percentage of Private_Label/Total")
# Display the legend
ax.legend()
plt.show()


#c3.2
# Import dataset 
PATH  = "/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/"
C3_2  = pd.read_csv(PATH + 'C3_2.csv', sep=',')
fig, ax = plt.subplots()
ax.plot(C3_2["TC_date"], C3_2["private_label/total"], 
         color = "purple", alpha = 0.5, marker = "o")
ax.set_xticklabels(C3_2["TC_date"], rotation = 90)
ax.set_xlabel("Date")
ax.set_ylabel("Percentage of Private_Label/Total")
plt.ylim((0.1, 0.2))
# Display the legend
ax.legend()
plt.show()


#c3.3
# Import dataset 
PATH  = "/Users/cyfile/Documents/Brandeis/Big Data/BigData_Final_Project/"
C3_3  = pd.read_csv(PATH + 'C3_3.csv', sep=',')
fig, ax = plt.subplots()
ax.bar(C3_3["group"], C3_3["private_cost"], label="private_cost", 
       color = "purple", alpha = 0.3)
ax.bar(C3_3["group"], C3_3["total_cost"], bottom=C3_3["private_cost"], 
       label = "total_cost", color = "yellow", alpha = 0.5)
ax2 = ax.twinx()

ax2.plot(C3_3["group"], C3_3["percentage"], 
         color = "blue", marker = "o", alpha = 0.5)
ax.set_xticklabels(C3_3["group"])
ax2.invert_yaxis()
ax2.set_ylabel("Percentage of Private_Cost/Total_Cost")
# Display the legend
ax.legend()
plt.show()
