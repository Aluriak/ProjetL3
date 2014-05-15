# -*- encoding: utf-8 -*-

			
require "gtk2"
require "glib2"
include Gtk

load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"

class FenetreCharger < Window


	def initialize(parent_gui, picross)
		super("Charger une partie")
		add(vb = VBox.new)
		set_default_size(350, 60)
		set_window_position(:center)
		

                # WIDGETS
                # Liste des tailels de grille
		labelTaille = Label.new("Taille de la grille : ")
		cbTailles = ComboBox.new
                # ajout des tailles de grilles 
		Grille.tailles.each() { |t| cbTailles.append_text(t.to_s) }
		cbTailles.set_active(0)

                # Liste des parties jouables
		cbParties = ComboBox.new
                picross.grillesJouablesDeTaille(5).each { |grille| cbParties.append_text(grille.nom) }
		
		# Bouton de validation	
		buttonValider = Button.new("Valider")
                buttonValider.sensitive = (cbParties.active_text != nil)
	

                # PACKING
		vb.pack_start(hboxTaille = HBox.new(2))
		hboxTaille.pack_start(labelTaille)
		hboxTaille.pack_start(cbTailles)
		vb.pack_start(cbParties)
		vb.pack_start(buttonValider)

		
	        # CONNECTS	
		cbTailles.signal_connect("changed") {
                  sauvegardes = picross.grillesJouablesDeTaille(cbTailles.active_text.to_i) # nouvelles entrées
                  # on rajoute les nouvelles
                  sauvegardes.each { |grl| cbParties.append_text(grl.nom_de_sauvegarde) } 
                  # si il n'y a pas de parties dispos, validation impossible
                  buttonValider.sensitive = (cbParties.active_text != nil)
		}

		cbParties.signal_connect("changed") {
                  # si il n'y a pas de partie sélectionnée, validation impossible
                  buttonValider.sensitive = (cbParties.active_text != nil)
		}
			
		buttonValider.signal_connect("clicked"){
                  taille, nom = cbTailles.active_text.to_i, cbParties.active_text
                  parent_gui.destroy    # destruction de la gui existante
                  self.destroy          # destruction de la fenetre de chargement
                  # et création d'une nouvelle
                  gui = Gui.new(taille, nom)
		}
		
                # SHOW
		self.show_all
	end

end
