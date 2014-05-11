# -*- encoding: utf-8 -*-
# WARNING:
# Debugging program.
# - reinitialisation of all contents;
# - add some basic contents;
#
load "src/commun/commun.rb"
load "src/scores/scores.rb"
load "src/configuration/configuration.rb"
load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"
load "src/grille/jouable.rb"
load "src/grille/racine.rb"


# LOAD
gds = GestionnaireDeSauvegarde.new(true)
cnf = Configuration.new(5, Scores.creer())


# FILLING
cnf.derniereTailleGrille=5

# create grille racine and add it to gds
nom_grille = "Mon premier picross"
gds.ajouterGrilleRacine(GrilleRacine.deTaille(5, nom_grille))
cnf.scores.ajouterScoreAGrille(nom_grille, Score.creer(5, 104, 2), "micheline")
cnf.scores.ajouterScoreAGrille(nom_grille, Score.creer(5, 167, 2), "michel")
cnf.scores.ajouterScoreAGrille(nom_grille, Score.creer(5, 642, 1), "roger")



# SAVE
cnf.sauvegarder
gds.sauvegarderGrillesRacines
gds.sauvegarderGrillesJouables # no content

