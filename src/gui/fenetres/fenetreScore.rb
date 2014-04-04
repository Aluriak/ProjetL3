
			
require "gtk2"
require "glib2"
include Gtk

class FenetreScore


	def initialize()


		dialog = Gtk::MessageDialog.new(nil, 
                                Gtk::Dialog::DESTROY_WITH_PARENT,
                                Gtk::MessageDialog::INFO,
                                Gtk::MessageDialog::BUTTONS_CLOSE,
                                "Dlaaaaa merde j'arrive pas a mettre plusieurs lignes dans cette boite de dialogue ><")
		dialog.run
		dialog.destroy


	end

end
