exec = safe-upgrade mysqldumpgrep
dest = $(HOME)/bin

% : %.sh
	cp $< $@
	chmod 744 $@

.PHONY : install
install : $(exec)
	mkdir -p $(dest) # Edit ~/.bash_profile to add this into your PATH
	mv $(exec) $(dest)
