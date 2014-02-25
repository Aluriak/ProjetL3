# -*- encoding: utf-8 -*-
# RACINE.RB
# définition de la classe GrilleRacine
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load 'src/commun/commun.rb'
load 'src/grille/grille.rb'



#################################
# RACINE			#
#################################
# mainteneur : BOURNEUF

# une GrilleRacine est une grille avec un id.
class GrilleRacine < Grille
  @id

  # identificateur unique de la grille
  attr_reader :id


  def initialize(taille, id)
    super(taille)
    @id = id
  end

  # Création d'une grille racine.
  # Attend la taille et l'id de la grille.
  # La taille doit être un entier de valeur contenue dans Grille.Tailles
  def GrilleRacine.deTaille(taille, id)
    return new(taille, id)
  end

  # Retourne une GrilleRacine créée depuis la Grille envoyée en argument
  # Attend la grille et l'id de la nouvelle grille racine en argument
  def GrilleRacine.creerDepuis(grille, id)
    # création de la grille
    ret = GrilleRacine.deTaille(grille.taille, id)
    # recopie des matrices de lignes et de colonnes
    ret.matriceDesLignes   =   Marshal.load(Marshal.dump(grille.matriceDesLignes))
    ret.matriceDesColonnes = Marshal.load(Marshal.dump(grille.matriceDesColonnes))
    # retour de la grille
    return ret
  end
  


  # Obligation de passer par le constructeur deTaille(2) pour créer une Grille
  private_class_method :new
end





