# -*- encoding: utf-8 -*-
# FENETRESAUVEGARDERAVANTQUITTER.RB
# définition de la classe FenetreSauvegarderAvantQuitter, appellée par la GUI lorsque l'utilisateur veut quitter.
# BOURDIN
#

			
#################################
# IMPORTS			#
#################################

load "src/gui/fenetres/fenetreSauvegarde.rb"
require "gtk2"
require "glib2"
include Gtk








class FenetreSauvegarderAvantQuitter


	 # impossible de créer une instance de classe
  private_class_method :new


  
  def FenetreSauvegarderAvantQuitter.show(picross, timer, parent)
    operation_choisie = Dialog::RESPONSE_OK

    # vérification de création de profil
    dialog = Dialog.new(
      "Sauvegarder la grille courante avant de quitter? ", 
      parent, 
      Dialog::DESTROY_WITH_PARENT | Dialog::MODAL)
    dialog.vbox.pack_start(Label.new("Attention vos modifications sur la grille courante seront perdues\nsi vous ne la sauvegardez pas."))
    dialog.vbox.pack_start(hbox = HBox.new)

    hbox.pack_start(btnQuit = Button.new("Quitter sans sauvegarder"))
    hbox.pack_start(btnAnnuler = Button.new("Annuler"))
    hbox.pack_start(btnSauvegarder = Button.new("Sauvegarder"))
   	
    
    btnQuit.signal_connect("clicked"){
    	parent.destroy

    }

    btnAnnuler.signal_connect("clicked"){
    	dialog.destroy
    }

    btnSauvegarder.signal_connect("clicked"){
    	fenetreSauvegarde = FenetreSauvegarde.new(picross, timer)
    	fenetreSauvegarde.signal_connect("destroy"){parent.destroy}
    }

    dialog.signal_connect("destroy"){dialog.destroy}

    dialog.set_resizable(false)
    dialog.show_all
    dialog.run
   

    
  end




end	





	
