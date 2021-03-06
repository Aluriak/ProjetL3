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
  # Renvois toutes les grilles jouables de taille reçue.
  def grillesJouablesDeTaille(taille)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    listGrlRacine = @gestionnaireDeSauvegarde.grillesJouablesDeTaille(taille)
    return listGrlRacine
  end




  ##
  # Renvois toutes les grilles racines de taille reçue.
  def grillesRacinesDeTaille(taille)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    listGrlRacine = @gestionnaireDeSauvegarde.grillesRacinesDeTaille(taille)
    return listGrlRacine
  end





  ##
  # Définit une nouvelle @grille jouable de la taille demandée pour self.
  def nouvelleGrilleJouableDeTaille(taille)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
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
  # Le nombre d'appel à l'aide et le le temps écoulé sont des valeurs assignée plus tard à la grille.
  # force_sauvegarde indique si la sauvegarde doit écraser une éventuelle 
  # sauvegarde du même nom.
  def sauverGrilleJouable(nom_de_sauvegarde, temps_ecoule, nb_appel_aide, 
                          force_sauvegarde = false)
    # on modifie le nom de sauvegarde et le temps écoulé de la grille
    @grille.nom_de_sauvegarde = nom_de_sauvegarde
    @grille.temps_ecoule = temps_ecoule
    @grille.nbAppelAide = nb_appel_aide
    # et on sauvegarde
    if @gestionnaireDeSauvegarde.ajouterGrilleJouable(
                        @grille, force_sauvegarde) then 
      @gestionnaireDeSauvegarde.sauvegarderGrillesJouables
      return true
    else 
      return false
    end
  end




  ##
  # Charge et utilise la grille jouable enregistrée dont le nom de sauvegarde
  # et la taille sont en paramètre. 
  # N'effectue aucun traitement si aucune grille n'est trouvée.
  def chargerGrilleJouableNommee(nom_de_sauvegarde, taille)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    listGrlJouable = @gestionnaireDeSauvegarde.grillesJouablesDeTaille(taille)
    listGrlJouable.each { |grille|
      if grille.nom_de_sauvegarde == nom_de_sauvegarde then 
        @grille = grille 
        @gestionnaireDeSauvegarde.sauvegarderGrillesJouables
        return true
      end
    }
    return false
  end


  ##
  # Supprime la grille jouable de nom et taille donnée.
  # N'effectue aucun traitement si aucune grille n'est trouvée.
  def supprimerGrilleJouableNommee(nom_de_sauvegarde, taille)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    @gestionnaireDeSauvegarde.supprimerGrilleJouable(nom_de_sauvegarde, taille)
    @gestionnaireDeSauvegarde.sauvegarderGrillesJouables
    return nil
  end





  ##
  # Ajoute le score demandé au scores
  def ajouterScoreALaGrille(grille_nom, score, profil_nom)
    @config.ajouterScoreALaGrille(grille_nom, score, profil_nom)
  end





  ##
  # Retourne les meilleurs scores pour la grille dont le nom est en argument
  def scoresDeGrille(grille_nom)
    return @config.scores.scoresDeGrille(grille_nom)
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




  ## 
  # Renvois la liste des nom de profils connus.
  def profils() 
    return @config.profils()
  end



  ##
  # Ajoute le nom de profil donné à la liste des profils connus
  def ajouterProfil(nom_profil)
    @config.ajouterProfil(nom_profil)
    @config.sauvegarder
    return nil
  end



  ##
  # Remet le jeu avec ses valeurs par défaut.
  def restaurerDonneesInitiales()
    load "src/addDefaultContent.rb"
    # Chargement de la Configuration
    @config = Configuration.charger
    # Chargement d'une grille
    @gestionnaireDeSauvegarde = GestionnaireDeSauvegarde.new
    @gestionnaireDeSauvegarde.chargerGrillesRacines
    @gestionnaireDeSauvegarde.chargerGrillesJouables
  end



  ## 
  # Sauvegarde le nom de texture donné, via la configuration
  def sauverNomTexture(nom)
    @config.nomTexture = nom
  end



  ##
  # Accesseur sur le nom de texture de la configuration.
  def nomTexture()
    return @config.nomTexture
  end




end # end class






