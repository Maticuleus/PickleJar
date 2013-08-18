#encoding: utf-8
Feature: Browse something
 
Scenario: Browsing
Given that I have gone to "www.google.com"
And wait for 3 seconds
And click on the "link" named "Images"
And wait for 3 seconds
And set "You can set text" on the "textfield" indexed at "0"
And wait for 3 seconds
And set "You can also enter text, let's try entering: cats" on the "textfield" indexed at "0"
And wait for 3 seconds
And enter "cats" on the "textfield" indexed at "0"
And wait for 5 seconds
And close the browser