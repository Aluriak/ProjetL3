# -*- encoding: utf-8 -*-
# CENTRE DU PROGRAMME GUI.RB
# EWEN COUSIN/NICOLAS BOURDIN


require "gtk2"
require "glib2"
include Gtk

# objets hors gui
load "src/picross/picross.rb"
load "src/aide/aideWrap.rb"

# objets dans la fenetre principale
load "src/gui/planche.rb"
load "src/gui/menuPrincipal.rb"
load "src/gui/chronometre.rb"

# fenetres
load "src/gui/fenetres/fenetrePreference.rb"
load "src/gui/fenetres/fenetreNouveauTaille.rb"
load "src/gui/fenetres/fenetreEditionTaille.rb"
load "src/gui/fenetres/grilleEditable.rb"
load "src/gui/fenetres/fenetreCharger.rb"
load "src/gui/fenetres/fenetreSauvegarde.rb"
load "src/gui/fenetres/fenetreScore.rb"
load "src/gui/fenetres/fenetreManuel.rb"
load "src/gui/fenetres/fenetreAPropos.rb"
load "src/gui/fenetres/fenetreFinJeu.rb"
load "src/gui/fenetres/fenetreSauvegarderAvantQuitter.rb"
load "src/gui/fenetres/fenetreManuelUtilisateur.rb"


class Array
	def orientationHorizontale?
		# c"est effectivement l"inverse pour une orientation Verticale
		return self.size > self[0].size 
	end
end

