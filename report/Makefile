DATE=JJMMAA


# Compte-Rendus
CR: CR_ posttreat
CR_:
	- pdflatex CR_seance_$(DATE).tex


# Cahier des Charges
cdc: cdc_ posttreat
cdc_:
	- pdflatex cahierDesCharges.tex &&  pdflatex cahierDesCharges.tex


# PDF moving
posttreat: clear
	- mv *.pdf pdf/

# cleaning
clear:
	rm *.aux *.log

