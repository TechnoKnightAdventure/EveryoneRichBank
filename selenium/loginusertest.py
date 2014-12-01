# loginusertest.py
# Last edit: 11.22.2014
# Authors: Dan Liu, Micah Rothenbuhler, Sean Gref, Zizhou Zhai

#################################################################
# Test loggin in.                                               #
#                                                               #
# TEST ACCEPTANCE CRITERIA                                      #
#   - If -f is an argument, we are testing to fail              #
#     - "Invalid email or password." should be on the resulting #
#        page.                                                  #
#   - Else if -s is an arugment, we are testing to succeed      #
#     - There should be no errors                               #
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
    print "Correct usage: python scriptname.py (-s/-f) email password"
    print "\t-s : Accept if successfully logged in"
    print "\t-f : Accept if failed to log in (i.e. user not created)\n"
    sys.exit(0)

to_succeed = sys.argv[1] == "-s"
user_email = sys.argv[2]
password = sys.argv[3]

print("Opening browser...")
driver = webdriver.Chrome()
print("Done!")

# Go to website
print("Loading 'localhost:3000'...")
driver.get('localhost:3000');
print("Done!")
pause()

# Click on the register button
print("Clicking on 'Login'...")
driver.find_element_by_xpath("//a[@href='/users/sign_in']").click()
print("Done!")
pause()

# Enter user info
print("Entering user info...")
register_email_box = driver.find_element_by_id("user_email")
register_email_box.send_keys(user_email)
register_pass_box = driver.find_element_by_id("user_password")
register_pass_box.send_keys(password)
print("Done!")
pause();

print("Clicking submit...")
register_submit = driver.find_element_by_xpath("//button[@type='submit']").click()
print("Done!")
pause()

# Check if login succeeded or failed
print("Checking assertions...")
if to_succeed:
    assert "Invalid email or password." not in driver.page_source
else:
    assert "Invalid email or password." in driver.page_source

print("User login successful!")
pause()
