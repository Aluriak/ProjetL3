# -*- encoding: utf-8 -*-
# FENETRESAUVEGARDERAVANTQUITTER.RB
# définition de la classe FenetreSauvegarderAvantQuitter, appellée par la GUI lorsque l'utilisateur veut quitter.
# BOURDIN
#

			
#################################
# IMPORTS			#
#################################

load "src/gui/fenetres/fenetreSauvegarde.rb"
require "gtk2"
require "glib2"
include Gtk








class FenetreSauvegarderAvantQuitter < Window


	def initialize(picross, timer)


		super("Sauvegarder la grille courante ?")
		self.add(vbox = VBox.new)

		vbox.pack_start(Label.new("Attention vos modifications sur la grille courante seront perdues\nsi vous ne la sauvegardez pas."))
		
		vbox.pack_start(hbox = HBox.new)

		boutonSauvegarder = Button.new("Sauvegarder")
		boutonQuitterSansSauvegarder = Button.new("Fermer sans sauvegarder")
		boutonAnnuler = Button.new("Annuler")

		hbox.pack_start(boutonQuitterSansSauvegarder)
		hbox.pack_start(boutonAnnuler)
		hbox.pack_start(boutonSauvegarder)

		boutonQuitterSansSauvegarder.signal_connect("clicked"){Gtk.main_quit}
		boutonAnnuler.signal_connect("clicked"){self.destroy}
		boutonSauvegarder.signal_connect("clicked"){FenetreSauvegarde.new(picross, timer.sec)}
		boutonSauvegarder.signal_connect("clicked"){self.destroy}

		
		
		self.set_modal(true)
		self.set_window_position(:center)
		self.set_default_size(150,100)
		self.show_all




	end	

end	





	