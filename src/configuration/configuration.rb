# -*- encoding: utf-8 -*-
# CONFIGURATION.RB
# définition de la classe Configuration
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "src/commun/commun.rb"
 

#################################
# CONFIGURATION CLASS		#
#################################
# mainteneur : BOURNEUF
# Groupement de valeurs nécessaires à l'autoconfiguration du prgm de Picross.
# Classe instanciée une seule fois, chargée au démarrage et sauvegardée 
#  lors des modifications des attributs.
class Configuration
  @prochainIdGrille
  @derniereTailleGrille

  # prochain id de grille racine à affecter
  attr_accessor :prochainIdGrille
  # taille de la dernière grille jouée
  attr_reader :derniereTailleGrille


  # ==Constructeur
  def initialize(id, taille)
    @prochainIdGrille, @derniereTailleGrille = id, taille
  end

  # Retourne le prochain id de grille valable
  def idGrilleSuivant 
    @prochainIdGrille += 1
    return @prochainIdGrille - 1
  end
  
  # Affecte la nouvelle taille de grille
  # Lève une exception si la taille reçue est invalide
  def derniereTailleGrille=(taille)
    raise "Taille non définie" if not Grille.tailles.include? taille
    @derniereTailleGrille = taille
    return self
  end

  # Marshal API : méthode de dump
  def marshal_dump
    [prochainIdGrille, derniereTailleGrille]
  end
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @prochainIdGrille, @derniereTailleGrille = ary
  end

end






