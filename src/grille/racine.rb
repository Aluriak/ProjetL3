# -*- encoding: utf-8 -*-
# RACINE.RB
# définition de la classe GrilleRacine
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
require "date"
load "src/commun/commun.rb"



#################################
# RACINE			#
#################################
# mainteneur : BOURNEUF

# une GrilleRacine possède un nom et des facteurs de ligne/colonne.
class GrilleRacine 
  @matriceDesLignes
  @matriceDesColonnes
  @nom

  # les entiers définissant les lignes
  attr_accessor :matriceDesLignes
  # les entiers définissant les colonnes
  attr_accessor :matriceDesColonnes
  # nom identifiant la grille
  attr_reader :nom


  def initialize(taille, nom, matriceDesLignes, matriceDesColonnes)
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


    # Nom
    if nom == nil then
      @nom =  self.taille.to_s + 'x' + self.taille.to_s 
      @nom += DateTime.now.strftime(format='_%d%b%Y_%H%M%S')
    else
      @nom = nom
    end
  end




  ##
  # Attend la taille de la grille, et optionnellement les matrices 
  # de ligne/colonne et le nom. 
  # Si les matrices de lignes et colonnes sont renseignées, 
  # elles sont utilisées telles quelles.
  # Sinon, elles sont remplacées par des matrices initialisées aléatoirement.
  # Le nom généré aléatoirement se base sur la taille et la date courante.
  def GrilleRacine.deTaille(taille, nom = nil, 
  			    matriceDesLignes = nil, matriceDesColonnes = nil)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    return new(taille, nom, matriceDesLignes, matriceDesColonnes)
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





