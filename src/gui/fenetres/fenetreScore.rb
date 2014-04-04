
			
require "gtk2"
require "glib2"
include Gtk

class FenetreScore

	@score
	
	def initialize(score)

		@score = score

		dialog = MessageDialog.new(nil, 
			Dialog::DESTROY_WITH_PARENT,
			MessageDialog::INFO,
			MessageDialog::BUTTONS_CLOSE,
			"Voici les scores:\nToto - 4\nJaco -- -2\nAl Acampagne -- -1\n")
		dialog.run
		dialog.destroy


	end

end
