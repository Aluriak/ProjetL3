# -*- encoding: utf-8 -*-
# FENETRESCORE.RB
# Définition de la fenêtre de scores affichant les scores pour une grille particulière.
# BOURNEUF/COUSIN
#

			
#################################
# IMPORTS			#
#################################
require "gtk2"
require "glib2"

include Gtk



#################################
# FENETRE SCORE			#
#################################
# mainteneur : BOURNEUF
class FenetreScore < Window

  def initialize(parent, scores_grille, nom_grille)
    super("Scores")
    signal_connect("destroy") { destroy }
    scores_grille = [["Pas de meilleur score", "Jouez pour être le premier !"]] if scores_grille == nil

    # Obtention de tous les scores
    table = Table.new(scores_grille.size,2)
    
    table.attach(Label.new.set_markup("<b>#{nom_grille}</b>"), 0, 2, 0, 1)
    
    # nb : la ligne 0 est dédiée au nom de la grille, 
    # c'est pour cela qu'on commence à la ligne 1
    ligne=1
	
    # remplissage de la grille de scores
    scores_grille.each { |score|
      profil_nom, profil_score = score
      
      table.attach(Frame.new.add(Label.new(profil_nom)), 0, 1, ligne, ligne+1)
      table.attach(Frame.new.add(Label.new(profil_score.to_s)), 1, 2, ligne, ligne+1)

      ligne += 1
    }               
    
    add(Frame.new.add(table))
    set_modal(true)            # this window block interactions with 
    set_transient_for(parent)  # parent window.
    set_resizable(false)
    set_default_size(300,40+scores_grille.size*30)
    set_window_position :center
    show_all
  end

end




