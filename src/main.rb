#########MAIN.RB##############
#module à lancer pour jouer au jeu du Picross
#mainteneur : Ewen COUSIN

##########INCLUDES############
load "src/gui/gui.rb"

############JEU###############
Gtk.init
	Gui.lancerTailleDerniereGrille("PICROSS")
Gtk.main

