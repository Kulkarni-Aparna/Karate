Feature: Sample test

  Background: 
    * url 'https://restful-booker.herokuapp.com/'
    * def jsonBodyForPut =
      """
          {"firstname" : "James","lastname" : "Brown","totalprice" : 111,"depositpaid" : true,"bookingdates" : {"checkin" : "2018-01-01","checkout" : "2019-01-01"},"additionalneeds" : "Breakfast"}
      """
    * def jsonBodyForPost =
      """
          {"firstname" : "Jim","lastname" : "Brown","totalprice" : 111,"depositpaid" : true,"bookingdates" : {"checkin" : "2018-01-01","checkout" : "2019-01-01"},"additionalneeds" : "Breakfast"}
      """

  Scenario: get all bookings
  Given path 'booking'
  When method get
  Then status 200
  * print response
  
  Scenario: create new booking
    Given url 'https://restful-booker.herokuapp.com/auth'
    And request
      """
      {
      "username" : "admin",
      "password" : "password123"
      }
      """
    When method post
    Then status 200
    * print response
    * def authToken = 'token='+response.token
    
    Given url 'https://restful-booker.herokuapp.com/'
    And path 'booking'
    And header Content-Type = 'application/json'
    And request jsonBodyForPut
    When method post
    Then status 200
    * print response
    * def bid = response.bookingid
    * print bid

    Given path 'booking/'+bid
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = authToken
    And request jsonBodyForPut
    When method put
    Then status 200
    * print response
    And match response.firstname == "James"
    
    Given path 'booking/'+bid
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And header Cookie = authToken
    And request
      """
      {
      	"firstname" : "James",
      	"lastname" : "Brown",
      }
      """
    When method patch
    Then status 200
    * print response
    And match response.firstname != "Jim"

    Given path 'booking/'+bid
    And header Content-Type = 'application/json'
    And header Cookie = authToken
    When method delete
    Then status 201
    * print response