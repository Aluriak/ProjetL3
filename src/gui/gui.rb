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
load "src/gui/entryf.rb"
load "src/grille/jouable.rb"
load "src/configuration/configuration.rb"
load "src/picross/picross.rb"

class Gui < Window

	@tailleGrille	
	
	def Gui.lancer(titre)
		new(titre)
	end
	
	def initialize(titre)
		super
		p = Picross.new
		@tailleGrille = p.config.derniereTailleGrille

		signal_connect("destroy") { Gtk.main_quit }
		set_resizable(false)
		
		vbox = VBox.new(false, 2)
		jouable = GrilleJouable.deTaille(@tailleGrille)
	
		#Partie haute de l"application
		vbox.pack_start(hBoxHaut = HBox.new(false, 2))
		menuHaut = Menu.creer(hBoxHaut,"Nouveau", "Editer", "Charger", "Sauver", "Score" ,"Manuel", "A propos")

		#Partie basse de l"application
		vbox.pack_start(hBoxBas = HBox.new(false, 2))
		hBoxBas.add(vBoxBas = HBox.new(false))
		vBoxBas.add(table = Table.new(4,4))

		#Chronometre
		timer = Chronometre.initialiser("temps")
		table.attach(timer.text, 0, 1, 0, 1)

		chiffreHaut = TableChiffre.creer(jouable.matriceDesColonnes)
		table.attach(chiffreHaut.table, 1, 2, 0, 1)

		chiffreBas = TableChiffre.creer(jouable.matriceDesLignes)
		table.attach(chiffreBas.table, 0, 1, 1, 2)

		planche = Planche.creer(jouable)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(vBoxBasGauche = VBox.new(false,3))	
		menuDroit = Menu.creer(vBoxBasGauche,"Aide_1", "Aide_2", "Aide_3")
		
		#Ecouteur signal pour le bouton "Nouveau"
		menuHaut.clickerSur("Nouveau"){

			#Creation d'une 2eme fenetre pour choisir la taille de la grille
			fenetreNouvelleGrille = Window.new("Nouvelle Grille")
			fenetreNouvelleGrille.set_resizable(false)

			vb = VBox.new(false, 6)
			
			vb.pack_start(b = RadioButton.new("5 x 5"))
			vb.pack_start(b2 = RadioButton.new(b, "10 x 10"))
			vb.pack_start(b3 = RadioButton.new(b, "15 x 15"))

			#Ajout de la 1ere horizontal box contenant les zone de saisie pour la taille de la grille
			hbTailleAutre = HBox.new(false, 1)
			hbTailleAutre.pack_start(RadioButton.new(b, ""))
			hbTailleAutre.pack_start(Label.new("Autre"), false, true, 6)
			hbTailleAutre.pack_start(taille1 = Entryf.new, true, true)
			hbTailleAutre.pack_start(Label.new("*"), true, true)
			hbTailleAutre.pack_start(taille2 = Entryf.new, true, true)
			vb.pack_start(hbTailleAutre)

			#Ajout de la 2eme horizontal box contenant boutons
			hbBouton = HBox.new(false, 1)
			hbBouton.pack_start(ok = Button.new(Stock::OK), true, true)
			hbBouton.pack_start(cancel = Button.new(Stock::CLOSE), true, true)
			
			cancel.signal_connect("clicked"){fenetreNouvelleGrille.destroy}
			
			ok.signal_connect("clicked"){
				fenetreNouvelleGrille.destroy
				#A FAIRE
			}
		
			vb.pack_start(hbBouton)


			fenetreNouvelleGrille.add(vb)
			fenetreNouvelleGrille.show_all
		}


		#Ecouteur signal pour le bouton "Editer"
		menuHaut.clickerSur("Editer"){

			fenetreEditer = Window.new("Editer");
			fenetreEditer.set_resizable(false)

			vBoxPrincipal = VBox.new(false, 2)
			vBoxPrincipal.pack_start(hBoxHaut = HBox.new(false, 2))
			hBoxHaut.pack_start(vBoxTaille = VBox.new(false, 2))

			vBoxTaille.pack_start( Label.new("Taille"))	
			vBoxTaille.pack_start(b_5  = RadioButton.new("5 x 5"))
			vBoxTaille.pack_start(b_10 = RadioButton.new(b_5, "10 x 10"))
			vBoxTaille.pack_start(b_15 = RadioButton.new(b_5, "15 x 15"))
			vBoxTaille.pack_start(b_20 = RadioButton.new(b_5, "20 x 20"))	
			vBoxTaille.pack_start(b_25 = RadioButton.new(b_5, "25 x 25"))	

			hbTailleAutre = HBox.new(false, 1)
			vBoxTaille.pack_start(hbTailleAutre)
		
			hbTailleAutre.pack_start(tailleC = Entryf.new, true, true)	
			hbTailleAutre.pack_start(Label.new(" x "), true, true)
			hbTailleAutre.pack_start(tailleL = Entryf.new, true, true)

			hBoxHaut.pack_start(vBoxType = VBox.new(false, 2))
			vBoxType.pack_start( Label.new("Type"))
			vBoxType.pack_start(b4 = RadioButton.new("Vierge"))

			vBoxType.pack_start(hBoxChargerImage = HBox.new(false, 2))
			hBoxChargerImage.pack_start(b5 = RadioButton.new(b4, ""))

			#Ecouteur boutton charger Image
			hBoxChargerImage.pack_start(btnChargerImage = Button.new("Charger Image"))

			btnChargerImage.signal_connect("clicked"){
				dialog = FileChooserDialog.new("Charger Image",
					nil, 
		            FileChooser::ACTION_OPEN, 
		            nil,
					[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
					[Stock::OPEN, Dialog::RESPONSE_ACCEPT])


				if dialog.run == Dialog::RESPONSE_ACCEPT
					puts "filename = #{dialog.filename}"
				end
				dialog.destroy
			}

			vBoxPrincipal.pack_start(hBoxBas = HBox.new(false, 2))
			#Ajout de la 2eme horizontal box contenant boutons
			hBoxBas.pack_start(ok = Button.new(Stock::OK), true, true)
			hBoxBas.pack_start(cancel = Button.new(Stock::CLOSE), true, true)

			fenetreEditer.add(vBoxPrincipal)
			fenetreEditer.show_all
		
			cancel.signal_connect("clicked"){fenetreEditer.destroy}
		
			ok.signal_connect("clicked"){
				fenetreEditer.destroy
				popupEdition = Window.new("Edition Grille")
				popupEdition.set_resizable(false)
				vbox = VBox.new(false, 2)
				jouable = GrilleJouable.deTaille(@tailleGrille)
				#Grille
				vbox.pack_start(hBoxMilieu = HBox.new(false, 2))
				hBoxMilieu.add(vBoxBas = HBox.new(false))
				vBoxBas.add(table = Table.new(4,4))


				vbox.add(hBoxBas = HBox.new(false, 2))
				hBoxBas.pack_start(Button.new(Stock::OK))
				hBoxBas.pack_start(Button.new(Stock::CANCEL))

	
				planche = Planche.creer(jouable)
				table.attach(planche.table, 1, 2, 1, 2)
				popupEdition.add(vbox)
				popupEdition.show_all
			}
		}

		#Ecouteur signal pour le bouton "Charger"
		menuHaut.clickerSur("Charger"){
			dialog = FileChooserDialog.new("Charger une grille",
					nil,
					FileChooser::ACTION_OPEN,
					nil,
					[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
					[Stock::OPEN, Dialog::RESPONSE_ACCEPT])


		if dialog.run == Dialog::RESPONSE_ACCEPT
		puts "filename = #{dialog.filename}"
		end
		dialog.destroy

		}

		#Ecouteur signal pour le bouton "Sauvegarder"
		menuHaut.clickerSur("Sauver"){
			dialog = FileChooserDialog.new("Sauvegarder une grille",
											nil,
											FileChooser::ACTION_OPEN,
											nil,
											[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
											[Stock::OPEN, Dialog::RESPONSE_ACCEPT])


		if dialog.run == Dialog::RESPONSE_ACCEPT
		puts "filename = #{dialog.filename}"
		end
		dialog.destroy

		}

		#Ecouteur signal pour le bouton "Score"
		menuHaut.clickerSur("Score"){

			dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::DESTROY_WITH_PARENT,
                                Gtk::MessageDialog::INFO,
                                Gtk::MessageDialog::BUTTONS_CLOSE,
                                "Dlaaaaa merde j'arrive pas a mettre plusieurs lignes dans cette boite de dialogue ><")
			dialog.run
			dialog.destroy
			
		}

		#evenement clique le bouton "Manuel"
		menuHaut.clickerSur("Manuel"){
			about = AboutDialog.new
			about.set_website "http://fr.wikipedia.org/wiki/Picross"
			about.run
			about.destroy
		}
		
		#evenement clique le bouton "A Propos"
		menuHaut.clickerSur("A propos") {
			about = AboutDialog.new
			about.set_program_name("Picross")
			about.set_version("0.1")	
			auteurs = [
				"\nLucas Bourneuf(Chef de Projet)",
				"Charlie Marechal(Documentaliste)",
				"Nicolas Bourdin(Developpeur)",
				"Ewen Cousin(Developpeur)",
				"Jaweed Parwany(Developpeur)",
				"Julien Le Gall(Developpeur)",
		        "\n@ : prenom.nom.etu@univ-lemans.fr"
		    ]
			about.set_authors(auteurs)	
			about.set_copyright("(c) Groupe B")
			about.run
			about.destroy
		}
			
		add(vbox)
		show_all
	end
end
 




 
