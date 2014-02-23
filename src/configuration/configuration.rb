# -*- encoding: utf-8 -*-
# CONFIGURATION.RB
# définition de la classe Configuration
# BOURNEUF
 

#################################
# CONFIGURATION CLASS		#
#################################
# mainteneur : BOURNEUF

# Groupement de valeurs nécessaires à l'autoconfiguration du programme de Picross.
# Classe instanciée une seule fois, chargée au démarrage et sauvegardée lors des modifications des attributs.
class Configuration
  @prochainIdGrille
  @derniereTailleGrille

  # prochain id de grille racine à affecter
  attr :prochainIdGrille
  # taille de la dernière grille jouée
  attr :derniereTailleGrille


  # Marshal API : méthode de dump
  def marshal_dump
    [prochainIdGrille, derniereTailleGrille]
  end
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @prochainIdGrille, @derniereTailleGrille = ary
  end

end






