Twilio callback service
=======================

Twilio is a call back service that enables hotelier and countries which don't have the ability or infrastructure to dial free phone numbers to receive a free call. Currently the service can only by accessed from the structured intake/Contact Us page on EPC Help page. The following countries are set up with the Twilio service
* Aruba
* Bahamas
* Bonaire, Sint Eustatius and Saba Gambia
* Ghana
* Haiti
* Malta
* Netherlands Antillies
* Nigeria
* Qatar, State of
* St Martin
* St. Barthelemy
* Tunisia
* U.S. Virgin Islands
Below is a highlevel overview on how we add new countries to the service with the Salesforce integration on the EPC Contact Us form

Part 1: Enabling the country for telephone support
--------------------------------------------------
1. Within Salesforce Staging environment go to Setup/List Support Contact Details
2. Add or ensure a support number is entered into LO Primary Phone Number
3. If not, add the phone number obtained from the telpehony team, save and check the Contact Us form on https://expediagso.secure.force. com/kb/?cu=1&fs=ContactUs&l=en_US
4. You should see the country listed as well as phone number entered in step 2
               
Part 2: Enabling the Expedia phone number on the Twillio service
----------------------------------------------------------------
1. Generate the Twillio SID using the primary support number
2. Go to https://www.twilio.com/console/dev-tools/twiml-bins
3. Select the '+ 'graphic to create a new country
4. For Friendly Name field, enter the country name making sure it matches exactly what you entered in Part 1
5. Copy and paste the following code into the Configuration-> TWIML box and enter the phone number you entered in step 2
6. <?xml version="1.0" encoding="UTF-8"?><Response><Dial><Number>[Enter Phone Number]</Number></Dial></Response>
7. This will generate a Twillio SID as per highlighted below

Part 3: Enabling Contact Us page for Twilio callback
----------------------------------------------------
1. Go to Setup / Build / Develop / Custom Settings 
2. Select Structured Intake Callback Countries 
3. Select Manage
4. Select New to add the new country
5. Enter the name of the country you want to enable
6. Enter the Twilio SID from above into the Twilio SID field below and select Save

Part 4: Verify the Call Back feature is enabled
-----------------------------------------------
1. Visit the Contact Us page https://expediagso.secure.force.com/kb/?cu=1&fs=ContactUs&l=en_US 
2. Select the country from the drop down menu

You should now see the below option which the hotelier will enter their phone number and a call back will happen from the Twilio service, which will connect them with a free phone call