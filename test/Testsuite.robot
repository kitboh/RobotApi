*** Settings ***
Documentation     A test suite for valid login.
...
...               Keywords are imported from the resource file
Library          RequestsLibrary
Resource         Keywords.resource
Default Tags      positive

*** Variables ***
${URL}      http://127.0.0.1:5000/
${headers}  {'key': 'pass'}


*** Test Cases ***
Failing Login Request
    ${response}=    POST  ${URL}login
    Should Be Equal As Strings    ${response.json()}[message]    Invalid key

Successful Login Request
    Create Session    login-request    ${URL}    headers=${headers}
    ${response}=    POST On Session  login-request  login
    Should Be Equal As Strings    ${response.json()}[message]    Login successful

Quick Check Login Request
    Create Session    login-check    ${URL}    headers=${headers}
    ${response}=    POST On Session    login-check    login
    Should Be Equal As Strings    ${response.json()}[message]    Login successful
    ${response}=    GET On Session    login-check    check_login
    Should Be Equal As Strings    ${response.json()}[message]    User login status is True
    ${response}=    POST On Session    login-check    logout
    ${response}=    GET On Session    login-check    check_login
    Should Be Equal As Strings    ${response.json()}[message]    User login status is False

Quick Login Keyword Request
    Login to the API
    Check user is logged in
    Log user out
    Check user is logged out

Quick Check Entries Request
    ${response}=    GET  ${URL}check-entries

Quick Add Entries Request
    ${response}=    POST  ${URL}check-entries

Quick Logout Request
    ${response}=    POST  ${URL}logout

Add entries and validate saving
    Login to the API
    Check user is logged in
    Add entry named    test-entry
    Check entry list contains    test-entry
