# createusertest.py
# Last edit: 11.22.2014
# Authors: Dan Liu, Micah Rothenbuhler, Sean Gref, Zizhou Zhai

#################################################################
# Test creation of a user.                                      #
#                                                               #
# TEST ACCEPTANCE CRITERIA                                      #
#   - Passwords match and no error is thrown                    #
#     - OR passwords do not match and an error is thrown        #
#   - Password length is at least 8 characters long             #
#   - A valid email is accepted with no error                   #
#                                                               #
#################################################################

import sys
import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

def pause():
    raw_input('Press [Enter] to continue...')


if len(sys.argv) != 4:
    print "Invalid args:"
    print "Correct usage: python scriptname.py email password password-confirm\n"
    sys.exit(0)

user_email = sys.argv[1]
password = sys.argv[2]
password_confirm = sys.argv[3]

print("Opening browser...")
driver = webdriver.Chrome()
print("Done!")

# Go to website
print("Loading 'locatlhost:3000'")
driver.get('localhost:3000');
print("Done!")
pause()

# Click on the register button
print("Clicking on 'Register'")
driver.find_element_by_xpath("//a[@href='/users/sign_up']").click()
print("Done!")
pause()

# Enter user info
print("Entering user info...")
register_email_box = driver.find_element_by_id("user_email")
register_email_box.send_keys(user_email)
register_pass_box = driver.find_element_by_id("user_password")
register_pass_box.send_keys(password)
register_pass_confirm_box = driver.find_element_by_id("user_password_confirmation")
register_pass_confirm_box.send_keys(password_confirm)
print("Done!")

pause()

print("Clicking submit...")
register_submit = driver.find_element_by_xpath("//button[@type='submit']").click()
print("Done!")

print("Finished testing.")

# Make sure the registration worked as intended
# (i.e. failed if incorrect input)
print("Checking assertions...")

if len(password) < 8 :
    assert "Password is too short" in driver.page_source
if password != password_confirm:
    assert "Password confirmation doesn't match Password" in driver.page_source

print("User creation successful!")
pause()
