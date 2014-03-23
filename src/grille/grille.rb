# -*- encoding: utf-8 -*-
# GRILLE.RB
# définition de la classe Grille
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "commun/commun.rb"




#################################
# GRILLE			#
#################################
# mainteneur : BOURNEUF

# Une grille de Picross contient deux matrice d'entier, 
# définissant le nombre de cases à remplir dans une ligne ou une colonne particulière.
# Il s'agit d'une classe abstraite
class Grille
  @matriceDesLignes
  @matriceDesColonnes

  # les entiers définissant les lignes
  attr_accessor :matriceDesLignes
  # les entiers définissant les colonnes
  attr_accessor :matriceDesColonnes


  def initialize(taille)
    # Les matrices ne contiennent de prime abord que des nils
    
    # matriceDesLignes[3][4] accède au 5ème chiffre de la 4ème ligne
    @matriceDesLignes = Array.new(taille) do |index| 
      Array.new(taille/2 + 1) { nil }
    end

    # matriceDesColonnes[0][10] accède au 11ème chiffre de la 1ère ligne
    @matriceDesColonnes = Array.new(taille) do |index| 
      Array.new(taille/2 + 1) { nil }
    end
  end

  # Créer une Grille de taille voulue
  # Attend une taille de grille valable (== contenu dans Grille.taille)
  def Grille.deTaille(taille)
    #taille not in @@tailles ? raise "Taille non définie" : nil
    raise "Taille non définie" if not Grille.tailles.include? taille
    return new(taille)
  end

  # Retourne la taille de la grille
  def taille
    return @matriceDesLignes.size
  end

  # Marshal API : méthode de dump
  def marshal_dump
    [matriceDesLignes, matriceDesColonnes]
  end
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @matriceDesLignes, @matriceDesColonnes = ary
  end

  # Obligation de passer par le constructeur deTaille(1) pour créer une Grille
  private_class_method :new
end







