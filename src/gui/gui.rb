# -*- encoding: utf-8 -*-
# CENTRE DU PROGRAMME GUI.RB
# EWEN COUSIN/NICOLAS BOURDIN


require "gtk2"
require "glib2"
include Gtk

# objets hors gui
load "src/picross/picross.rb"
#load "src/aide/aideWrap.rb"
load "src/aide/aide.rb"

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

class Gui < Window

	@picross
	@derniereTailleGrille
	@nbAppelAide = 0
	@planche

	attr_accessor :planche
	
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
		set_resizable(false)
		signal_connect("destroy") { Gtk.main_quit }

		#chronomètre(à mettre avant l'évènement 'delete_event')
		timer_label = Label.new
		timer = Chronometre.new(timer_label, @picross.grille.temps_ecoule)
		
		# si la grille est vide, on quitte directement
		signal_connect("delete_event"){
			unless @picross.grille.empty?
				FenetreSauvegarderAvantQuitter.show(@picross, timer.sec, self, @nbAppelAide)
			end	
		}

		
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
		menuHaut.clickerSur("Preference"){ fenetreManuel = FenetrePreference.new(@picross, self) } 
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
		
		
		vboxIndexLigne = VBox.new
		labelsLigne = Array.new(@picross.grille.matriceDeJeu.size+1)
		vert = "#00FF00"
		rouge= "#A52A2A"

		1.upto(@picross.grille.matriceDeJeu.size) {|i|
			labelsLigne[i] = Label.new.set_markup("<i><tt><span foreground='#A52A2A'>"+i.to_s+"</span></tt></i>")
			vboxIndexLigne.pack_start(labelsLigne[i])

			labelsLigne[i].signal_connect("enter_notify_event"){
				labelsLigne[i].set_markup("<i><tt><span foreground='#00FF00'>"+i.to_s+"</span></tt></i>")
			}
			labelsLigne[i].signal_connect("leave_notify_event"){
				labelsLigne[i].set_markup("<i><tt><span foreground='#A52A2A'>"+i.to_s+"</span></tt></i>")
			}
		}
		
		hboxLigne = HBox.new
		hboxLigne.pack_start(labelsNombreLigne, true)
		hboxLigne.pack_start(vboxIndexLigne, true)
		table.attach(hboxLigne,0,1,1,2)
		
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

    hboxIndexColonne = HBox.new #dans laquel on met 1 3 (5 6) 5 (1 2), etc..
    labelsColonne = Array.new(@picross.grille.matriceDeJeu.size+1)

    1.upto(@picross.grille.matriceDeJeu.size) {|i|
      labelsColonne[i] = Label.new.set_markup("<i><tt><span foreground='#A52A2A'>"+i.to_s+"</span></tt></i>")
			hboxIndexColonne.pack_start(labelsColonne[i])

      labelsColonne[i].signal_connect("enter_notify_event"){
				print "on est sur le labelColonne[#{i}\n"
				labelsColonne[i].set_markup("<i><tt><span foreground='#00FF00'>"+i.to_s+"</span></tt></i>")
      }
      labelsColonne[i].signal_connect("leave_notify_event"){
				print "on est sur le labelColonne[#{i}\n"
        labelsColonne[i].set_markup("<i><tt><span foreground='#A52A2A'>"+i.to_s+"</span></tt></i>")
      }
    }
    
    vboxColonne = VBox.new
    vboxColonne.pack_start(labelsNombreColonne, true)
    vboxColonne.pack_start(hboxIndexColonne, true)
    table.attach(vboxColonne, 1, 2, 0, 1)


		# AFFICHAGE DE LA PLANCHE
		@planche = Planche.creer(grille_jouable.matriceDeJeu)
		
		table.attach(@planche.table, 1, 2, 1, 2)
		
		# contient toutes les aide nécessaires
		aide = Aide.scanner(grille_jouable)

		#Partie basse droite de l"application
		vBoxBas.add(Frame.new("Aide").add(vBoxBasGauche = VBox.new(2)))
		bouton_aide1_txt = Button.new("Un indice!")
		bouton_aide2_txt = Button.new("Que dois-je faire?")

		vBoxBasGauche.pack_start(bouton_aide1_txt)
		vBoxBasGauche.pack_start(bouton_aide2_txt)

		bouton_aide1_txt.signal_connect("clicked"){
			labelAide.set_text(aide.choisirAuHasard(1)) 
			@nbAppelAide += 1  
		}
			
		bouton_aide2_txt.signal_connect("clicked"){
			labelAide.set_text(aide.choisirAuHasard(2)) 
			@nbAppelAide += 2  
		}

		# Lorsque le bouton est relâché, le mode drag and assign de la @planche de jeu est terminé.
		self.signal_connect("button_release_event") {
			@planche.modeDragAndAssign = false
		}
			
		add(vbox)
		set_window_position(:center)
		show_all

		Gtk.main
	end
	
	
	def retexturer(texture)
	 @planche.set_texture(texture)
	 @planche.toutActualiser
	end
	
end
 




 
