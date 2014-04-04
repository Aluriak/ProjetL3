require "gtk2"
require "glib2"
include Gtk

load "src/picross/picross.rb"

class GrilleEditable

@tailleNouvelleMatrice

	def initialize()



		popupEdition = Window.new("Edition Grille")
		popupEdition.set_resizable(false)
		vbox = VBox.new(false, 2)
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
				
		p.creerGrilleRacine(jouable.matriceDeJeu)

	


			
	end

end
	
