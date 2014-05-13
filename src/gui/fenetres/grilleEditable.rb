# -*- encoding: utf-8 -*-

require "gtk2"
require "glib2"
include Gtk

load "src/picross/picross.rb"

class GrilleEditable

	@tailleNouvelleMatrice
	@picross

	def initialize(taille, picross)
		
		@picross = picross
		popupEdition = Window.new("Edition Grille")
		popupEdition.set_resizable(false)
		vbox = VBox.new(false, 2)
		
		#Grille
		vbox.pack_start(hBoxMilieu = HBox.new(false, 2))
		hBoxMilieu.add(vBoxBas = HBox.new(false))
		vBoxBas.add(table = Table.new(4,4))
		
		vbox.add(hBoxBas = HBox.new(false, 2))
		hBoxBas.pack_start(boutonSauvegarder = Button.new(Stock::OK))
		hBoxBas.pack_start(boutonAnnuler = Button.new(Stock::CANCEL))
		
		# devrait être dans fenetreEditionTaille, et on récupère une grille jouable toute faite(vierge, noir, ou imagée)
		jouable = GrilleJouable.deTaille(taille)
		planche = Planche.creer(jouable,true)
		
		table.attach(planche.table, 1, 2, 1, 2)
		popupEdition.add(vbox)
		popupEdition.show_all
		
		boutonAnnuler.signal_connect("clicked"){ popupEdition.destroy }
				
		#Quand on appuie sur btnSauvegarder, on crée la matrice de jeu
		boutonSauvegarder.signal_connect("clicked"){ 
			print "grille jouable dans grilleEditable #{jouable.matriceDeJeu}\n" if CONSTANT_MODE_DEBUG
			picross.creerGrilleRacine(jouable.matriceDeJeu) 

			#Lance une fenetre qui demande un nom pour la grille editable a creer
			popupNomGrilleEditee
			popupEdition.destroy
		}
	end

##
# Function to open a dialog box displaying the message provided.
def popupNomGrilleEditee
  popupNomGrilleEditee = Window.new("Nom de la grille?")

  popupNomGrilleEditee.add(hb = HBox.new)
  buttonValider = Button.new("Valider")
  buttonValider.sensitive = false
  textNom = Entry.new

  hb.pack_start(textNom)
  hb.pack_start(buttonValider)

  # bloque le bouton, s'il n'y a rien dans la zone de texte
  textNom.signal_connect("insert_text") {
	  buttonValider.sensitive = textNom.text.empty? ? false : true
  }


  buttonValider.signal_connect("clicked"){
  	#Si la sauvegarder de la grille éditée est un succes on le dit à l'utilisateur
  	#PROBLEME rien apres le if!!
	  #if 
  		confirmerEnregistrement(textNom.text)
  	#else
  		#erreurEnregistrement
  	#end
  }
  buttonValider.signal_connect("clicked"){popupNomGrilleEditee.destroy}


  popupNomGrilleEditee.show_all
 

end
	
	##
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

def erreurEnregistrement
	 dialog = MessageDialog.new(
      nil, 
      Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
      MessageDialog::ERROR,
      MessageDialog::BUTTONS_CLOSE,
      "Enregistrement de la grille impossible!"
    )

end
	
end