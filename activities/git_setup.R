#| eval: false
#### 1. Sign up at GitHub.com ################################################
### 2. Configure git with Rstudio ############################################
## set your user name and email:
usethis::use_git_config(user.name = "YourName", user.email = "XXXXXX@reed.edu")
## create a personal access token for authentication:
usethis::create_github_token() 
## extend the cache timeout to match the PAT validity period:
usethis::use_git_config(helper="cache --timeout=26000000") #> cache timeout ~30 days
## set personal access token:
credentials::set_github_pat("YourPAT")
## or store it manually in '.Renviron':
usethis::edit_r_environ()
## store your personal access token in the file that opens in your editor with:
## GITHUB_PAT=xxxyyyzzz
## and make sure '.Renviron' ends with a newline
# ----------------------------------------------------------------------------
#### 4. Restart R! ###########################################################
# ----------------------------------------------------------------------------
#### 5. Verify settings ######################################################
usethis::git_sitrep()
## Your username and email should be stated correctly in the output. 
## Also, the report shoud contain something like:
## 'Personal access token: '<found in env var>''