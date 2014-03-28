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
		vBoxBas.add(table = Table.new(4,4))

		#Chronometre
		timer = Chronometre.initialiser("temps")
		table.attach(timer.text, 0, 1, 0, 1)

		chiffreHaut = TableChiffre.creer(@tailleGrille,5)
		table.attach(chiffreHaut.table, 1, 2, 0, 1)

		chiffreBas = TableChiffre.creer(5,@tailleGrille)
		table.attach(chiffreBas.table, 0, 1, 1, 2)

		planche = Planche.creer(jouable)
		table.attach(planche.table, 1, 2, 1, 2)

		#Partie basse droite de l"application
		vBoxBas.add(vBoxBasGauche = VBox.new(false,3))	
		menuDroit = Menu.creer(vBoxBasGauche,"Btn1", "Btn2", "Btn3")
		
		#Ecouteur signal pour le bouton "Nouveau"
		menuHaut.listBtns[0].signal_connect("clicked") {

			#Creation d'une 2eme fenetre pour choisir la taille de la grille
			popupTailleGrille = Window.new("Nouvelle Grille")
			popupTailleGrille.set_resizable(false)

			vb = VBox.new(false, 6)
			
			vb.pack_start(b = RadioButton.new("5 x 5"))
			vb.pack_start(b2 = RadioButton.new(b, "10 x 10"))
			vb.pack_start(b3 = RadioButton.new(b, "15 x 15"))

			#Ajout de la 1ere horizontal box contenant les zone de saisie pour la taille de la grille
			hbTailleAutre = HBox.new(false, 1)
			hbTailleAutre.pack_start(RadioButton.new(b, ""))
			hbTailleAutre.pack_start(Label.new("Autre"), false, true, 6)
			hbTailleAutre.pack_start(taille1 = Entry.new, true, true)
			hbTailleAutre.pack_start(Label.new("X"), true, true)
			hbTailleAutre.pack_start(taille2 = Entry.new, true, true)
			vb.pack_start(hbTailleAutre)

			#Ajout de la 2eme horizontal box contenant boutons
			hbBouton = HBox.new(false, 1)
			hbBouton.pack_start(Button.new(Stock::OK), true, true)
			hbBouton.pack_start(cancel = Button.new(Stock::CLOSE), true, true)
			#Marche pas!!!   cancel.signal_connect("clicked") { Gtk.main_exit }
			vb.pack_start(hbBouton)


			popupTailleGrille.add(vb)
			popupTailleGrille.show_all
		}


		#Ecouteur signal pour le bouton "Editer"
		menuHaut.listBtns[1].signal_connect("clicked"){


			fenetreEditer = Window.new("Editer");
			fenetreEditer.set_resizable(false)

			vBoxPrincipal = VBox.new(false, 2)
			vBoxPrincipal.pack_start(hBoxHaut = HBox.new(false, 2))
			hBoxHaut.pack_start(vBoxTaille = VBox.new(false, 2))

			vBoxTaille.pack_start( Label.new("Taille"))	
			vBoxTaille.pack_start(b = RadioButton.new("5 x 5"))
			vBoxTaille.pack_start(b1 = RadioButton.new(b, "10 x 10"))
			vBoxTaille.pack_start(b2 = RadioButton.new(b, "15 x 15"))	

			hbTailleAutre = HBox.new(false, 1)
			vBoxTaille.pack_start(hbTailleAutre)
			hbTailleAutre.pack_start(b3 = RadioButton.new(b, ""))
			hbTailleAutre.pack_start(Label.new("Autre"), false, true, 6)
			hbTailleAutre.pack_start(taille1 = Entry.new, true, true)
			hbTailleAutre.pack_start(Label.new("X"), true, true)
			hbTailleAutre.pack_start(taille2 = Entry.new, true, true)
		
		


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
		menuHaut.listBtns[2].signal_connect("clicked"){
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
		menuHaut.listBtns[3].signal_connect("clicked"){
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
		menuHaut.listBtns[4].signal_connect("clicked"){

		

			dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::DESTROY_WITH_PARENT,
                                Gtk::MessageDialog::INFO,
                                Gtk::MessageDialog::BUTTONS_CLOSE,
                                "Dlaaaaa merde j'arrive pas a mettre plusieurs lignes dans cette boite de dialogue ><")
			dialog.run
			dialog.destroy
			
		}

		#evenement clique le bouton "Manuel"
		menuHaut.listBtns[5].signal_connect("clicked") {
			about = AboutDialog.new
				about.set_website "http://fr.wikipedia.org/wiki/Picross"
			about.run
			about.destroy

		}

		#evenement clique le bouton "A Propos"
		menuHaut.listBtns[6].signal_connect("clicked") {
			about = AboutDialog.new
					about.set_program_name "ProjetPicrossL3"
					about.set_version "0.1"
					about.set_copyright "(c) Groupe B"
				about.run
				about.destroy
		}
			
		window.add(vbox)
		window.show_all
		
		Gtk.main
	end
end
 




 
