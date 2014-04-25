			
require "gtk2"
require "glib2"
include Gtk

#Il a pas l'air d'aimer le load la, a voir
#load "src/gui/gui.rb"

class FenetreNouveauTaille

	@tailleNouvelleMatrice

	def initialize

		#Creation d'une 2eme fenetre pour choisir la taille de la grille
		popupTailleGrille = Window.new("Nouvelle Grille")
		popupTailleGrille.set_resizable(false)

		vb = VBox.new(false, 6)
		
		vb.pack_start(b5 = RadioButton.new("5 x 5"))
		vb.pack_start(b10 = RadioButton.new(b5, "10 x 10"))
		vb.pack_start(b15 = RadioButton.new(b10, "15 x 15"))
		vb.pack_start(b20 = RadioButton.new(b15, "20 x 20"))
		vb.pack_start(b25 = RadioButton.new(b20, "25 x 25"))
		
		#Ajout de la 2eme horizontal box contenant boutons
		hbBouton = HBox.new(false, 1)
		hbBouton.pack_start(boutonOK = Button.new(Stock::OK), true, true)
		hbBouton.pack_start(boutonAnnuler = Button.new(Stock::CLOSE), true, true)
		boutonAnnuler.signal_connect("clicked") { popupTailleGrille.destroy }
		vb.pack_start(hbBouton)

		#Evenement lors du click sur OK
		boutonOK.signal_connect("clicked"){
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
						
			#On crée un nouveau jeu de picross avec pour taille, la taille du radiobutton selectionné
			#Il faudra donc surcharger le constructeur de gui pour pouvoir y ajouter une taille de matrice
			print "Lancement de la nouvelle grille de taille : ", @tailleNouvelleMatrice, "\n"

			Gui.fermer
			popupTailleGrille.destroy
			Gui.lancer(@tailleNouvelleMatrice)
		}

		popupTailleGrille.add(Frame.new.add(vb))
		popupTailleGrille.show_all	
	end
end
