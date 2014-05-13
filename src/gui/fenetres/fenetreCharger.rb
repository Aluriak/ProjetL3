
			
require "gtk2"
require "glib2"
include Gtk

class FenetreCharger


	def initialize(picross)
		window = Window.new("Charger une partie")
		window.add(vb = VBox.new)
		
    cbParties = ComboBox.new
    cbParties.signal_connect "changed" do |w, e|
    	on_changed w, e, label
		end

		

    #picross.gestionnaireDeSauvegarde.each { |nom| @combo_profils.append_text(nom) }
    buttonValider = Button.new("Valider")
    labelTaille = Label.new("Taille de la grille")
    cbTailles = ComboBox.new

    vb.pack_start(labelTaille)
    vb.pack_start(cbTailles)
    vb.pack_start(cbParties)
    vb.pack_start(buttonValider)

    cbParties.set_visible(false)
    cbParties.signal_connect "changed" do |w, e|
    	#on_changed w, e, label
    	cbParties.set_visible(true)
		end


    cbTailles.append_text("5")
    cbTailles.append_text("10")
    cbTailles.append_text("15")
    cbTailles.append_text("20")

    

    buttonValider.signal_connect("clicked"){
    	#picross.gestionnaireDeSauvegarde.chargerGrillesJouables()
    }


    window.set_resizable(false)
    window.show_all

	end

end
