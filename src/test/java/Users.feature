Feature: Sample test

  Background: url 'https://gorest.co.in/public/v2/'

  Scenario: get all users
    Given url 'https://gorest.co.in/public/v2/'
    And path 'users'
    When method get
    Then status 200
    * print response
