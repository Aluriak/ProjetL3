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



#################################
# FENETRE FIN JEU		#
#################################
# mainteneur : BOURNEUF
class FenetreFinJeu < Gtk::Window

  ##
  # Attend une instance de picross, le temps de réalisation en seconde et le nombre d'appels à l'aide
  def initialize(picross, temps, nb_appel_aide)
    # WINDOW
    super("")
    widgets = Gtk::VBox.new

    # BOUTON OK
    bouton_ok = Gtk::Button.new("Ok !")

    # MISE EN PLACE DES WIDGETS CONDITIONNELS
    if picross.grille.terminee? then
      self.title = "Grille " + picross.grille.nom + " terminée !"
      score = Score.creer(picross.grille.taille, temps, nb_appel_aide)
      # ENTRY
      # ComboBox des profils: création et insertion de chacun des profils existants
      combo_profils = ComboBoxEntry.new(true) # text only
      picross.profils.each { |nom| combo_profils.append_text(nom) }
      combo_profils.signal_connect("changed") {
        bouton_ok.sensitive = ("" != combo_profils.active_text)
      }
      bouton_ok.sensitive = false
      # BOXING
      widgets.pack_start(Gtk::Label.new("Votre score est de " + score.to_s), true, true)
      widgets.pack_start(combo_profils, true, true)
    else
      titre = "Proposition invalide..."
      widgets.pack_start(Gtk::Label.new("Il y a forcément une solution !"), true, true)
      combo_profils = nil
    end
    
    # WINDOW
    self.add(widgets)
    widgets.pack_start(bouton_ok, true, true)

    # CONNECTS
    self.signal_connect("destroy") { self.destroy }
    bouton_ok.signal_connect("clicked") { 
      if picross.grille.terminee? then
        profil_existant = @picross.profils.include?(nom_profil)
        # vérification de création de profil
        if (not profil and ConfirmerNouveauProfil.show(nom_profil)) or profil_existant then
          picross.scores.ajouterScoreALaGrille(picross.grille.nom, score, combo_profils.active_text)
        end
      end
      self.destroy
    }

  end





end





