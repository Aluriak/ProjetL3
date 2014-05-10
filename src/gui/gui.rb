#FAIT : jouable --> planche
#revoir : reprendre main de nico
#A FAIRE : @colonneChiffre, @ligneChiffre --> tablechiffre

require "gtk2"
require "glib2"
include Gtk

load "src/gui/planche.rb"
load "src/gui/menuAide.rb"
load "src/gui/menuPrincipal.rb"
load "src/gui/tablechiffre.rb"
load "src/gui/chronometre.rb"
load "src/picross/picross.rb"
load "src/gui/fenetres/fenetreNouveauTaille.rb"
load "src/gui/fenetres/fenetreEditionTaille.rb"
load "src/gui/fenetres/grilleEditable.rb"
load "src/gui/fenetres/fenetreCharger.rb"
load "src/gui/fenetres/fenetreSauvegarde.rb"
load "src/gui/fenetres/fenetreScore.rb"
load "src/gui/fenetres/fenetreManuel.rb"
load "src/gui/fenetres/fenetreAPropos.rb"

class Array
	def orientationHorizontale?
		# c"est effectivement l"inverse pour une orientation Verticale
		return self.size > self[0].size 
	end
end

class Gui
	
	@window
	@picross
	@derniereTailleGrille
	
	@picross = Picross.new
	@derniereTailleGrille = @picross.derniereTailleDeGrille
	
	# la gui crée un picross à son lancement
	attr_reader :picross
	
	# window est la fenetre affichée
	attr_reader :window
	
	# la taille de la derniere taille de grille
	# pratique pour l'utilisateur; s'il jouait sur une grille
	# de 20*20, le jeu chargera une grille de 20*20
	attr_reader :derniereTailleGrille
	
	def Gui.lancer(tailleChoisie = @derniereTailleGrille)
		new(tailleChoisie)
	end
	
	
	def initialize(tailleGrille)
		@picross = Picross.new
		
		# ligne problématique
		#@picross.nouvelleGrilleDeTaille(tailleGrille)
		@window = Window.new(" - Picross - ")
		@window.signal_connect("destroy") { Gtk.main_quit }
		@window.set_resizable(false)
		vbox = VBox.new(false, 2)
		
		#ça pas bon - utiliser le picross - mais pratique pour 'affichage en attendant
		jouable = GrilleJouable.deTaille(tailleGrille)
		
		#nouvelleGrilleDeTaille
	
		#Partie haute de l"application
		vbox.pack_start(hBoxHaut = HBox.new(false, 2))
		
		menuHaut = MenuPrincipal.creerMenuHaut(hBoxHaut)
		
		menuHaut.clickerSur("Nouveau")	{ nouveau = FenetreNouveauTaille.new }
		menuHaut.clickerSur("Editer")	{ fenetreEditer = FenetreEditionTaille.new(@picross) }
		menuHaut.clickerSur("Charger")	{ fenetreCharger = FenetreCharger.new }
		menuHaut.clickerSur("Sauvegarder"){ fenetreSauvegarder = FenetreSauvegarder.new(@picross) }
		menuHaut.clickerSur("Score")	{ fenetreScore = FenetreScore.new(nil) } #remplacer par une instance de score
		menuHaut.clickerSur("Manuel")	{ fenetreManuel = FenetreManuel.new }
		menuHaut.clickerSur("A Propos")	{ fenetreAPropos = FenetreAPropos.new}
		
		
		#Partie basse de l"application
		vbox.pack_start(hBoxBas = HBox.new(false, 2))
		hBoxBas.add(vBoxBas = HBox.new(false))
		
		vBoxBas.add(Frame.new.add(table = Table.new(4,4)))
		
		boxTimer = VBox.new(false, 2)

		# Gestion du chronomètre
		timer_label = Label.new("")
		timer = Chronometre.new(timer_label)
		# arrêt/départ du chrono suivant le focus de la fenêtre par l'utilisateur
		@window.signal_connect("focus_in_event") { timer.start }
		@window.signal_connect("focus_out_event") { timer.stop }
		
		# intégration à la GUI
		boxTimer.pack_start(timer_label)
		table.attach(boxTimer, 0, 1, 0, 1)
		
		chiffreHaut = TableChiffre.creer(jouable.tableColonne)
		table.attach(chiffreHaut.table, 1, 2, 0, 1)

		chiffreBas = TableChiffre.creer(jouable.tableLigne)
		table.attach(chiffreBas.table, 0, 1, 1, 2)

		#il faudrait :
		#planche = Planche.creer(picross)
		planche = Planche.creer(jouable)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(Frame.new.add(vBoxBasGauche = VBox.new(2)))
		menuDroit = MenuAide.creerMenuDroit(vBoxBasGauche,"Aide - Faible", "Aide - Fort")
		
		#menuDroit.clickerSur("Aide - Faible"){aideFaible(p)}

		#menuDroit.clickerSur("Aide - Fort"){aideFort(p)}		

		@window.add(vbox)
		@window.show_all
		
		Gtk.main
	end
end
 




 
