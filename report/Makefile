DATE=JJMMAA


# Cahier des Charges
cdc: cdc_ posttreat
cdc_:
	- pdflatex cahierDesCharges.tex


# Compte-Rendus
CR: CR_ posttreat
CR_:
	- pdflatex CR_seance_$(DATE).tex


# PDF moving
posttreat: clear
	- mv *.pdf pdf/

# cleaning
clear:
	rm *.aux *.log

