# -*- encoding: utf-8 -*-

require "gtk2"
require "glib2"
include Gtk

#load "src/gui/gui.rb"


# FenetreNouveauTaille est la fenetre qui s'ouvre lorsqu'on appuie sur "Nouveau".
# Cela ouvre une fenetre où on peut choisir une nouvelle partie, selon sa taille, 
# de 5x5 jusqu'à 25x25.
class FenetreNouveauTaille < Window
  @combo_tailles
  @combo_grille
  @boutonValider
  @boutonAnnuler
  @gui

	def initialize(gui)
          @gui = gui
          super("Nouvelle Grille")
          self.set_default_size(300,30)
          set_resizable(false)
          set_modal(false)
          box_window = HBox.new
          self.add(box_window)
          self.set_window_position(:center)

          # BOUTON ANNULER
          box_window.pack_start(@boutonAnnuler = Button.new(Stock::CLOSE))
          @boutonAnnuler.signal_connect("clicked") { self.destroy }

          # COMBO POUR LA TAILLE
          box_window.pack_start(Label.new("  Taille : "))
          box_window.pack_start(@combo_tailles = ComboBox.new(true))
          5.downto(1) { |i| @combo_tailles.insert_text(0, "%i" % [i*5]) }
          @combo_tailles.signal_connect("changed") {
            taille = @combo_tailles.active_text.to_i
            if Grille.tailles.include?(taille) then
              self.actualiserListeGrille
            end
          }


          # COMBO POUR LES GRILLES
          box_window.pack_start(Label.new("  Grille : "))
          box_window.pack_start(@combo_grille = ComboBox.new(true))
          puts @combo_grille


          # BOUTON VALIDER
          box_window.pack_start(@boutonValider = Button.new(Stock::OK))
          @boutonValider.signal_connect("clicked") {
            taille = @combo_tailles.active_text.to_i
            nom_grille = @combo_grille.active_text
            if nom_grille == "Une au hasard" then
              self.lancerNouvellePartie(taille) # partie au hasard
            else
              self.lancerNouvellePartie(taille, nom_grille)
            end
          }


          # SHOW !
          self.show_all
        end




        ##
        # Vide puis remplis la @combo_grille selon les grilles disponibles
        # via la @gui et la taille choisie par @combo_tailles.
        def actualiserListeGrille()
          taille = @combo_tailles.active_text.to_i
          @combo_grille.set_active(0)
          (puts "plop" ; @combo_grille.remove_text(0)) while @combo_grille.active_text != nil
          @gui.picross.grillesRacinesDeTaille(taille).each { |g| @combo_grille.insert_text(0, g.nom) }
          # Ajout du choix "grille aléatoire"
          @combo_grille.insert_text(0, "Une au hasard")
        end 




        ## 
        # Lance une nouvelle partie, avec une grille de la taille demandée, prise au hasard parmis les grilles racines.
        # Néanmoins, si le nom est renseigné, et juste, c'est la grille racine ayant ce nom qui sera chargée.
        def lancerNouvellePartie(taille, nom = nil)
          Logs.add("Lancement de la nouvelle grille de taille " + taille.to_s + " #{nom != nil ? " générée depuis #{nom}" : ""}")
          self.destroy
          @gui.destroy
          Gui.lancer(taille, nom)
        end
end





