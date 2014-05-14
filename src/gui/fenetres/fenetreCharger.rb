
			
require "gtk2"
require "glib2"
include Gtk

load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"

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
    cbTailles.set_active(0)

    vb.pack_start(labelTaille)
    vb.pack_start(cbTailles)
    vb.pack_start(cbParties)
    vb.pack_start(buttonValider)

    if(cbTailles.active == 0)
    	tailleFiltre = 5
    elsif(cbTailles.active == 1)
    	tailleFiltre = 10
    elsif(cbTailles.active == 2)
    	tailleFiltre = 15
	elsif(cbTailles.active == 3)
    	tailleFiltre = 20    		
    end
    
    cbTailles.append_text("5")
    cbTailles.append_text("10")
    cbTailles.append_text("15")
    cbTailles.append_text("20")
   

    
    cbTailles.signal_connect "changed" do
       	#Grilles.taille.each { |tailleFiltre| lst_grilles.push(gds.grilleJouablesDeTaille(tailleFiltre)) }
    
    end


    



    buttonValider.signal_connect("clicked"){
    	#picross.gestionnaireDeSauvegarde.chargerGrillesJouables()
    }

    window.set_default_size(500, 200)
    window.set_window_position :center
    window.set_resizable(false)
    window.show_all

	end

end
