			
require "gtk2"
require "glib2"
include Gtk

load "src/gui/fenetres/grilleEditable.rb"

class FenetreEditionTaille

	@tailleNouvelleMatrice
	
	def initialize(picross)

		fenetreEditer = Window.new("Editer");
		fenetreEditer.set_resizable(false)

		vBoxPrincipal = VBox.new(false, 2)
		vBoxPrincipal.pack_start(hBoxHaut = HBox.new(false, 2))
		hBoxHaut.pack_start(vBoxTaille = VBox.new(false, 2))

		vBoxTaille.pack_start(Label.new("Taille"))	
		vBoxTaille.pack_start(b5 	= RadioButton.new("5 x 5"))
		vBoxTaille.pack_start(b10 	= RadioButton.new(b5, "10 x 10"))
		vBoxTaille.pack_start(b15	= RadioButton.new(b10, "15 x 15"))
		vBoxTaille.pack_start(b20 	= RadioButton.new(b15, "20 x 20"))
		vBoxTaille.pack_start(b25 	= RadioButton.new(b20, "25 x 25"))
		
		hBoxHaut.pack_start(vBoxType = VBox.new(false, 2))
		vBoxType.pack_start( Label.new("Type"))
		vBoxType.pack_start(b4 = RadioButton.new("Vierge"))

		vBoxType.pack_start(hBoxChargerImage = HBox.new(false, 2))
		hBoxChargerImage.pack_start(b5 = RadioButton.new(b4, ""))

		#Ecouteur boutton charger Image
		hBoxChargerImage.pack_start(btnChargerImage = Button.new("Charger Image"))
		

		btnChargerImage.signal_connect("clicked"){
			dialog = FileChooserDialog.new("Charger Image",
				nil,
				FileChooser::ACTION_OPEN,
				nil,
				[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
				[Stock::OPEN, Dialog::RESPONSE_ACCEPT]
			)
			if dialog.run == Dialog::RESPONSE_ACCEPT
				puts "filename = #{dialog.filename}"
			end
		
			dialog.destroy
		}

		vBoxPrincipal.pack_start(hBoxBas = HBox.new(false, 2))
		#Ajout de la 2eme horizontal box contenant boutons
		hBoxBas.pack_start(ok = Button.new(Stock::OK), true, true)
		hBoxBas.pack_start(boutonAnnuler = Button.new(Stock::CLOSE), true, true)
		
			
		ok.signal_connect("clicked"){
			
			if (b5.active?)
				@tailleNouvelleMatrice = 5
			elsif (b10.active?)
				@tailleNouvelleMatrice = 10
			elsif (b15.active?)
				@tailleNouvelleMatrice = 15
			elsif (b20.active?)
				@tailleNouvelleMatrice = 20
			elsif (b25.active?)
				@tailleNouvelleMatrice = 25
			end

			fenetreEditer.destroy

			grilleEditable = GrilleEditable.new(@tailleNouvelleMatrice, picross)
		}
		boutonAnnuler.signal_connect("clicked"){ fenetreEditer.destroy }

		fenetreEditer.add(vBoxPrincipal)
		fenetreEditer.show_all
	end
end
