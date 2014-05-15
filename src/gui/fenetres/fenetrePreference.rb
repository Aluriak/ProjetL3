# -*- encoding: utf-8 -*-
# FENETRESAUVEGARDE.RB
# définition de la classe FenetreSauvegarde, appellée par la GUI.
# BOURNEUF/COUSIN
#

			
#################################
# IMPORTS			#
#################################
load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"
load "src/picross/picross.rb"

require "gtk2"
require "glib2"
require "date"
include Gtk

class FenetrePreference < Window
	
	def initialize(picross)
		super("Preferences")
		signal_connect("destroy") { destroy }
		set_default_size(100,300)
		set_resizable(false)
		set_modal(true)
		
		box_window = VBox.new

                # 
		@bouton_quitter = Button.new(Stock::OK)
		@bouton_supprimer_data = Button.new("Supprimer les données")
		box_window.pack_start(@bouton_supprimer_data, true, true)
		box_window.pack_start(@bouton_quitter, true, true)
		
                # WINDOW
		self.add(box_window)
		self.set_window_position(:center)
		self.show_all
		
		# CONNECTS
		@bouton_quitter.signal_connect("clicked") { self.destroy }
		@bouton_supprimer_data.signal_connect("clicked") {
                  if self.utilisateurCertainDe("Supprimer toutes les données du jeu") then
                    picross.restaurerDonneesInitiales
                    self.confirmerSuppression()
                  end
		}

		
	end
	
	
	
	
	
	##
	# Confirme à l'utilisateur que la suppression à été effectuée
	def confirmerSuppression()
		dialog = MessageDialog.new(
			nil, 
			Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
			MessageDialog::INFO,
			MessageDialog::BUTTONS_CLOSE,
			"Suppression des données effectuée !"
		)
		
		dialog.run
		dialog.destroy
	end
	
	
	
	
	##
        # Demande à l'utilisateur s'il sohait vraiment réaliser la tâche décrite dans l'argument
	# La méthode renvois vrai si l'utilisateur veux continuer, faux sinon.
	def utilisateurCertainDe(tache)
		dialog = Dialog.new(
			"ATTENTION !", 
			parent,
			Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
			[tache, 1], 
			["Revenir en arrière", 2]
		)
		operation_choisie = 1
		dialog.vbox.add(Label.new("ATTENTION ! Cette opération n'est pas réversible !\nToutes les données de jeu seront perdues !"))
		dialog.signal_connect("response") { |fenetre, id_rep| operation_choisie = id_rep }
		dialog.show_all
		dialog.run
		dialog.destroy
		
		return operation_choisie == 1
	end
	
end
