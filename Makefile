all :   
	se clean pf_hp.e
	se compile pf.ace 

clean :
	echo "Removing all executables ..." 
	rm -f pf_hp
	se clean pf_hp.e

