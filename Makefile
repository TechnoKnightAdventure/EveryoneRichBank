# Configuration
NAME   = $(shell git config user.name)
USER   = dev
SERVER = tka.nonlogicaldev.com

# Why Makefiles?
#
# Well the answer to that is make is present on pretty much every
# posix system and they integrate brilliantly with shell, unlike rake.
#
# I will be setting up Capistrano later, but for now we need our developers
# to have a very quick feedback loop. So I created this makefile to serve exactly
# that purpose.
#
# Usage:
#
#	make sync -- to push your working directory to the server
#	make rrun p=[port] -- to run WebBrick on the server on the given port
# make rshell -- to shell in automatically assuming you have added the identity
#                to the ssh-agent

# Automagical variables
DIR    = tka-$(NAME)
SSH_DEST=$(USER)@$(SERVER)
DESTINATION=$(SSH_DEST):~/$(DIR)

.PHONY: ls sync rshell test
ls:
	@ssh -t $(SSH_DEST) mkdir -p $(DIR)
	@echo "Its working!"

sync: ls
	rsync -avz --force --delete --exclude="*.pem" --exclude="Makefile" -e ssh . $(DESTINATION)

rrun: ls
	$(call ssh,rails s -p$(p))

rshell: ls
	$(call sshi)

## Helper Functions

define ssh
  ssh -t $(SSH_DEST) 'cd ~/$(DIR); exec $$SHELL -l -c "$1"'
endef

define sshi 
  ssh -t $(SSH_DEST) 'cd ~/$(DIR); exec $$SHELL -l'
endef