class Gui < Window
	
	#@window
	@picross
	@derniereTailleGrille
	@nbAppelAide = 0
	
	# la gui crée un picross à son lancement
	attr_reader :picross
	
	# la taille de la derniere taille de grille
	# pratique pour l'utilisateur; s'il jouait sur une grille
	# de 20*20, le jeu chargera une grille de 20*20
	attr_reader :derniereTailleGrille
	
	def Gui.lancer(tailleChoisie = nil, nomGrille = nil)
		new(tailleChoisie, nomGrille)
	end
	
	

	def initialize(tailleGrille, nomGrille)
		@picross = Picross.new
		tailleGrille = @picross.derniereTailleDeGrille if tailleGrille == nil 
		
		# si pas de grille particulière demandée ou si la grille demandée n'existe pas
		if nomGrille == nil or not @picross.chargerGrilleJouableNommee(nomGrille, tailleGrille) then
			@picross.nouvelleGrilleJouableDeTaille(tailleGrille)
		end
		@nbAppelAide = @picross.grille.nbAppelAide
		super("Picross")
		self.signal_connect("destroy") { Gtk.main_quit }

		# GESTION DU CHRONOMÈTRE
		timer_label = Label.new("")
		timer = Chronometre.new(timer_label, @picross.grille.temps_ecoule)
		
		signal_connect("destroy") { Gtk.main_quit }

		signal_connect("delete_event"){
			
			if not @picross.grille.empty?
				#FenetreSauvegarderAvantQuitter.new(@picross, timer)
				FenetreSauvegarderAvantQuitter.show(@picross, timer.sec, self, @nbAppelAide)
			end	
		}


		set_resizable(false)
		vbox = VBox.new(false, 2)
		add_events(Gdk::Event::BUTTON_PRESS_MASK)
		
		grille_jouable = @picross.grille

		# arrêt/départ du chrono suivant le focus de la fenêtre par l'utilisateur
		signal_connect("focus_in_event") { timer.start }
		signal_connect("focus_out_event") { timer.stop }
		# intégration à la GUI
		boxTimer = VBox.new(false, 2)
		boxTimer.pack_start(Frame.new.add(timer_label))

		# PARTIE HAUTE DE L"APPLICATION
		vbox.pack_start(hBoxHaut = HBox.new(false, 2))
		menuHaut = MenuPrincipal.creerMenuHaut(hBoxHaut)
		
		menuHaut.clickerSur("Nouveau")	{ nouveau = FenetreNouveauTaille.new(self) }
		menuHaut.clickerSur("Editer")	{ fenetreEditer = FenetreEditionTaille.new(@picross) }
		menuHaut.clickerSur("Charger")	{ fenetreCharger = FenetreCharger.new(self, @picross)}
		menuHaut.clickerSur("Sauvegarder"){ fenetreSauvegarder = FenetreSauvegarde.new(@picross, timer.sec, @nbAppelAide) }
		menuHaut.clickerSur("Manuel d'aide")	{ fenetreManuel = FenetreManuel.new }
		menuHaut.clickerSur("Manuel utilisateur")	{ fenetreManuelUtilisation = FenetreManuelUtilisateur.new }
		menuHaut.clickerSur("Preference"){ fenetreManuel = FenetrePreference.new(@picross) } 
		menuHaut.clickerSur("A Propos")	{ fenetreAPropos = FenetreAPropos.new}
		menuHaut.clickerSur("Score")	{ 
			fenetreScore = FenetreScore.new(self, @picross.scoresDeGrille(@picross.grille.nom), @picross.grille.nom) 
		}
		
		
		#Partie basse de l"application
		vbox.pack_start(hBoxBas = HBox.new(false, 2))

		labelAide = Label.new()
		bouton_verifier = Button.new("Verifier")
		vbox.pack_start(labelAide)
		vbox.pack_start(bouton_verifier)
		hBoxBas.add(vBoxBas = HBox.new(false))
		vBoxBas.add(Frame.new.add(table = Table.new(4,4)))
		table.attach(boxTimer, 0, 1, 0, 1)


                # VERIFICATION DE FIN DU JEU
		bouton_verifier.signal_connect("clicked") { 
			if @picross.grille.terminee? then
				fenetre_fin_jeu = FenetreFinJeu.new(@picross, timer.sec, @nbAppelAide)
				fenetre_fin_jeu.show_all
				fenetre_fin_jeu.signal_connect("destroy") {
					# on démarre une nouvelle grille !
					# de la même taille que la précédente !
					self.destroy
					Gui.lancer(@picross.grille.taille)
			}
			else 
				dialog = MessageDialog.new(self, 
					Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
					MessageDialog::INFO,
					MessageDialog::BUTTONS_CLOSE,
					"Cette proposition est fausse"
				)
				dialog.show_all
				dialog.run
				dialog.destroy
			end
		}

		# TABLE DE LIGNE
		labelsNombreLigne = Table.new(grille_jouable.tableLigne.largeur, grille_jouable.tableLigne.hauteur)
		# pour chaque ligne
		grille_jouable.tableLigne.hauteur.times { |row|
			nombres = grille_jouable.tableLigne.nombresDeLaLigne(row)
			# pour chaque nombre de la ligne
			nombres.size.times { |col|
				nombre = nombres[col].to_s + " "
				labelsNombreLigne.attach(Label.new(nombre), col, col+1, row, row+1) 
			}
			if nombres.size == 0 then
				# aucun label n'a été affiché. Il faut combler le vide.
				labelsNombreLigne.attach(Label.new(" "), 0, 1, row, row+1) 
			end
		}
		
		table.attach(labelsNombreLigne, 0, 1, 1, 2)
		
		
		# TABLE DE COLONNE
		labelsNombreColonne = Table.new(grille_jouable.tableColonne.largeur, grille_jouable.tableColonne.hauteur)
		# pour chaque colonne
		grille_jouable.tableColonne.largeur.times do |col|
			nombres = grille_jouable.tableColonne.nombresDeLaColonne(col)
			# pour chaque nombre de la colonne
			nombres.size.times do |row|
			nombre = nombres[row].to_s
			labelsNombreColonne.attach(Label.new(nombre), col, col+1, row, row+1) 
			end
				if nombres.size == 0 then
					# aucun label n'a été affiché. Il faut combler le vide.
					labelsNombreColonne.attach(Label.new(" "), col, col+1, 0, 1) 
				end
		end
		
		table.attach(labelsNombreColonne, 1, 2, 0, 1)

		# AFFICHAGE DE LA PLANCHE
		planche = Planche.creer(grille_jouable.matriceDeJeu)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(Frame.new("Aide").add(vBoxBasGauche = VBox.new(2)))
		bouton_aide1_txt = Button.new("Aiguillez-moi !")
		bouton_aide2_txt = Button.new("Que dois-je faire?")

		vBoxBasGauche.pack_start(bouton_aide1_txt)
		vBoxBasGauche.pack_start(bouton_aide2_txt)

		bouton_aide1_txt.signal_connect("clicked"){
			aide = AideWrap.deNiveau1Sur(@picross.grille)
			@nbAppelAide += 1  
			labelAide.set_text(aide) 
		}
			
		bouton_aide2_txt.signal_connect("clicked"){
			aide = AideWrap.deNiveau2Sur(@picross.grille)
			@nbAppelAide += 2  
			labelAide.set_text(aide) 
		}


		# Lorsque le bouton est relâché, le mode drag and assign de la planche de jeu est terminé.
		self.signal_connect("button_release_event") {
			planche.modeDragAndAssign = false
		}
			
		add(vbox)
		set_window_position(:center)
		show_all

		Gtk.main
	end
end
 




 
