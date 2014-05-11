# -*- encoding: utf-8 -*-
# PICROSS.RB
# définition de la classe Picross
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "src/commun/commun.rb"
load "src/configuration/configuration.rb"
load "src/gestionnaireDeSauvegarde/gestionnaireDeSauvegarde.rb"
load "src/grille/racine.rb"
load "src/grille/jouable.rb"


#################################
# PICROSS			#
#################################
# mainteneur : BOURNEUF
class Picross
  @config
  @grille
  @gestionnaireDeSauvegarde

  # Référence vers une instance de classe GrilleJouable
  attr_reader :grille




  def initialize
    # Chargement de la Configuration
    @config = Configuration.charger
    # Chargement d'une grille
    @gestionnaireDeSauvegarde = GestionnaireDeSauvegarde.new
    @gestionnaireDeSauvegarde.chargerGrillesRacines
    @gestionnaireDeSauvegarde.chargerGrillesJouables
    @grille = nil
  end




  # Création d'une grille racine à partir de la table d'état passée en argument.
  # Aucun effet si la table n'est pas de la taille réglementaire.
  # Si aucun nom n'est spécifié, il sera généré aléatoirement
  def creerGrilleRacine(tableEtat, nom=nil) 
    tableColonne, tableLigne = 
      TableNombre.creerDepuis(tableEtat)

    # Créer la grille racine
    grilleRacine = GrilleRacine.deTaille(tableEtat.size, 
	nom,
        tableColonne, 
        tableLigne
    )

    # Enregistrer la grille racine
    @gestionnaireDeSauvegarde.ajouterGrilleRacine(grilleRacine)
    @gestionnaireDeSauvegarde.sauvegarderGrillesRacines
  end




  ##
  # Renvois la dernière taille de grille utilisée.
  def derniereTailleDeGrille()
    return @config.derniereTailleGrille
  end




  ##
  # Définit une nouvelle @grille jouable de la taille demandée pour self.
  def nouvelleGrilleDeTaille(taille)
    listGrlRacine = @gestionnaireDeSauvegarde.grillesRacinesDeTaille(taille)
    if listGrlRacine.size == 0 then
      grille = GrilleJouable.deTaille(taille) # création d'une grille à la volée.
    else 
      grille = listGrlRacine.choice # prendre une grille au hasard dans la liste.
    end
    @grille = GrilleJouable.creerDepuis(grille)
    @config.derniereTailleGrille = taille
    @config.sauvegarder
    return nil
  end




  ##
  # Sauvegarde la grille actuellement jouée dans une nouvelle sauvegarde.
  # Le nom de sauvegarde permet d'identifier la sauvegarde.
  def sauverGrilleJouable(nom_sauvegarde)
    @gestionnaireDeSauvegarde.ajouterGrilleJouable(@grille)
    @gestionnaireDeSauvegarde.sauvegarderGrillesJouables
    return nil
  end




  ## 
  # Renvois une instance de la classe Scores
  def scores()
    return @config.scores
  end




  ## 
  # Effectue la sauvegarde des scores
  def sauvegarderScores()
    return @config.sauvegarder
  end




end # end class






