#
#
#	Fenetre qui affiche le manuel
#	Pour l'instant, n'affiche que le lien sur wikipedia:Picross
#
#
require "gtk2"
require "glib2"
include Gtk

class FenetreManuel

	def initialize
		about = AboutDialog.new
		about.set_website("http://fr.wikipedia.org/wiki/Picross")
		about.run
		about.destroy
	end

end
