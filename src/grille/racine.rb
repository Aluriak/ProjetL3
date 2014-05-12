# -*- encoding: utf-8 -*-
# RACINE.RB
# définition de la classe GrilleRacine
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
require "date"
load 'src/grille/tableNombre.rb'
load "src/commun/commun.rb"



#################################
# RACINE			#
#################################
# mainteneur : BOURNEUF

# une GrilleRacine possède un nom et des tables de ligne/colonne.
class GrilleRacine 
  @tableLigne
  @tableColonne
  @nom

  # les entiers définissant les lignes
  attr_accessor :tableLigne
  # les entiers définissant les colonnes
  attr_accessor :tableColonne
  # nom identifiant la grille
  attr_reader :nom


  def initialize(taille, nom = nil, tableLigne = nil, tableColonne = nil)
    # si les tables de colonne et de lignes ne sont pas renseignées
    if tableLigne == nil or tableColonne == nil then
      # Génération d'un picross aléatoire
      # création d'une table d'état avec remplissage aléatoire
      tableEtat = Array.new(taille) {Array.new(taille) { [Etat.Blanc, Etat.Noir].choice} }
      # obtention des tables 
      @tableLigne, @tableColonne = TableNombre.creerDepuis(tableEtat)
    else
      # utilisation des tables reçues
      @tableLigne, @tableColonne = tableLigne, tableColonne
    end


    # Nom
    if nom == nil then
      # Génération du nom basé sur la date et la taille demandée.
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
  			    tableLigne = nil, tableColonne = nil)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    return new(taille, nom, tableLigne, tableColonne)
  end




  # Retourne la taille de la grille
  def taille
    return @tableLigne.taille
  end



  # Marshal API : méthode de dump
  def marshal_dump
    [@tableLigne, @tableColonne, @nom]
  end
  
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @tableLigne, @tableColonne, @nom = ary
  end


end





