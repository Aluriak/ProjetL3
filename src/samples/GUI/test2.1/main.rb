require "gtk2"
include Gtk

load "Planche.rb"
load "Menu.rb"
load "TableChiffre.rb"

TAILLE_GRILLE = 15

Gtk.init
folder = "ressources"+"/"

window = Window.new("Picross")
window.signal_connect("destroy") { Gtk.main_quit }

vbox = VBox.new(false, 2)

#Partie haute de l"application
vbox.pack_start(hBoxHaut = HBox.new(false, 2))
menuHaut = Menu.creer(hBoxHaut,"Nouveau", "Charger", "Sauvegarder", "Manuel", "A propos")


#Ecouteur signal pour le bouton "Nouveau"
menuHaut.listBtns[0].signal_connect('clicked') {



	#Creation d'une 2eme fenetre pour choisir la taille de la grille
	popupTailleGrille = Gtk::Window.new("Taille de la grille")

	vb = Gtk::VBox.new(false, 6)
	b = Gtk::RadioButton.new('5 x 5')
	vb.pack_start(b)
	b2 = Gtk::RadioButton.new(b, '10 x 10')
	vb.pack_start(b2)
	b3 = Gtk::RadioButton.new(b, '15 x 15')
	vb.pack_start(b3)

	#Ajout de la 1ere horizontal box contenant les zone de saisie pour la taille de la grille
	hbTailleAutre = Gtk::HBox.new(false, 1)
	hbTailleAutre.pack_start(Gtk::Label.new('Autre'), false, true, 6)
	hbTailleAutre.pack_start(taille1 = Gtk::Entry.new, true, true)
	hbTailleAutre.pack_start(Gtk::Label.new('X'), true, true)
	hbTailleAutre.pack_start(taille2 = Gtk::Entry.new, true, true)
	vb.pack_start(hbTailleAutre)

	#Ajout de la 2eme horizontal box contenant boutons
	hbBouton = Gtk::HBox.new(false, 1)
	hbBouton.pack_start(Gtk::Button.new(Gtk::Stock::OK), true, true)
	hbBouton.pack_start(cancel = Gtk::Button.new(Gtk::Stock::CLOSE), true, true)
	#Marche pas!!!   cancel.signal_connect('clicked') { Gtk.main_exit }
	vb.pack_start(hbBouton)





	popupTailleGrille.add(vb)
	popupTailleGrille.show_all

}




#Ecouteur signal pour le bouton "Charger"
menuHaut.listBtns[1].signal_connect('clicked'){
	dialog = Gtk::FileChooserDialog.new("Charger une grille",
                                     nil,
                                     Gtk::FileChooser::ACTION_OPEN,
                                     nil,
                                     [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                     [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])


if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
  puts "filename = #{dialog.filename}"
end
dialog.destroy

}



#Ecouteur signal pour le bouton "Sauvegarder"
menuHaut.listBtns[2].signal_connect('clicked'){
	dialog = Gtk::FileChooserDialog.new("Sauvegarder une grille",
                                     nil,
                                     Gtk::FileChooser::ACTION_OPEN,
                                     nil,
                                     [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL],
                                     [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT])


if dialog.run == Gtk::Dialog::RESPONSE_ACCEPT
  puts "filename = #{dialog.filename}"
end
dialog.destroy

}


#Ecouteur signal pour le bouton "Manuel"
menuHaut.listBtns[3].signal_connect('clicked') {
	about = Gtk::AboutDialog.new
		about.set_website "http://fr.wikipedia.org/wiki/Picross"
	about.run
        about.destroy

}


#Ecouteur signal pour le bouton "A Propos"
menuHaut.listBtns[4].signal_connect('clicked') {
	about = Gtk::AboutDialog.new
        	about.set_program_name "ProjetPicrossL3"
        	about.set_version "0.1"
        	about.set_copyright "(c) Groupe B"
        about.run
        about.destroy
}

#Partie basse de l"application
vbox.pack_start(hBoxBas = HBox.new(false, 2))
hBoxBas.add(vBoxBas = HBox.new(false))
vBoxBas.add(table = Table.new(4,4))


timer = Label.new.set_text("Timer 0:0")
table.attach(timer, 0, 1, 0, 1)

#chiffreHaut = Button.new("Chiffre Haut")
chiffreHaut = TableChiffre.creer(TAILLE_GRILLE,5)
table.attach(chiffreHaut.table, 1, 2, 0, 1)

#chiffreBas = Button.new("Chiffre Bas")
chiffreBas = TableChiffre.creer(5,TAILLE_GRILLE)
table.attach(chiffreBas.table, 0, 1, 1, 2)

planche = Planche.creer(TAILLE_GRILLE)
table.attach(planche.table, 1, 2, 1, 2)

#Partie basse droite de l"application
vBoxBas.add(vBoxBasGauche = VBox.new(false))	
menuDroit = Menu.creer(vBoxBasGauche,"Btn1", "Btn2", "Btn3")
	
window.add(vbox)


window.show_all

Gtk.main
 
