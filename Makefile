run: default
	ruby1.9.1 src/main.rb

doc: doc_
doc_: 
	# delete already existing documentation
	rm -rf doc/
	#genere la doc pour tout les repertoires de src sauf de samples
	rdoc src/ -x src/samples/ -o doc 

default:
	#ruby1.9.1 src/addDefaultContent.rb
