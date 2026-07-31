*** Settings ***
Documentation     Page Object dla strony logowania ParaBanku.
Library           SeleniumLibrary

*** Variables ***
${URL}                  https://parabank.parasoft.com/parabank/index.htm
${INPUT_USERNAME}       name=username
${INPUT_PASSWORD}       name=password
${BTN_LOGIN}            xpath=//input[@value='Log In']
${ERROR_MESSAGE}        css=p.error, .error

*** Keywords ***
Otworz Stronę Banku
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

Wprowadz Poświadczenia
    [Arguments]    ${username}    ${password}
    Input Text        ${INPUT_USERNAME}    ${username}
    Input Password    ${INPUT_PASSWORD}    ${password}

Kliknij Przycisk Zaloguj
    Click Element     ${BTN_LOGIN}

Zaloguj Do Banku
    [Arguments]    ${username}    ${password}
    Wprowadz Poświadczenia    ${username}    ${password}
    Kliknij Przycisk Zaloguj

Weryfikuj Komunikat Bledu
    [Arguments]    ${oczekiwany_tekst}
    # Dajemy stronie do 5 sekund na przeładowanie i wyświetlenie tekstu
    Wait Until Page Contains    ${oczekiwany_tekst}    timeout=5s