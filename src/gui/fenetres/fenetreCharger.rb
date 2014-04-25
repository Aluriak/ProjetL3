
			
require "gtk2"
require "glib2"
include Gtk

class FenetreCharger


	def initialize()


		dialog = FileChooserDialog.new("Charger une grille",
			nil,
			FileChooser::ACTION_OPEN,
			nil,
			[Stock::CANCEL, Dialog::RESPONSE_CANCEL],
			[Stock::OPEN, Dialog::RESPONSE_ACCEPT]
		)

		if dialog.run == Dialog::RESPONSE_ACCEPT
			puts "filename = #{dialog.filename}"
		end
		dialog.destroy


	end

end
