# clmpdashboard
This package has been developed principally to support work on parliamentary data in the House of Commons Library but it may be useful to other researchers working with this data. This package is still in active development and we welcome any feedback. 

## Overview
`clmpdashboard` is a package that includes functions to download data for the MP activity dashboard on the Library's website, and for joining activity data with data on Members. These joining functions are designed to work with data downloaded using the `clparlysearch` package. 

Data on MP activities often do not include unique identifiers (e.g. their MNIS id). The join is therefore based on name variables, which are present both in the MP data and the activity data. Names can be written in different ways (in terms of the order of first and last names, and the inclusion of titles) at different times, so to enable joining on name variables, the package includes functions to standardise names in both the activity and the Member datasets. These standardised names are not MPs' preferred names and should not be used for other purposes. 

Joining does not work if the names are spelled differently in the two datasets. For these 'missing names', the package uses fuzzy matching to produce a match. These matches need to be checked manually to make sure they are the correct match: the missing name in the activity data matched with that MP's standardised name in the MP data. 

Once matches have been checked, the 'missing names' are replaced in the activity data with their matches. The joined variables are removed and the activity data is once more joined with the MP data. This should now work for all MPs. 

## Installation
Install from Github using remotes.

```r
install.packages("remotes")
remotes::install_github("houseofcommonslibrary/clmpdashboard")
```

## Data download functions
`get_members` downloads data on current MPs; includes a standardised name variable; and includes a variable giving party abbreviations.

`fetch_appg_officers` uses the `parlygroups` package to download data on MPs holding officer roles on All Party Parliamentary Groups (APPGs); and adds a standardised name variable to this data, to enable joining with MP data. It has one argument, `date`, which must be specified: this is the date of publication of the register of APPGs for which data is downloaded. There is also an optional argument, `mp_noble_names`, which takes a vector of names: if there are MPs whose names as written start with a noble title (e.g. Earl Jones), these need to be specified here so they are not removed from the dataset along with peers using these noble titles.

`fetch_edm_data` downloads data on Early Day Motions (EDMs), including who signed them and who was their primary sponsor, from the Oral Questions and Motions API. It takes two arguments:

1. `start_date`, which defines the beginning of the period of interest (written as "yyy-mm-dd")
2.  `end_date`, which defines the end of the period of interest (written as "yyyy-mm-dd")

`get_debates` finds the number of debates each MP spoke in during a defined period. It takes the same `start_date` and `end_date` arguments as above, and also a `members` argument that is set to include a dataset on current MPs (downloaded using the `get_members` function) by default. The function works by scraping the number of debates from individual MP webpages on the Parliament website. 

`get_posts` downloads data on MP's government and opposition roles from the MNIS API. It takes the same `members` argument as above, which is again set to include a dataset on current MPs by default. 

## Data processing functions
`get_full_name` standardises MP's names as included in activity data, to enable joining this data with MP data. The `names` argument is a vector of names as included in the activity data.

`get_top100` finds the top 100 most spoken words for each MP. These are used in the dashboard to generate a word cloud. The function first removes stopwords (including 'parliamentary language' such as "friend", "constituency", and "minister"; political parties; months; and MPs' names). This function takes a `members` argument set to a default dataset, as above, and a `contributions_joined` argument. To obtain data in the correct format for this argument, you will need to follow three steps:

1. download data on spoken contributions made by MPs using the `clparlysearch` package;
2. create a standardised name variable for this dataset to enable joining, using the `get_full_name` function above;
3. join the contributions data with MP data (from the `get_members` function described above) using the `join_and_match` and `rejoin_data` functions described below

## Data joining functions
`join_and_match` combines activity data with MP data. It's `members` argument is set to default to MP data downloaded using the `get_members` function above. It also takes a `data` argument, which is a dataframe of activity data, including a standardised name variable obtained through using the `get_full_name` variable. The function generates a list including: 

1. `joined_data`, the activity data set with several variables with information on MPs added in;
2. `matches`, a tibble of names that were not the same in the activity and the MP data. These names have been matched using fuzzy matching and must be checked. Matches are not always available.  

The `joined_data` from above forms the input to the `rejoin_data` function, along with the `matches` once they have been manually checked and corrected where needed. It also takes a `members` argument which is again set to the same default dataset. This function removes the joined variables from the activity dataset; then replaces the names that did not match the MP data with the matches provided in the `matches` tibble; and then joins the activity data with the MP data again. 








