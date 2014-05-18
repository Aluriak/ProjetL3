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
	
	@listesTextures
	
	def initialize(picross, gui)		
		
		super("Preferences")
		signal_connect("destroy") { destroy }
		set_default_size(200,40)
		#set_resizable(false)
		set_modal(true)
		
		vbox_principale = VBox.new

		vbox_principale.pack_start(Label.new("Texture"))
		vbox_principale.pack_start(@combo_textures = ComboBox.new(true))
		
		@listesTextures = recupererLesTextures
		
		@listesTextures.each { |texture|
			@combo_textures.insert_text(@listesTextures.index(texture), texture)
		}
		
		@bouton_valider = Button.new(Stock::OK)
		@bouton_supprimer_data = Button.new("Supprimer les données")
		vbox_principale.pack_start(@bouton_supprimer_data, true, true)
		vbox_principale.pack_start(@bouton_valider, true, true)
		
		# WINDOW
		self.add(vbox_principale)
		self.set_window_position(:center)
		self.show_all
		
		# CONNECTS
		@bouton_valider.signal_connect("clicked") {  
			nouvelleTexture = @listesTextures[@combo_textures.active]
			gui.retexturer(nouvelleTexture)
			
			self.destroy 
		}
		@bouton_supprimer_data.signal_connect("clicked") {
			if self.utilisateurCertainDe("Supprimer toutes les données du jeu") then
				picross.restaurerDonneesInitiales
				self.confirmerSuppression
			end
		}
	
	end #fin initialize
	
	# envoie la liste des textures
	def recupererLesTextures
		# on enregistre notre chemin local absolu
		ici = Dir.pwd
		
		# on se déplace
		Dir.chdir(CONSTANT_FICHIER_GUI_TEXTURE)
		
		# on récupère ce dont on a besoin
		listesTextures = Dir.glob("*")
		
		#on revient ici
		Dir.chdir(ici)
		
		return listesTextures
	end
	
	# Confirme à l'utilisateur que la suppression à été effectuée
	def confirmerSuppression
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
