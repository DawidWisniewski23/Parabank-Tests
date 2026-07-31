#Przypadki testowe rejestracji w aplikacji

*** Settings ***

Documentation     Testy modułu rejestracji do ParaBanku.
Resource          ../resources/pages/RegisterPage.robot    

Test Setup       Otworz Stronę Rejestracji
Test Teardown    Zamknij Stronę Banku    

*** Test Cases ***

Udana rejestracja z losowymi danymi
    [Documentation]    Testuje udaną rejestrację z losowymi danymi.
    ${username}=  Stwórz Losowego Użytkownika I Wypełnij Formularz
    Kliknij przycisk rejestracji
    Wait Until Page Contains    Welcome ${username}
    Wait Until Page Contains    Your account was created successfully. You are now logged in.

Nieudana rejestracja z niedopasowanymi hasłami
    [Documentation]    Testuje nieudaną rejestrację z niedopasowanymi hasłami.
    ${username}=  Stwórz Losowego Użytkownika I Wypełnij Formularz    override_password=Haslo123!    override_confirm_password=InneHaslo456!
    Kliknij przycisk rejestracji
    Weryfikuj komunikaty błędów dla poszczególnych pól - niedopasowane hasła    Passwords did not match.    

Nieudana rejestracja z pustym polem imienia
    [Documentation]    Testuje nieudaną rejestrację z pustym polem imienia.
    Stwórz Losowego Użytkownika I Wypełnij Formularz
    Clear Element Text    ${INPUT_FIRST_NAME}
    Kliknij przycisk rejestracji
    Weryfikuj komunikaty błędów dla poszczególnych pól - niedopasowane hasła    First name is required.    