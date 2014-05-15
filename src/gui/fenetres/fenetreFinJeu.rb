# -*- encoding: utf-8 -*-
# FENETREFINJEU.RB
# Définition de la fenêtre Affichant le résultat de la vérification du picross
# BOURNEUF
#

			
#################################
# IMPORTS			#
#################################
require "gtk2"
require "glib2"
load "src/gui/confirmerNouveauProfil.rb"
include Gtk


#################################
# FENETRE FIN JEU		#
#################################
# mainteneur : BOURNEUF
class FenetreFinJeu < Window

  ##
  # Attend une instance de picross, le temps de réalisation en seconde et le nombre d'appels à l'aide
  def initialize(picross, temps, nb_appel_aide)
    # WINDOW
    super()
    self.set_modal(true)
    widgets = VBox.new


    # BOUTON OK
    bouton_ok = Button.new("Ok !")
    bouton_ok.sensitive = false


    # MISE EN PLACE DES WIDGETS CONDITIONNELS
    self.title = "Grille " + picross.grille.nom + " terminée !"
    score = Score.creer(picross.grille.taille, temps, nb_appel_aide)
    
    
    # ENTRY
    # ComboBox des profils: création et insertion de chacun des profils existants
    combo_profils = ComboBoxEntry.new(true) # text only
    picross.profils.each { |nom| combo_profils.append_text(nom) }
    combo_profils.signal_connect("changed") {
      bouton_ok.sensitive = (!combo_profils.active_text.empty?)
    }
    
    
    # BOXING
    widgets.pack_start(Label.new("Votre score est de " + score.to_s), true, true)
    widgets.pack_start(combo_profils, true, true)
    widgets.pack_start(bouton_ok, true, true)
    

    # WINDOW
    self.add(widgets)


    # CONNECTS
    self.signal_connect("destroy") { self.destroy }

    bouton_ok.signal_connect("clicked") { 
      # On ajoute le score à la grille
      profil_nom = combo_profils.active_text
      profil_existant = picross.profils.include?(profil_nom)
      # si le profil existe ou confirmation de création de profil
      if profil_existant or ConfirmerNouveauProfil.show(self, profil_nom) then
        picross.ajouterProfil(profil_nom)  # gère le cas où le profil existe déjà
        picross.scores.ajouterScoreALaGrille(picross.grille.nom, score, profil_nom)
      end
      # fin de la fenêtre
      self.destroy
    }

  end





end





