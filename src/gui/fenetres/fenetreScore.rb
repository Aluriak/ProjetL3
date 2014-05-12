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

  def initialize(parent, scores_globaux, nom_grille)
	super("Scores")
    signal_connect("destroy") { destroy }

    # Obtention de tous les scores
    grille_scores = scores_globaux.scoresDeGrille(nom_grille)
	table = Table.new(grille_scores.size,2)
	
	table.attach(Label.new.set_markup("<b>#{nom_grille}</b>"), 0, 2, 0, 1)
	
	# nb : la ligne 0 est dédiée au nom de la grille, 
	# c'est pour cela qu'on commence à la ligne 1
	ligne=1
	
    grille_scores.each{ |score|
		profil_nom, profil_score = score
		
		table.attach(Frame.new.add(Label.new(profil_nom)), 0, 1, ligne, ligne+1)
		table.attach(Frame.new.add(Label.new(profil_score.to_s)), 1, 2, ligne, ligne+1)

		ligne += 1
	}               
    
	add(Frame.new.add(table))
    set_modal(true)            # this window block interactions with 
    set_transient_for(parent)  # parent window.
	set_resizable(true)
	set_default_size(300,40+grille_scores.size*30)
	show_all
  end

end




