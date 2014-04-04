
			
require "gtk2"
require "glib2"
include Gtk

class FenetreScore


	def initialize()


		dialog = Gtk::MessageDialog.new(nil, 
			Gtk::Dialog::DESTROY_WITH_PARENT,
			Gtk::MessageDialog::INFO,
			Gtk::MessageDialog::BUTTONS_CLOSE,
			"Voici les scores...\nToto - 4\nJaco -- -2\nAl Acampagne -- -1\n")
		dialog.run
		dialog.destroy


	end

end
