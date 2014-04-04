#FAIT : jouable --> planche
#revoir : reprendre main de nico
#A FAIRE : @colonneChiffre, @ligneChiffre --> tablechiffre

require "gtk2"
require "glib2"
include Gtk

load "src/gui/planche.rb"
load "src/gui/menu.rb"
load "src/gui/tablechiffre.rb"
load "src/gui/chronometre.rb"
load "src/grille/jouable.rb"
load "src/configuration/configuration.rb"
load "src/picross/picross.rb"
load "src/gui/fenetres/fenetreNouveauTaille.rb"
load "src/gui/fenetres/fenetreEditionTaille.rb"
load "src/gui/fenetres/grilleEditable.rb"
load "src/gui/fenetres/fenetreCharger.rb"
load "src/gui/fenetres/fenetreSauvegarde.rb"
load "src/gui/fenetres/fenetreScore.rb"
load "src/gui/fenetres/fenetreManuel.rb"
load "src/gui/fenetres/fenetreAPropos.rb"

class Gui

	@tailleGrille	
	
	def Gui.lancer(titre)
		new(titre)
	end
	
	def initialize(titre)
		Gtk.init

		p = Picross.new
		@tailleGrille = p.config.derniereTailleGrille
		
		window = Window.new(titre)
		window.signal_connect("destroy") { Gtk.main_quit }
		window.set_resizable(false)
		vbox = VBox.new(false, 2)
		jouable = GrilleJouable.deTaille(@tailleGrille)
	
		#Partie haute de l"application
		vbox.pack_start(hBoxHaut = HBox.new(false, 2))
		menuHaut = Menu.creer(hBoxHaut,"Nouveau", "Editer", "Charger", "Sauvegarder", "Score" ,"Manuel", "A propos")

		#Partie basse de l"application
		vbox.pack_start(hBoxBas = HBox.new(false, 2))
		hBoxBas.add(vBoxBas = HBox.new(false))
		f = Frame
		
		vBoxBas.add(Frame.new.add(table = Table.new(4,4)))

		#Chronometre
		timer = Chronometre.initialiser("temps")
		table.attach(timer.text, 0, 1, 0, 1)

		chiffreHaut = TableChiffre.creer(@tailleGrille)
		table.attach(chiffreHaut.table, 1, 2, 0, 1)

		chiffreBas = TableChiffre.creer(@tailleGrille)
		table.attach(chiffreBas.table, 0, 1, 1, 2)

		planche = Planche.creer(jouable)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(Frame.new.add(vBoxBasGauche = VBox.new(false,3)))
		menuDroit = Menu.creer(vBoxBasGauche,"Aide - Faible", "Aide - Fort")
		
		#Ecouteur signal pour le bouton "Nouveau"
		menuHaut.clickerSur("Nouveau"){ nouveau = FenetreNouveauTaille.new }

		#Ecouteur signal pour le bouton "Editer"
		menuHaut.clickerSur("Editer"){ editer = FenetreEditionTaille.new }

		#Ecouteur signal pour le bouton "Charger"
		menuHaut.clickerSur("Charger"){ fenetreCharger = FenetreCharger.new }

		#Ecouteur signal pour le bouton "Sauvegarder"
		menuHaut.clickerSur("Sauvegarder"){ fenetreSauvegarder = FenetreSauvegarder.new }

		#Ecouteur signal pour le bouton "Score"
		menuHaut.clickerSur("Score"){ fenetreScore = FenetreScore.new }

		#evenement clique le bouton "Manuel"
		menuHaut.clickerSur("Manuel"){ fenetreManuel = FenetreManuel.new }

		#evenement clique le bouton "A Propos"
		menuHaut.clickerSur("A propos"){ fenetreAPropos = FenetreAPropos.new }
			
		window.add(vbox)
		window.show_all
		
		Gtk.main
	end
end
 




 
