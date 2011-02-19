TARGET = $(HOME)/scripts

.PHONY : install
install :
	mkdir -p $(TARGET) # Edit ~/.bash_profile to add this into your PATH
	cp * $(TARGET)
