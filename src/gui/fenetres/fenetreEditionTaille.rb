
require "gtk2"
require "glib2"
include Gtk

load "src/gui/fenetres/grilleEditable.rb"
#load "src/image/image.rb" # cause des problèmes(conflits) entre Gtk::Image et RMagick::Image, à voir comment changer ça

#		
#				FENETRE EDITION TAILLE
#
#	Cette fenetre affiche les différents élements qu'on veut parametrer pour ensuite travailler
#	sur une grille en mode Edition
#
class FenetreEditionTaille

	@tailleNouvelleMatrice
	@chemin	#texte qui est soit "vierge" soit le chemin de l'image (soit "pleine" +tard)
	
	def initialize(picross)

		@chemin = "vierge"
		
		fenetreEditer = Window.new("Editer")
		fenetreEditer.set_resizable(false)

		vBoxPrincipal = VBox.new(false, 3)
		vBoxPrincipal.pack_start(hBoxHaut 	= HBox.new(false, 2))
		vBoxPrincipal.pack_start(hBoxMilieu	= HBox.new(false, 1))
		vBoxPrincipal.pack_start(hBoxBas 	= HBox.new(false, 2))
		
		hBoxHaut.pack_start(Frame.new("Taille").add(vBoxTaille = VBox.new(false, 2)))
		
		hBoxMilieu.pack_start(entryPath = Entry.new)
		entryPath.set_text(@chemin)
		entryPath.set_editable(false)
		
		vBoxTaille.pack_start(rb5 	= RadioButton.new("5 x 5"))
		vBoxTaille.pack_start(rb10 	= RadioButton.new(rb5, "10 x 10"))
		vBoxTaille.pack_start(rb15	= RadioButton.new(rb10, "15 x 15"))
		vBoxTaille.pack_start(rb20 	= RadioButton.new(rb15, "20 x 20"))
		vBoxTaille.pack_start(rb25 	= RadioButton.new(rb20, "25 x 25"))
		
		hBoxHaut.pack_start(Frame.new("Type").add(vBoxType = VBox.new(false, 2)))
		vBoxType.pack_start(rbVierge = RadioButton.new("Vierge"))
		vBoxType.pack_start(rbPleine = RadioButton.new(rbVierge, "Pleine"))
		
		
		vBoxType.pack_start(hBoxChargerImage = HBox.new(false, 2))
		hBoxChargerImage.pack_start(rbCharger = RadioButton.new(rbPleine, ""))
		hBoxChargerImage.pack_start(boutonChargerImage = Button.new("Charger Image"))
		boutonChargerImage.set_sensitive(false)
		
		rbVierge.signal_connect("clicked") { boutonChargerImage.set_sensitive(false); entryPath.set_text("vierge")}		
		rbPleine.signal_connect("clicked") { boutonChargerImage.set_sensitive(false); entryPath.set_text("pleine")}
		rbCharger.signal_connect("clicked"){ boutonChargerImage.set_sensitive(true) ; entryPath.set_text("image?") }
		
		#Ecouteur boutton charger Image
		boutonChargerImage.signal_connect("clicked"){
			dialog = FileChooserDialog.new("Charger Image", nil, FileChooser::ACTION_OPEN, nil,
				[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
				[Stock::OPEN, Dialog::RESPONSE_ACCEPT]
			)

			if dialog.run == Dialog::RESPONSE_ACCEPT
				puts "filename = #{dialog.filename}"
			end
		
			entryPath.set_text(@chemin = dialog.filename)
		
			dialog.destroy
		}
		
		
		#Ajout de la 2eme horizontal box contenant les boutons
		hBoxBas.pack_start(boutonOK = Button.new(Stock::OK), true, true)
		hBoxBas.pack_start(boutonFermer = Button.new(Stock::CLOSE), true, true)
		
		boutonFermer.signal_connect("clicked"){
			fenetreEditer.destroy
			#Gui.lancer
		}
		
		boutonOK.signal_connect("clicked"){
				
			if (rb5.active?)
				@tailleNouvelleMatrice = 5
			elsif (rb10.active?)
				@tailleNouvelleMatrice = 10
			elsif (rb15.active?)
				@tailleNouvelleMatrice = 15
			elsif (rb20.active?)
				@tailleNouvelleMatrice = 20
			elsif (rb25.active?)
				@tailleNouvelleMatrice = 25
			end

			fenetreEditer.destroy

		# coquille logique dans fenetreEditionTaille
		# qui conduit à une coquille dans grilleEditable:
		# Il faudrait créer un nouveau picross, ou tout du moins une grille jouable dans grilleEditable
		# Ou alors, la créer à l'avance dans FenetreEditionTaille(ici) et l'envoyer à grilleEditable
		# Comme ça, en envoie simplement soit un table vierge(etats blancs), soit noires, 
		# soit une table représentant une image importée.
		if @chemin == "vierge"
				# rien
			elsif @chemin == "pleine"
				#picross.grille.toutNoircir
			else
				picross.grille
			end
			
			grilleEditable = GrilleEditable.new(@tailleNouvelleMatrice, picross)
		}
		boutonFermer.signal_connect("clicked"){ fenetreEditer.destroy }

		fenetreEditer.add(vBoxPrincipal)
		fenetreEditer.show_all
	end
end
