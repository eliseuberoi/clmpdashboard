### Download all data for unit testing

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate_get_members.R")
source("tests/testthat/validate_edms_functions.R")
source("tests/testthat/validate_appg_functions.R")
source("tests/testthat/validate_roles_functions.R")
source("tests/testthat/validate_top100.R")

# Fetch all data --------------------------------------------------------------

get_members_test_data()
get_edms_test_data()
get_appg_test_data()
get_roles_functions_test_data()
get_top100_test_data()
