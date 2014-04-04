run:
	ruby1.9.1 src/main.rb


doc:
	rdoc -i src/ --[-no]dcov samples/  -o doc //genere la doc pour tout les repertoires de src sauf de samples


