
			
require "gtk2"
require "glib2"
include Gtk

class FenetreSauvegarder


	def initialize

		#A FAIRE
		dialog = MessageDialog.new(
			nil, 
			Gtk::Dialog::DESTROY_WITH_PARENT,
			Gtk::MessageDialog::INFO,
			Gtk::MessageDialog::BUTTONS_CLOSE,
			"Sauvegarde faite!")

		dialog.run
		dialog.detroy

	end

end
