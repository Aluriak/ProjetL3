# -*- encoding: utf-8 -*-

require "gtk2"
require "glib2"
include Gtk

load "src/picross/picross.rb"

class GrilleEditable

	@tailleNouvelleMatrice
	@picross

	def initialize(picross, tableEtat)
		
		@picross = picross
		popupEdition = Window.new("Edition Grille")
		popupEdition.set_resizable(false)
		vbox = VBox.new(false, 3)
		
		#Grille
		vbox.pack_start(hBoxMilieu = HBox.new(false, 2))
		hBoxMilieu.add(vBoxBas = HBox.new(false))
		vBoxBas.add(table = Table.new(4,4))
		
		vbox.add(textNom = Entry.new)
		textNom.set_text("nom de la grille")
		textNom.set_width_chars(15)
		textNom.set_max_length(25)
		
		vbox.add(hBoxBas = HBox.new(false, 2))
		hBoxBas.pack_start(boutonSauvegarder = Button.new(Stock::OK))
		hBoxBas.pack_start(boutonAnnuler = Button.new(Stock::CANCEL))
		
		# devrait être dans fenetreEditionTaille, et on récupère une grille jouable toute faite(vierge, noir, ou imagée)
		planche = Planche.creer(tableEtat,true)
		
		table.attach(planche.table, 1, 2, 1, 2)
		popupEdition.add(vbox)
		popupEdition.set_window_position(:center)
		popupEdition.show_all
		
		boutonAnnuler.signal_connect("clicked"){ popupEdition.destroy }
		textNom.signal_connect("insert_text") {
			boutonSauvegarder.sensitive = textNom.text.empty? ? false : true
		}
				
		#Quand on appuie sur btnSauvegarder, on crée la matrice de jeu
		boutonSauvegarder.signal_connect("clicked"){ 
			Logs.add("grille jouable dans grilleEditable #{tableEtat}\n")
			@picross.creerGrilleRacine(tableEtat) 
			confirmerEnregistrement(textNom.text)
			popupEdition.destroy
		}
	end
	
	# Confirme à l'utilisateur que la sauvegarde à été effectuée
	def confirmerEnregistrement(nom_sauvegarde)
		dialog = MessageDialog.new(
			nil, 
			Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
			MessageDialog::INFO,
			MessageDialog::BUTTONS_CLOSE,
			"Grille \n\""+nom_sauvegarde+"\"\nenregistree !"
		)

		dialog.run
		dialog.destroy
	end

	
end
