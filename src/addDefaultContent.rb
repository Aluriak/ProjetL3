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
load "src/grille/tableNombre.rb"


# LOAD
gds = GestionnaireDeSauvegarde.new(true)
cnf = Configuration.new(5, Scores.creer(), [], "default")


# FILLING
cnf.derniereTailleGrille=5

# create grille racine and add it to gds
nom_grille = "Space Invaders"

tableLigne = TableNombre.new(5, TableNombre.DeLigne)
  tableLigne.ajouterNombre(0, 1)
  tableLigne.ajouterNombre(0, 1)
  tableLigne.ajouterNombre(1, 3)
  tableLigne.ajouterNombre(2, 1)
  tableLigne.ajouterNombre(2, 1)
  tableLigne.ajouterNombre(2, 1)
  tableLigne.ajouterNombre(3, 5)
tableColonne = TableNombre.new(5, TableNombre.DeColonne)
  tableColonne.ajouterNombre(0, 1)
  tableColonne.ajouterNombre(0, 2)
  tableColonne.ajouterNombre(1, 1)
  tableColonne.ajouterNombre(1, 1)
  tableColonne.ajouterNombre(2, 3)
  tableColonne.ajouterNombre(3, 1)
  tableColonne.ajouterNombre(3, 1)
  tableColonne.ajouterNombre(4, 1)
  tableColonne.ajouterNombre(4, 2)

gds.ajouterGrilleRacine(GrilleRacine.deTaille(5, nom_grille, tableLigne, tableColonne))
cnf.ajouterScoreALaGrille(nom_grille, Score.creer(5, 104, 2), "micheline")
cnf.ajouterScoreALaGrille(nom_grille, Score.creer(5, 167, 2), "michel")
cnf.ajouterScoreALaGrille(nom_grille, Score.creer(5, 642, 1), "roger")



# SAVE
cnf.sauvegarder
gds.sauvegarderGrillesRacines
gds.sauvegarderGrillesJouables # no content

