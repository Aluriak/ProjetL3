# -*- encoding: utf-8 -*-
# WARNING:
# Debugging program.
# - reinitialisation of all contents;
# - add some basic contents;
#
load "src/commun/commun.rb"
load "src/configuration/configuration.rb"
load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"
load "src/grille/jouable.rb"
load "src/grille/racine.rb"


# LOAD
gds = GestionnaireDeSauvegarde.new
cnf = Configuration.new(0,5)


# FILLING
cnf.derniereTailleGrille=5
cnf.prochainIdGrille=1

# create grille racine and add it to gds
gds.ajouterGrilleRacine(GrilleRacine.deTaille(5, cnf.idGrilleSuivant))



# SAVE
File.open(CONSTANT_FICHIER_DATA_CONFIG, "w") do |f|
  f.puts Marshal.dump(cnf)
end
gds.sauvegarderGrillesRacines
