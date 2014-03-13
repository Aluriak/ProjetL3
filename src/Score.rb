# -*- encoding: utf-8 -*-
# SCORE.RB
# définition de la classe SCORE
# MARECHAL
 
#################################
# IMPORTS #
#################################
load 'src/commun/commun.rb'




#################################
# SCORE                         #
#################################
# mainteneur : MARECHAL

# Une grille de Picross contient deux matrice d'entier,
# définissant le nombre de cases à remplir dans une ligne ou une colonne particulière.
# Il s'agit d'une classe abstraite
class Grille
