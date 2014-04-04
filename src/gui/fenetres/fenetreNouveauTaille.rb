			
require "gtk2"
require "glib2"
include Gtk

#Il a pas l'air d'aimer le load la, a voir
#load "src/gui/gui.rb"

class FenetreNouveauTaille

	@tailleNouvelleMatrice

	def initialize()

			#Creation d'une 2eme fenetre pour choisir la taille de la grille
			popupTailleGrille = Window.new("Nouvelle Grille")
			popupTailleGrille.set_resizable(false)

			vb = VBox.new(false, 6)
			
			vb.pack_start(b = RadioButton.new("5 x 5"))
			vb.pack_start(b2 = RadioButton.new(b, "10 x 10"))
			vb.pack_start(b3 = RadioButton.new(b, "15 x 15"))
			vb.pack_start(b4 = RadioButton.new(b, "20 x 20"))
			vb.pack_start(b5 = RadioButton.new(b, "25 x 25"))
					

			#Ajout de la 2eme horizontal box contenant boutons
			hbBouton = HBox.new(false, 1)
			hbBouton.pack_start(ok = Button.new(Stock::OK), true, true)
			
			#Evenement lors du click sur OK
			ok.signal_connect("clicked"){
				puts b.group
				#On crée un nouveau jeu de picross avec pour taille, la taille du radiobutton selectionné
				#Il faudra donc surcharger le constructeur de gui pour pouvoir y ajouter une taille de matrice
				#Gui.lancer("Picross", @tailleNouvelleMatrice)

			}			
			hbBouton.pack_start(cancel = Button.new(Stock::CLOSE), true, true)
			#Marche pas!!!   cancel.signal_connect("clicked") { Gtk.main_exit }
			vb.pack_start(hbBouton)


			popupTailleGrille.add(vb)
			popupTailleGrille.show_all
			
	end

end
