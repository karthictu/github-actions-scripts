#!/bin/bash

#Input variables
PULL_REQUEST_TITLE=$1
SOURCE_BRANCH=$2
TARGET_BRANCH=$3

#Script Configs
#Title Length Constraints
MIN_LENGTH=5
MAX_LENGTH=100
JIRA_PROJECT_NAME=ABCD

#Script Constraints
#Allowed keywords for PR Titles
ALLOWED_KEYWORDS="major|minor|bug|fix|upgrade|update|revert|resolve|conflict|enable|disable|refatcor|perf|test"
#Error message for invalid PR title
MESSAGE_PRINT_TITLE_ERROR="ERROR! Bad PR Title. $PULL_REQUEST_TITLE"
GENERAL_TITLE_FORMAT="Short Message, Description (Optional) ($MIN_LENGTH-$MAX_LENGTH characters)"

#Pattern to match JIRA ID (ex. ABCD-1234)
JIRA_ID="$JIRA_PROJECT_NAME-[0-9],\s+"

#Pattern that ensures JIRA ID is followed by a message
JIRA_ID_MESSAGE_PATTERN="$JIRA_ID:.{$MIN_LENGTH,$MAX_LENGTH}"

#Patterns for different PR types
GENERAL_PATTERN="^\[($ALLOWED_KEYWORDS)\].{$MIN_LENGTH,$MAX_LENGTH}$"
#Feature Pattern required JIRA ID and message
FEATURE_PATTERN="^\[($ALLOWED_KEYWORDS)\]\s$JIRA_ID_MESSAGE_PATTERN$"
#Hotfix Pattern allows only hotfix/patch keyword (Optional)
HOTFIX_PATTERN="^(\[hotfix]\]\s)?$JIRA_ID_MESSAGE_PATTERN$"


if [[ ($TARGET_BRANCH == "^release/.$" && $SOURCE_BRANCH == "develop") && !($PULL_REQUEST_TITLE =~ $GENERAL_PATTERN) ]]; then
## Release PR from develop to release/x.y.z
echo ""
echo " $MESSAGE_PRINT_TITLE_ERROR"
echo " format: [keyword] $GENERAL_TITLE_FORMAT"
echo " example: [upgrade] Upgrade Java, Version 17"
echo " Allowed keywords: $ALLOWED_KEYWORDS"
echo ""
exit 1
elif [[ $TARGET_BRANCH == "develop" && !($PULL_REQUEST_TITLE =~ $FEATURE_PATTERN) ]]; then
## Feature PR from feature/xxx to develop
echo ""
echo " $MESSAGE_PRINT_TITLE_ERROR"
echo " format: [keyword] JIRA-ID: $GENERAL_TITLE_FORMAT"
echo " example: [feature] ORLP-1234: Implement user search"
echo " Allowed keywords: $ALLOWED_KEYWORDS"
echo ""
exit 1
elif [[ $TARGET_BRANCH == "^release/.$" && !($PULL_REQUEST_TITLE =~ $HOTFIX_PATTERN) ]]; then
## Hotfix PR from hotfix/xxx to release/x.y.z
echo ""
echo " $MESSAGE_PRINT_TITLE_ERROR"
echo " format: [patch] JIRA-ID: $GENERAL_TITLE_FORMAT"
echo " example: [patch] ORLP-1234: Fix user search, NullPointException"
echo ""
exit 1
fi
