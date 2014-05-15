# -*- encoding: utf-8 -*-

			
require "gtk2"
require "glib2"
include Gtk

load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"

class FenetreCharger < Window


	def initialize(parent_gui, picross)
		super("Charger une partie")
		add(vb = VBox.new)
		set_default_size(240, 60)
		set_resizable(false)
		set_window_position(:center)
		

                # WIDGETS
                # Liste des tailels de grille
		labelTaille = Label.new("Taille de la grille : ")
		cbTailles = ComboBox.new
                # ajout des tailles de grilles 
		Grille.tailles.each() { |t| cbTailles.append_text(t.to_s) }
		cbTailles.set_active(0)

                # Liste des parties jouables
		cbParties = ComboBox.new
                picross.grillesJouablesDeTaille(5).each { |grille| cbParties.append_text(grille.nom_de_sauvegarde) }
		
		# Bouton de validation	
                box_button = HBox.new
		buttonValider = Button.new("Valider")
                buttonSupprimer = Button.new("Supprimer")
                buttonValider.sensitive = (cbParties.active_text != nil)
                buttonSupprimer.sensitive = (cbParties.active_text != nil)
                box_button.pack_start(buttonValider, true, true)
                box_button.pack_start(buttonSupprimer, true, true)
	

                # PACKING
		vb.pack_start(hboxTaille = HBox.new(2))
		hboxTaille.pack_start(labelTaille)
		hboxTaille.pack_start(cbTailles)
		vb.pack_start(cbParties)
		vb.pack_start(box_button)

		
	        # CONNECTS	
		cbTailles.signal_connect("changed") {
                  sauvegardes = picross.grillesJouablesDeTaille(cbTailles.active_text.to_i) # nouvelles entrées
                  # on supprime celle actuelles et on rajoute les nouvelles
                  cbParties.remove_text(0) while cbParties.active_text != nil
                  sauvegardes.each { |grl| cbParties.append_text(grl.nom_de_sauvegarde) } 
                  # si il n'y a pas de parties dispos, validation impossible
                  buttonValider.sensitive = (cbParties.active_text != nil)
                  buttonSupprimer.sensitive = (cbParties.active_text != nil)
		}

		cbParties.signal_connect("changed") {
                  # si il n'y a pas de partie sélectionnée, validation impossible
                  buttonValider.sensitive = (cbParties.active_text != nil)
                  buttonSupprimer.sensitive = (cbParties.active_text != nil)
		}
			
		buttonValider.signal_connect("clicked"){
                  taille, nom = cbTailles.active_text.to_i, cbParties.active_text
                  parent_gui.destroy    # destruction de la gui existante
                  self.destroy          # destruction de la fenetre de chargement
                  # et création d'une nouvelle
                  gui = Gui.new(taille, nom)
		}

                buttonSupprimer.signal_connect("clicked") {
                  taille, nom = cbTailles.active_text.to_i, cbParties.active_text
                  if self.confirmerSupression(nom) then
                    picross.supprimerGrilleJouableNommee(nom, taille)
                    # mise à jour des parties disponibles
                    sauvegardes = picross.grillesJouablesDeTaille(cbTailles.active_text.to_i) # nouvelles entrées
                    # on supprime celle actuelles et on rajoute les nouvelles
                    cbParties.remove_text(0) while cbParties.active_text != nil
                    sauvegardes.each { |grl| cbParties.append_text(grl.nom_de_sauvegarde) } 
                    # si il n'y a pas de parties dispos, validation impossible
                    buttonValider.sensitive = (cbParties.active_text != nil)
                    buttonSupprimer.sensitive = (cbParties.active_text != nil)
                  end
                }

		
                # SHOW
		self.show_all
	end





  ##
  # Demande à l'utilisateur si la suppression de sauvegarde doit être confirmée.
  # renvois vrai si l'utilisateur confirme, faux sinon.
  def confirmerSupression(nom)
    dialog = Dialog.new(
      "Suppression de sauvegarde", 
      self,
      Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
      ["Supprimer", 1], 
      ["Revenir en arrière", 2]
    )
    operation_choisie = 1
    dialog.vbox.add(Label.new("Supprimer la sauvegarde " + nom + " ?"))
    dialog.signal_connect("response") { |fenetre, id_rep| operation_choisie = id_rep }
    dialog.show_all
    dialog.run
    dialog.destroy

    return operation_choisie == 1
  end
end
