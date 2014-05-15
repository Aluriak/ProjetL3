DATE=JJMMAA
CR_DIR=CR


# Compte-Rendus
CR: CR_ posttreat
CR_:
	- pdflatex $(CR_DIR)/CR_seance_$(DATE).tex


# Dossier de Conception
ddc: ddc_ posttreat
ddc_:
	- pdflatex dossierDeConception.tex &&  pdflatex dossierDeConception.tex


# Cahier des Charges
cdc: cdc_ posttreat
cdc_:
	- pdflatex cahierDesCharges.tex &&  pdflatex cahierDesCharges.tex


# Soutenance
stn: stn_ posttreat
stn_:
	- pdflatex soutenance.tex && pdflatex soutenance.tex
	- evince pdf/soutenance.pdf


# manuel d'utilisateur
utl: utl_ posttreat
utl_:
	- pdflatex manuel.tex && pdflatex manuel.tex


# manuel d'aide
aid: aid_ posttreat
aid_:
	- pdflatex ManuelAidePicross.tex && pdflatex ManuelAidePicross.tex


# PDF moving
posttreat: clear
	- mv *.pdf pdf/ 

# cleaning
clear:
	rm *.aux *.log 
	- rm *.toc *.nav *.snm *.out

