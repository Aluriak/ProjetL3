# -*- encoding: utf-8 -*-

			
require "gtk2"
require "glib2"
include Gtk

load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"

class FenetreCharger < Window


	def initialize(picross)
		super("Charger une partie")
		add(vb = VBox.new)
		set_default_size(250, 60)
		set_window_position(:center)
		
		cbParties = ComboBox.new
		cbParties.signal_connect("changed") { |w, e|
			on_changed(w, e, label)
		}
		
			
		#picross.gestionnaireDeSauvegarde.each { |nom| @combo_profils.append_text(nom) }
		buttonValider = Button.new("Valider")
		labelTaille = Label.new("Taille de la grille : ")
		cbTailles = ComboBox.new
		cbTailles.set_active(0)

	
		vb.pack_start(hboxTaille = HBox.new(2))
		hboxTaille.pack_start(labelTaille)
		hboxTaille.pack_start(cbTailles)
		vb.pack_start(cbParties)
		vb.pack_start(buttonValider)

		if(cbTailles.active == 0)
			tailleFiltre = 5
		elsif(cbTailles.active == 1)
			tailleFiltre = 10
		elsif(cbTailles.active == 2)
			tailleFiltre = 15
		elsif(cbTailles.active == 3)
			tailleFiltre = 20    		
		end
		
		cbTailles.append_text("5")
		cbTailles.append_text("10")
		cbTailles.append_text("15")
		cbTailles.append_text("20")
		
		cbTailles.signal_connect("changed") {
			#Grilles.taille.each { |tailleFiltre| lst_grilles.push(gds.grilleJouablesDeTaille(tailleFiltre)) }
		}
			
		buttonValider.signal_connect("clicked"){
			#picross.gestionnaireDeSauvegarde.chargerGrillesJouables
		}
		
		show_all
	end

end
