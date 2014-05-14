
require "gtk2"
require "glib2"
include Gtk

load "src/gui/fenetres/grilleEditable.rb"
load "src/image/image.rb" # cause des problèmes(conflits) entre Gtk::Image et RMagick::Image, à voir comment changer ça

#		
#				FENETRE EDITION TAILLE
#
#	Cette fenetre affiche les différents élements qu'on veut parametrer pour ensuite travailler
#	sur une grille en mode Edition
#
class FenetreEditionTaille

	@tailleGrille
	@chemin	#texte qui est soit "vierge" soit le chemin de l'image (soit "pleine" +tard)
	
	def initialize
		
		p "pas beug\n"

		@chemin = "vierge"
		
		fenetreEditer = Window.new("Editer")
		fenetreEditer.set_resizable(true)

		vBoxPrincipal = VBox.new(false, 3)
		vBoxPrincipal.pack_start(hBoxHaut 	= HBox.new(false, 2))
		vBoxPrincipal.pack_start(hBoxMilieu	= HBox.new(false, 1))
		vBoxPrincipal.pack_start(hBoxBas 	= HBox.new(false, 2))
		
		hBoxHaut.pack_start(Frame.new("Taille").add(vBoxTaille = VBox.new(false, 2)))
		
		
		
		vBoxTaille.pack_start(rb5 	= RadioButton.new("5 x 5"))
		vBoxTaille.pack_start(rb10 	= RadioButton.new(rb5, "10 x 10"))
		vBoxTaille.pack_start(rb15	= RadioButton.new(rb10, "15 x 15"))
		vBoxTaille.pack_start(rb20 	= RadioButton.new(rb15, "20 x 20"))
		vBoxTaille.pack_start(rb25 	= RadioButton.new(rb20, "25 x 25"))
		
		hBoxHaut.pack_start(Frame.new("Type").add(vBoxType = VBox.new(false, 2)))
		vBoxType.pack_start(rbVierge = RadioButton.new("Vierge"))
		vBoxType.pack_start(rbPleine = RadioButton.new(rbVierge, "Pleine"))
		
		
		vBoxType.pack_start(hBoxChargerImage = HBox.new(false, 2))
		hBoxChargerImage.pack_start(rbCharger = RadioButton.new(rbPleine, ""))
		hBoxChargerImage.pack_start(boutonChargerImage = Button.new("Charger Image"))
		boutonChargerImage.set_sensitive(false)
		
		hBoxMilieu.pack_start(entryPath = Entry.new)
		
	


		rbVierge.signal_connect("clicked") { 
			boutonChargerImage.set_sensitive(false)
			entryPath.set_visible(false)
			@chemin = "vierge"
		}		
		
		rbPleine.signal_connect("clicked") { 
			boutonChargerImage.set_sensitive(false)
			@chemin = "pleine"
			entryPath.set_visible(false)
		}
		rbCharger.signal_connect("clicked"){ 
			boutonChargerImage.set_sensitive(true)
			entryPath.set_visible(true) 
			@chemin = "image?"
		}
		
		#Ecouteur boutton charger Image
		boutonChargerImage.signal_connect("clicked"){
			dialog = FileChooserDialog.new("Charger Image", nil, FileChooser::ACTION_OPEN, nil,
				[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
				[Stock::OPEN, Dialog::RESPONSE_ACCEPT]
			)

			if dialog.run == Dialog::RESPONSE_ACCEPT
				puts "filename = #{dialog.filename}"
			end
		
			entryPath.set_text(@chemin = dialog.filename)
		
			dialog.destroy
		}
		
		
		#Ajout de la 2eme horizontal box contenant les boutons
		hBoxBas.pack_start(boutonOK = Button.new(Stock::OK), true, true)
		hBoxBas.pack_start(boutonFermer = Button.new(Stock::CLOSE), true, true)
		
		boutonFermer.signal_connect("clicked"){
			fenetreEditer.destroy
			#Gui.lancer
		}
		
		boutonOK.signal_connect("clicked"){
				
			if (rb5.active?)
				@tailleGrille = 5
			elsif (rb10.active?)
				@tailleGrille = 10
			elsif (rb15.active?)
				@tailleGrille = 15
			elsif (rb20.active?)
				@tailleGrille = 20
			elsif (rb25.active?)
				@tailleGrille = 25
			end

			fenetreEditer.destroy

			grilleDetat =  Array.new(@tailleGrille) { Array.new(@tailleGrille)}
		
			if @chemin == "vierge"
				0.upto(@tailleGrille-1) { |x| 
					0.upto(@tailleGrille-1) { |y|
						grilleDetat[x][y] = Etat.Blanc
					}
				}
				
			elsif @chemin == "pleine"
				0.upto(@tailleGrille-1) { |x| 
					0.upto(@tailleGrille-1) { |y|
						grilleDetat[x][y] = Etat.Noir
					}
				}

			else
				# nota : c'est possible que l'image soit toute blanche
				# même si l'image d'origine n'est pas un carré blanc
				# c'est juste qu'avec la compression, ça tranforme en tout en blanc
				# pour vérifier que ça marche bien, tester sur une 25x25
				image = PicrossImage.lire(@chemin)
				grilleDetat = image.toPicross(@tailleGrille)
				#print "imagePicross:#{image.afficherMatrice}\n"
			end
		
			p grilleDetat
			grilleEditable = GrilleEditable.new(grilleDetat)
		
		}#fin de clic du boutonOK
		
		
		boutonFermer.signal_connect("clicked"){ fenetreEditer.destroy }

		fenetreEditer.add(vBoxPrincipal)
		fenetreEditer.set_window_position(:center)
		fenetreEditer.show_all

		entryPath.set_visible(false)
	end
end
