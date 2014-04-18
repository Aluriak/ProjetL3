# -*- encoding: utf-8 -*-
# GRILLE.RB
# définition de la classe Grille
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "src/commun/commun.rb"




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


  ##
  # Attend la taille de la grille.
  # Si les matrices de lignes et colonnes sont renseignées, elles sont utilisées telles quelles
  # Sinon, elles sont remplacées par des matrices initialisées aléatoirement.
  def initialize(taille, matriceDesLignes = nil, matriceDesColonnes = nil)
    # matriceDesLignes[3][4] accède au 5ème chiffre de la 4ème ligne
    if matriceDesLignes == nil then 
      @matriceDesLignes = Array.new(taille) { Array.new }
      @matriceDesLignes.each do |lne|
      	(1+rand((taille/2).to_i)).times do 
      	  lne.push(rand(1)+1)
	end
      end
    else
      @matriceDesLignes = matriceDesLignes
    end

    # matriceDesColonnes[0][10] accède au 11ème chiffre de la 1ère ligne
    if matriceDesColonnes == nil then 
      @matriceDesColonnes = Array.new(taille) { Array.new } 
      @matriceDesColonnes.each do |col|
      	(1+rand((taille/2).to_i)).times do 
      	  col.push(rand(1)+1)
	end
      end
    else
      @matriceDesColonnes = matriceDesColonnes
    end
  end


  ##
  # Créer une Grille de taille voulue
  # Attend une taille de grille valable (== contenu dans Grille.taille)
  # :args: taille de la grille, matrice des facteurs de ligne, matrice des facteurs de colonne.
  def Grille.deTaille(taille, matriceDesLignes = nil, matriceDesColonnes = nil)
    #taille not in @@tailles ? raise "Taille non définie" : nil
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    return new(taille, matriceDesLignes, matriceDesColonnes)
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







