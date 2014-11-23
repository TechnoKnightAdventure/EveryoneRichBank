# deleteusertest.py
# Last edit: 11.22.2014
# Authors: Dan Liu, Micah Rothenbuhler, Sean Gref, Zizhou Zhai

#################################################################
# Test delete an account                                        #
# (This test creates an account and then deletes it immediately)#
#                                                               #
# TEST ACCEPTANCE CRITERIA                                      #
#   - There should be no errors, and the user should be logged  #
#       out.                                                    #
#                                                               #
#################################################################

import sys
import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from createusertest import *

# Click on the account button
print("Clicking on 'Account'...")
driver.find_element_by_xpath("//a[@href='/users/edit']").click()
print("Done!")
pause()

# Click 'Cancel my account'
print("Canceling account...")
driver.find_element_by_xpath("//input[@value='Cancel my account']").click()
pause()
print("Accepting...")
driver.switch_to_alert().accept()
