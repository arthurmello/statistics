import pandas as pd
import os
from scipy.stats import ttest_ind, shapiro, mannwhitneyu, f_oneway, chi2_contingency
import numpy as np

# Data import
current_file = os.path.abspath(os.path.dirname(__file__))
csv_filename = os.path.join(current_file, './data/data.csv')
df = pd.read_csv(csv_filename)

# Changing data from order level to customer level
categorical_columns = [
    'User_ID','Gender', 'Occupation', 'Marital_Status', 'City_Category'
    ]
df = pd.DataFrame(df.groupby(
    categorical_columns
    ).Purchase.sum())

df.reset_index(inplace=True)  
df = df.sample(n=500, random_state=42)

print(df.shape)
print(df.head())

# Running tests
def test_result(p, ref_pvalue=0.05):
    ''' Given a p-value and a reference p-value (0.05 by default),
    will print a string indicating if we should reject or not the null
    hypothesis.
    '''
    if p<ref_pvalue:
        result="Reject null hypothesis"
    else:
        result="Don't reject null hypothesis"
        
    return result

# Student's t-test
men = df[df['Gender']=='M']
women = df[df['Gender']=='F']
ttest_results = ttest_ind(men['Purchase'], women['Purchase'])
print('T-test result: {}'.format(test_result(ttest_results[1])))

# Shapiro-Wilk test
fig = men['Purchase'].rename('Men').plot.hist(legend=True)
fig = women['Purchase'].rename('Women').plot.hist(legend=True)

shapiro_results_men = shapiro(men['Purchase'])
print('Shapiro-wilk test results for men: {}'.format(
    test_result(shapiro_results_men[1]))
    )

shapiro_results_women = shapiro(women['Purchase'])
print('Shapiro-wilk test results for women: {}'.format(
    test_result(shapiro_results_women[1]))
    )

# Mann-Whitney
mannwhitney_results = mannwhitneyu(men['Purchase'], women['Purchase'])
print(
    'Mann-Whitney test results: {}'.format(
    test_result(mannwhitney_results[1]))
    )

# ANOVA
a = df[df['City_Category']=='A']
b = df[df['City_Category']=='B']
c = df[df['City_Category']=='C']

a['Purchase'] = a['Purchase'].apply(lambda x: np.log(x))
b['Purchase'] = b['Purchase'].apply(lambda x: np.log(x))
c['Purchase'] = c['Purchase'].apply(lambda x: np.log(x))

fig.clear()
fig = a['Purchase'].rename('a').plot.hist(legend=True, alpha=0.3)
fig = b['Purchase'].rename('b').plot.hist(legend=True, alpha=0.3)
fig = c['Purchase'].rename('c').plot.hist(legend=True, alpha=0.3)


anova_results = f_oneway(
    a['Purchase'], b['Purchase'], c['Purchase']
    )

print('ANOVA test results: {}'.format(
    test_result(anova_results[1]))
    )

# Chi-squared
contingency_table = pd.crosstab(
    df['Marital_Status'],df['Occupation']
    )

chisquare_results = chi2_contingency(contingency_table)
print('Chi-squared contingency test results: {}'.format(
    test_result(chisquare_results[1]))
    )
print('Chi-squared contingency table: {}'.format(chisquare_results[3]))



