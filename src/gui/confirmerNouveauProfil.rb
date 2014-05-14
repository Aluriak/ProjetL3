# -*- encoding: utf-8 -*-
# CONFIRMERNOUVEAUPROFIL.RB
# définition de la classe permettant de demander à l'utilisateur si il confirme la création du profil
# BOURNEUF
#

			
#################################
# IMPORTS			#
#################################
require "gtk2"
require "glib2"



#################################
# CONFIRMERNOUVEAUPROFIL        #
#################################
# mainteneur : BOURNEUF
class ConfirmerNouveauProfil

  # impossible de créer une instance de classe
  private_class_method :new


  ## 
  # prend une instance de classe Picross en paramètre.
  # Retourne vrai si l'utilisateur souhaite créer le profil
  def ConfirmerNouveauProfil.show(nom_profil)
    operation_choisie = Dialog::RESPONSE_OK

    # vérification de création de profil
    if not picross.profils.include?(nom_profil) then
      dialog = Dialog.new(
        "Création de profil", 
        self,
        Dialog::DESTROY_WITH_PARENT | Dialog::MODAL,
        [Stock::OK, Dialog::RESPONSE_OK], 
        [Stock::CANCEL, Dialog::RESPONSE_CANCEL]
      )
      dialog.vbox.add(Label.new("Créer le profil " + nom_profil + " ?"))
      dialog.signal_connect("response") { |fenetre, id_rep| operation_choisie = id_rep }
      dialog.show_all
      dialog.run
      dialog.destroy
    end

    return operation_choisie == Dialog::RESPONSE_OK 
end

