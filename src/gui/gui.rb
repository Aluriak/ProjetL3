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
	
	@derniereTailleGrille
        @picross = Picross.new
        @derniereTailleGrille = @picross.derniereTailleDeGrille

=begin
	def Gui.lancerTailleDerniereGrille(titre)
		puts "Derniere taille de la grille ",@derniereTailleGrille
		new(titre, @derniereTailleGrille)
	end

	#A faire :  Différencier les deux constructeurs
	#Soit on lance le constructeur avec la valeur de la derniere grille
	#Soit on lance le constructeur avec la valeur définie par le joueur
	
	def Gui.lancerTailleChoisie(titre, tailleChoisie)
		puts "Taille choisie : #{tailleChoisie}"
		new(titre, tailleChoisie)
	end
=end
	
	def Gui.lancer(tailleChoisie = @derniereTailleGrille)
		new(tailleChoisie)
	end
	
	
	def initialize(tailleGrille)
		@window = Window.new(" - Picross - ")
		@window.signal_connect("destroy") { Gtk.main_quit }
		@window.set_resizable(false)
		vbox = VBox.new(false, 2)
		
		
		jouable = GrilleJouable.deTaille(tailleGrille)
		
	
		#Partie haute de l"application
		vbox.pack_start(hBoxHaut = HBox.new(false, 2))
		
		menuHaut = MenuPrincipal.creerMenuHaut(hBoxHaut)
		
		#Partie basse de l"application
		vbox.pack_start(hBoxBas = HBox.new(false, 2))
		hBoxBas.add(vBoxBas = HBox.new(false))
		
		vBoxBas.add(Frame.new.add(table = Table.new(4,4)))
		
		boxTimer = VBox.new(false, 2)
		

                # Gestion du chronomètre
                timer_label = Label.new("")
		timer = Chronometre.new(timer_label)
                # arrêt/départ du chrono suivant le focus de la fenêtre par l'utilisateur
                @window.signal_connect("focus_in_event") {
                    timer.start()
                }
                @window.signal_connect("focus_out_event") {
                    timer.stop() 
                }
                # intégration à la GUI
		boxTimer.pack_start(timer_label)
		table.attach(boxTimer, 0, 1, 0, 1)



		#pimg = PicrossImage.lire("src/image/lettreD.jpg")
		

		#picross.creerGrilleRacine(pimg.toPicross(tailleGrille))
		
		#jouable.tableColonne = Array.new(5){Array.new(4)}
		
=begin	for i in 0..jouable.tableColonne.length-1
			for j in 0..jouable.tableColonne[0].length-1
			jouable.tableColonne[i][j] = -1
			end
		end
		
		jouable.tableLigne = Array.new(4){Array.new(5)}
		
		for i in 0..jouable.tableLigne.length-1
			for j in 0..jouable.tableLigne[0].length-1
				jouable.tableLigne[i][j] = -1
			end
		end
=end
		
		chiffreHaut = TableChiffre.creer(jouable.tableColonne)
		
			
		table.attach(chiffreHaut.table, 1, 2, 0, 1)

		chiffreBas = TableChiffre.creer(jouable.tableLigne)
		table.attach(chiffreBas.table, 0, 1, 1, 2)

		planche = Planche.creer(jouable)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(Frame.new.add(vBoxBasGauche = VBox.new(2)))
		menuDroit = MenuAide.creerMenuDroit(vBoxBasGauche,"Aide - Faible", "Aide - Fort")
		
		#Ecouteur signal pour le bouton "Nouveau"
		menuHaut.listMenuBtns[0].signal_connect("clicked"){ nouveau = FenetreNouveauTaille.new}

		#Ecouteur signal pour le bouton "Editer"
		menuHaut.listMenuBtns[1].signal_connect("clicked"){
			editer = FenetreEditionTaille.new(@picross) 
			@window.destroy
		}

		#Ecouteur signal pour le bouton "Charger"
		menuHaut.listMenuBtns[2].signal_connect("clicked"){ fenetreCharger = FenetreCharger.new }

		#Ecouteur signal pour le bouton "Sauvegarder"
		menuHaut.listMenuBtns[3].signal_connect("clicked"){ fenetreSauvegarder = FenetreSauvegarder.new(@picross) }

		#Ecouteur signal pour le bouton "Score"
		menuHaut.listMenuBtns[4].signal_connect("clicked"){ fenetreScore = FenetreScore.new(nil) } #remplacer par une instance de score

		#evenement clique le bouton "Manuel"
		menuHaut.listMenuBtns[5].signal_connect("clicked"){ fenetreManuel = FenetreManuel.new }

		#evenement clique le bouton "A Propos"
		menuHaut.listMenuBtns[6].signal_connect("clicked"){ fenetreAPropos = FenetreAPropos.new }
		
		#menuDroit.clickerSur("Aide - Faible"){aideFaible(p)}

		#menuDroit.clickerSur("Aide - Fort"){aideFort(p)}
		


		@window.add(vbox)
		@window.show_all
		
		Gtk.main
	end
end
 




 
