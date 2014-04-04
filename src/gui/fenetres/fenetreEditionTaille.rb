			
require "gtk2"
require "glib2"
include Gtk

class FenetreEditionTaille

	@tailleNouvelleMatrice


	def initialize()

		fenetreEditer = Window.new("Editer");
		fenetreEditer.set_resizable(false)

		vBoxPrincipal = VBox.new(false, 2)
		vBoxPrincipal.pack_start(hBoxHaut = HBox.new(false, 2))
		hBoxHaut.pack_start(vBoxTaille = VBox.new(false, 2))

		vBoxTaille.pack_start( Label.new("Taille"))	
		vBoxTaille.pack_start(b = RadioButton.new("5 x 5"))
		vBoxTaille.pack_start(b2 = RadioButton.new(b, "10 x 10"))
		vBoxTaille.pack_start(b3 = RadioButton.new(b, "15 x 15"))
		vBoxTaille.pack_start(b4 = RadioButton.new(b, "20 x 20"))
		vBoxTaille.pack_start(b5 = RadioButton.new(b, "25 x 25"))
		

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
											[Stock::OPEN, Dialog::RESPONSE_ACCEPT])


			if dialog.run == Dialog::RESPONSE_ACCEPT
				puts "filename = #{dialog.filename}"
			end
			dialog.destroy

	}


	vBoxPrincipal.pack_start(hBoxBas = HBox.new(false, 2))
			#Ajout de la 2eme horizontal box contenant boutons
			hBoxBas.pack_start(ok = Button.new(Stock::OK), true, true)
			hBoxBas.pack_start(cancel = Button.new(Stock::CLOSE), true, true)

			fenetreEditer.add(vBoxPrincipal)
			fenetreEditer.show_all
		
			
			ok.signal_connect("clicked"){
				fenetreEditer.destroy

				popupEdition = Window.new("Edition Grille")
				popupEdition.set_resizable(false)
				vbox = VBox.new(false, 2)
				#Creation d'une nouvelle grille de la taille défini
				jouable = GrilleJouable.deTaille(@tailleGrille)
				#Grille
				vbox.pack_start(hBoxMilieu = HBox.new(false, 2))
				hBoxMilieu.add(vBoxBas = HBox.new(false))
				vBoxBas.add(table = Table.new(4,4))


				vbox.add(hBoxBas = HBox.new(false, 2))
				hBoxBas.pack_start(Button.new(Stock::OK))
				hBoxBas.pack_start(Button.new(Stock::CANCEL))

	
				planche = Planche.creer(jouable)
				table.attach(planche.table, 1, 2, 1, 2)
				popupEdition.add(vbox)
				popupEdition.show_all

			
	
			}



	fenetreEditer.add(vBoxPrincipal)
	fenetreEditer.show_all

	end

end
