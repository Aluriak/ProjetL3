
			
require "gtk2"
require "glib2"
include Gtk

class FenetreSauvegarder
	
	#prend le picross en paramètre
	#pour ::
	def initialize(picross)

		#picross.
		dialog = MessageDialog.new(
			nil, 
			Gtk::Dialog::DESTROY_WITH_PARENT,
			Gtk::MessageDialog::INFO,
			Gtk::MessageDialog::BUTTONS_CLOSE,
			"Sauvegarde faite!")

		dialog.run
		dialog.destroy

	end

end
