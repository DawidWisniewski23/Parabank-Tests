#Przypadki testowe

*** Settings ***
Documentation     Testy modułu logowania do ParaBanku.
Resource          ../resources/pages/LoginPage.robot

Test Setup       Otworz Stronę Banku
Test Teardown    Zamknij Stronę Banku

*** Test Cases ***

Nieudane logowanie - Błędne hasło
    [Documentation]    Test sprawdzający nieudane logowanie z powodu błędnego hasła
    Zaloguj Do Banku    nieistniejące_hasło   ZłeHasło123
    Weryfikuj Komunikat Bledu    The username and password could not be verified.

Nieudane logowanie - Puste pola
    [Documentation]    Test sprawdzający nieudane logowanie z powodu pustych pól
    Zaloguj Do Banku    ${EMPTY}   ${EMPTY}
    Weryfikuj Komunikat Bledu    Please enter a username and password.    

Udane logowanie - Poprawne dane
    [Documentation]    Test sprawdzający udane logowanie z poprawnymi danymi
    Zaloguj Do Banku    login   hasło
    # Tutaj można dodać dodatkowe kroki weryfikujące udane logowanie, np. sprawdzenie obecności elementu na stronie po zalogowaniu.    