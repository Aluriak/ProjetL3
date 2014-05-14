# -*- encoding: utf-8 -*-
# CENTRE DU PROGRAMME GUI.RB
# EWEN COUSIN/NICOLAS BOURDIN


require "gtk2"
require "glib2"
include Gtk

load "src/gui/planche.rb"
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
load "src/gui/fenetres/fenetreFinJeu.rb"
load "src/aide/aideWrap.rb"

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
	
	@picross = Picross.new
	@derniereTailleGrille = @picross.derniereTailleDeGrille
	
	# la gui crée un picross à son lancement
	attr_reader :picross
	
	# window est la fenetre affichée
	#attr_reader :window
	
	# la taille de la derniere taille de grille
	# pratique pour l'utilisateur; s'il jouait sur une grille
	# de 20*20, le jeu chargera une grille de 20*20
	attr_reader :derniereTailleGrille
	
	def Gui.lancer(tailleChoisie = @derniereTailleGrille)
		new(tailleChoisie)
	end

	def Gui.fermer
		
	end	
	
	def initialize(tailleGrille)
    @nbAppelAide = 0
		@picross = Picross.new
		@picross.nouvelleGrilleDeTaille(tailleGrille)
		super("Picross")
		signal_connect("destroy") { Gtk.main_quit }
		set_resizable(false)
		vbox = VBox.new(false, 2)
    add_events(Gdk::Event::BUTTON_PRESS_MASK)
		
		grille_jouable = @picross.grille
	
		#Partie haute de l"application
		vbox.pack_start(hBoxHaut = HBox.new(false, 2))
		
		menuHaut = MenuPrincipal.creerMenuHaut(hBoxHaut)
		
		menuHaut.clickerSur("Nouveau")	{ nouveau = FenetreNouveauTaille.new(self) }
		menuHaut.clickerSur("Editer")	{ print "fenetreEditer\n"; fenetreEditer = FenetreEditionTaille.new }
		menuHaut.clickerSur("Charger")	{ fenetreCharger = FenetreCharger.new(@picross)}
		menuHaut.clickerSur("Sauvegarder"){ fenetreSauvegarder = FenetreSauvegarde.new(@picross) }
		menuHaut.clickerSur("Score")	{ fenetreScore = FenetreScore.new(self, @picross.scores.scoresDeGrille(@picross.grille.nom), @picross.grille.nom) } 
		menuHaut.clickerSur("Manuel")	{ fenetreManuel = FenetreManuel.new }
		menuHaut.clickerSur("A Propos")	{ fenetreAPropos = FenetreAPropos.new}


		# Gestion du chronomètre
		timer_label = Label.new("")
		timer = Chronometre.new(timer_label)
		# arrêt/départ du chrono suivant le focus de la fenêtre par l'utilisateur
		signal_connect("focus_in_event") { timer.start }
		signal_connect("focus_out_event") { timer.stop }
		
		# intégration à la GUI
		boxTimer = VBox.new(false, 2)
		boxTimer.pack_start(Frame.new.add(timer_label))
		
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
                          @picross.nouvelleGrilleDeTaille(@picross.grille.taille)
                          timer.raz
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

		# table de ligne
		labelsNombreLigne = Table.new(grille_jouable.tableLigne.largeur, grille_jouable.tableLigne.hauteur)
		# pour chaque ligne
		grille_jouable.tableLigne.hauteur.times { |row|
			nombres = grille_jouable.tableLigne.nombresDeLaLigne(row)
			# pour chaque nombre de la ligne
			nombres.size.times { |col|
				nombre = nombres[col].to_s
				labelsNombreLigne.attach(Label.new(nombre), col, col+1, row, row+1) 
			}
		}
		
		table.attach(labelsNombreLigne, 0, 1, 1, 2)
		
		
		# table de colonne
		labelsNombreColonne = Table.new(grille_jouable.tableColonne.largeur, grille_jouable.tableColonne.hauteur)
		# pour chaque colonne
		grille_jouable.tableColonne.largeur.times do |col|
			nombres = grille_jouable.tableColonne.nombresDeLaColonne(col)
			# pour chaque nombre de la colonne
			nombres.size.times do |row|
			nombre = nombres[row].to_s
			labelsNombreColonne.attach(Label.new(nombre), col, col+1, row, row+1) 
			end
		end
		
		table.attach(labelsNombreColonne, 1, 2, 0, 1)

                # AFFICHAGE DE LA PLANCHE
		planche = Planche.creer(grille_jouable)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(Frame.new.add(vBoxBasGauche = VBox.new(2)))
    bouton_aide1_txt = Button.new("Aiguillez-moi !")
    bouton_aide2_txt = Button.new("Que dois-je faire?")

    vBoxBasGauche.pack_start(bouton_aide1_txt)
    vBoxBasGauche.pack_start(bouton_aide2_txt)

    bouton_aide1_txt.signal_connect("clicked"){
      aide = AideWrap.deNiveau1Sur(@picross.grille.matriceDeJeu)
      @nbAppelAide += 1  
      labelAide.set_text(aide) # TODO: afficher l'aide proprement
		}
     
    bouton_aide2_txt.signal_connect("clicked"){
      aide = AideWrap.deNiveau2Sur(@picross.grille.matriceDeJeu)
      @nbAppelAide += 2  
      labelAide.set_text(aide) # TODO: afficher l'aide proprement
    }
              
    add(vbox)
    set_window_position(:center)
    show_all
    
    Gtk.main
  end
end
 




 
