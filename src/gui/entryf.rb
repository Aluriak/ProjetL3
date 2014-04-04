#ENTRYF.RB
#MAINTENEUR : Ewen Cousin
# -*- encoding: utf-8 -*-
require "gtk2"
require "glib2"
include Gtk
load "src/commun/commun.rb"

#Zone de texte formatée(taille réduite)
#utilisée dans la gui pour les onglets(ou boutons) 'nouveau' et 'éditer'
class Entryf < Entry
	def initialize
		super
		set_max_length(CONSTANT_MAX_CHIFFRES)
		set_width_chars(CONSTANT_MAX_CHIFFRES+1)
	end
end
