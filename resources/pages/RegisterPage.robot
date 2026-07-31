#Akcje dla rejestracji w aplikacji banku
*** Settings ***
Documentation     Page Object dla strony rejestracji ParaBanku.
Library           SeleniumLibrary
Library           String

*** Variables ***
${URL}              https://parabank.parasoft.com/parabank/register.htm    
${INPUT_FIRST_NAME}   name=customer.firstName
${INPUT_LAST_NAME}    name=customer.lastName
${INPUT_ADDRESS}      name=customer.address.street
${INPUT_CITY}         name=customer.address.city
${INPUT_STATE}        name=customer.address.state
${INPUT_ZIP_CODE}     name=customer.address.zipCode
${INPUT_PHONE}        name=customer.phoneNumber
${INPUT_SSN}          name=customer.ssn
${INPUT_USERNAME}     name=customer.username
${INPUT_PASSWORD}     name=customer.password
${INPUT_CONFIRM_PASSWORD}  name=repeatedPassword
${BTN_REGISTER}       xpath=//input[@value='Register']    

*** Keywords ***
Otworz Stronę Rejestracji
    [Documentation]    Otwiera przeglądarkę Chrome w trybie headless.
    # W jednym kroku Pythona tworzymy i konfigurujemy options
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Evaluate    $options.add_argument('--headless=new')
    Evaluate    $options.add_argument('--no-sandbox')
    Evaluate    $options.add_argument('--disable-dev-shm-usage')
    Evaluate    $options.add_argument('--window-size=1920,1080')     

    Open Browser    ${URL}    chrome    options=${options}    

Zamknij Stronę Banku
    Close Browser    

Kliknij przycisk rejestracji
    Click Element    ${BTN_REGISTER}

Stwórz Losowego Użytkownika I Wypełnij Formularz
    [Arguments]    ${override_password}=${NONE}    ${override_confirm_password}=${NONE}
    
    # 1. Generujemy unikalne dane
    ${random_str}=    Generate Random String    6    [LOWER][NUMBERS]
    ${username}=      Set Variable    user_${random_str}
    ${pass}=          Set Variable    Haslo123!
    
    # 2. Logic dla hasła – używa wartości domyślnej LUB tej przekazanej w argumentach
    ${password}=          Set Variable If    '${override_password}' != 'None'          ${override_password}          ${pass}
    ${confirm_password}=  Set Variable If    '${override_confirm_password}' != 'None'  ${override_confirm_password}  ${pass}

    # 3. Wypełniamy formularz
    Input Text     ${INPUT_FIRST_NAME}        Jan
    Input Text     ${INPUT_LAST_NAME}         Kowalski
    Input Text     ${INPUT_ADDRESS}           Przykładowa 1
    Input Text     ${INPUT_CITY}              Warszawa
    Input Text     ${INPUT_STATE}             Mazowieckie
    Input Text     ${INPUT_ZIP_CODE}          00-001
    Input Text     ${INPUT_PHONE}             123456789
    Input Text     ${INPUT_SSN}               123-45-6789
    Input Text     ${INPUT_USERNAME}          ${username}
    Input Password  ${INPUT_PASSWORD}          ${password}
    Input Password  ${INPUT_CONFIRM_PASSWORD}  ${confirm_password}
    
    # Zwracamy wygenerowany username na wypadek, gdyby test chciał go zweryfikować
    RETURN         ${username}

Weryfikuj komunikaty błędów dla poszczególnych pól - niedopasowane hasła
    [Arguments]    ${oczekiwany_tekst}
    Wait Until Page Contains    ${oczekiwany_tekst}    timeout=5s