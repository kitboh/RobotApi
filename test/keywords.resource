*** Settings ***
Documentation     This is a resource file, that can contain variables and keywords.
...               Keywords defined here can be used where this Keywords.resource in loaded.
Library           RequestsLibrary
Library           JSONLibrary
Library           Collections

*** Variables ***
${session}    session-name
${URL}      http://127.0.0.1:5000/
${headers}  {'key': 'pass'}



*** Keywords ***
Login to the API
    Create Session    ${session}    ${URL}    headers=${headers}
    ${response}=    POST On Session    ${session}    login
    Should Be Equal As Strings    ${response.json()}[message]    Login successful

Check user is logged in
    ${response}=    GET On Session    ${session}    check_login
    Should Be Equal As Strings    ${response.json()}[message]    User login status is True

Check user is logged out
    ${response}=    GET On Session    ${session}    check_login
    Should Be Equal As Strings    ${response.json()}[message]    User login status is False

Log user out
    ${response}=    POST On Session    ${session}    logout

Add entry named
    [Arguments]    ${entry_value}
    ${dict}=    Create Dictionary    entry-text    ${entry_value}
    ${json}=    evaluate    json.dumps(${dict})    json
    ${response}=    POST On Session    ${session}    add-entry    json=${json}
    Should Be Equal As Strings    ${response.json()}[message]    Entry added successfully

Check entry list contains
    [Arguments]    ${entry_value}
    ${response}=    GET On Session    ${session}    check-entries
    Should Contain    ${response.json()}    ${entry_value}