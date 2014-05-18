run:
	ruby src/main.rb

doc: 
	# supprime la doc
	rm -rf doc/
	
	#génère la doc pour tout les repertoires de src et omet les samples
	rdoc src/ -x src/samples/ -o doc 
