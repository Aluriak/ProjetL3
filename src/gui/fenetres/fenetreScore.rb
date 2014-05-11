# -*- encoding: utf-8 -*-
# FENETRESCORE.RB
# Définition de la fenêtre de scores affichant les scores pour une grille particulière.
# BOURNEUF
#

			
#################################
# IMPORTS			#
#################################
require "gtk2"
require "glib2"



#################################
# FENETRE SCORE			#
#################################
# mainteneur : BOURNEUF
class FenetreScore < Gtk::Window

	def initialize(parent, scores_globaux, nom_grille)

		super("Scores")
		self.signal_connect("destroy") { self.destroy }
		set_resizable(true)

                vbox = Gtk::VBox.new(10)
                vbox.pack_start(Gtk::Label.new("Meilleurs scores pour la grille "+nom_grille), true, true)

                # Obtention de tous les scores
                # Et ajouts dans la vbox
                grille_scores = scores_globaux.scoresDeGrille(nom_grille)
                grille_scores.each do |score|
                  profil_nom, profil_score = score
                  hbox = Gtk::HBox.new
                  hbox.pack_start(Gtk::Label.new(profil_nom))
                  hbox.pack_start(Gtk::Label.new(profil_score.to_s))
                  vbox.pack_start(hbox, true, true)
                end



                self.add(vbox)

                
                self.set_modal(true)            # this window block interactions with 
                self.set_transient_for(parent)  # parent window.
                self.show_all

	end

end




