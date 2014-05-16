#
#
#	Fenetre qui affiche le manuel
#	Pour l'instant, n'affiche que le lien sur wikipedia:Picross
#
#
require "gtk2"
require "glib2"
include Gtk

class FenetreManuelUtilisateur

	

	def initialize

		fichier_pdf = "report/manuel.pdf"
		system("evince "+ fichier_pdf)
	end

end
