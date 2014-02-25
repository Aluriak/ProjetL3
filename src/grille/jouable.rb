# -*- encoding: utf-8 -*-
# JOUABLE.RB
# définition de la classe GrilleJouable
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load 'src/commun/commun.rb'
load 'src/grille/grille.rb'



#################################
# JOUABLE			#
#################################
# mainteneur : BOURNEUF

# Une Grille Jouable est une grille affichable dans l'interface graphique et représentant la grille 
# de Picross modifiée par l'utilisateur.
class GrilleJouable < Grille
  @matriceDeJeu

  # matrice carrée d'états de cases du picross
  attr_reader :matriceDeJeu

  def initialize(taille)
    super(taille)
    @matriceDeJeu = Array.new(taille) do |ligne|
      ligne = Array.new(taille) {Etat.Blanc}
    end
  end

  # Bascule l'état de la case située en (i, j) vers l'état donné.
  # Si l'état est nil ou laissé par défaut, l'état de la case passera 'au suivant' 
  # (voir ordonnancement de la classe Etat)
  # Lève des exceptions en cas d'état ou de coordonées non valides
  def basculer(i, j, etat = nil)
    # Assertion
    raise "Etat non valide" if not (Etat.include?(etat) and etat != nil)
    raise "Coordonnée non valide" if not (i.between?(0, @matriceDeJeu.size) and j.between?(0, @matriceDeJeu.size))
    # Bascule
    if etat == nil then
      @matriceDeJeu[i][j] = Etat.suivant(@matriceDeJeu[i][j])
    else
      @matriceDeJeu[i][j] = etat
    end
  end

end




#################################
# FUNCTIONS			#
#################################




