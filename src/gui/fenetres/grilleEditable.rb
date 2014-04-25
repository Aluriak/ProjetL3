require "gtk2"
require "glib2"
include Gtk

load "src/picross/picross.rb"

class GrilleEditable

	@tailleNouvelleMatrice

	def initialize(taille, picross)

		p picross.class

		popupEdition = Window.new("Edition Grille")
		popupEdition.set_resizable(false)
		vbox = VBox.new(false, 2)
		
		#Grille
		vbox.pack_start(hBoxMilieu = HBox.new(false, 2))
		hBoxMilieu.add(vBoxBas = HBox.new(false))
		vBoxBas.add(table = Table.new(4,4))
		
		vbox.add(hBoxBas = HBox.new(false, 2))
		hBoxBas.pack_start(btnSauvegarder = Button.new(Stock::OK))
		hBoxBas.pack_start(Button.new(Stock::CANCEL))
		
		jouable = GrilleJouable.deTaille(taille)
		planche = Planche.creer(jouable,true)
		
		p jouable
		
		table.attach(planche.table, 1, 2, 1, 2)
		popupEdition.add(vbox)
		popupEdition.show_all
				
		#Quand on appuie sur btnSauvegarder, on crée la matrice de jeu
		btnSauvegarder.signal_connect("clicked"){ 
			#p jouable
			print "picross : " , picross.class, "\n"
			picross.creerGrilleRacine(planche.toMatrice) 
		}
	end

end
	
