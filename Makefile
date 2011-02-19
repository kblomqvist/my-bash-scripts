SOURCE = *.sh
DEST = $(HOME)/scripts

.PHONY : install
install :
	mkdir -p $(DEST) # Edit ~/.bash_profile to add this into your PATH
	cp $(SOURCE) $(DEST)
