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
load "src/grille/jouable.rb"
load "src/grille/racine.rb"


#################################
# PICROSS			#
#################################
# mainteneur : BOURNEUF
class Picross
  @config
  @grille
  @registreTemporaire
  @gestionnaireDeSauvegarde

  # Référence vers une instance de classe Configuration
  #attr_reader :config
  # Référence vers une instance de classe GrilleJouable
  #attr_reader :grille
  # Référence vers une instance de classe GestionnaireDeSauvegarde
  #attr_reader :gestionnaireDeSauvegarde


  def initialize
    # Chargement de la Configuration
    begin
      File.open(CONSTANT_FICHIER_DATA_CONFIG, "r") do |f|
      	@config = Marshal.load(f)
      end
    rescue Errno::ENOENT
      # En cas d'absence de fichier de configuration,
      #   création d'une configuration par défaut
      @config = Configuration.new(1,5)
      self.sauverConfiguration
    end
    # Chargement d'une grille
    @gestionnaireDeSauvegarde = GestionnaireDeSauvegarde.new
  end


  # Donne un id attribuable à une grille
  # la configuration est modifiée et sauvée par cette méthode
  def idGrilleSuivant
    id = @config.idGrilleSuivant
    self.sauverConfiguration
    return id
  end


  # Sauve la configuration actuelle dans le fichier de configuration,
  # écrasant de fait les anciennes valeurs
  def sauverConfiguration
    File.open(CONSTANT_FICHIER_DATA_CONFIG, "w") do |f|
      f.puts Marshal.dump(@config)
    end
    return self
  end


  # Création d'une grille racine à partir de la table d'état passée en argument.
  # Aucun effet si la table n'est pas de la taille réglementaire.
  def creerGrilleRacine(matriceEtat) 
    matriceFacteursColonne, matriceFacteursLigne = 
      Grille.matriceEtats2facteurs(matriceEtat)

    # CRÉER LA GRILLE RACINE
    grilleRacine = GrilleRacine.creerDepuis(
      Grille.new(matriceEtat.size, 
      	 matriceFacteursLigne,
	 matriceFacteursColonne),
      self.idGrilleSuivant
    )

    # ENREGISTRER LA GRILLE RACINE
    self.gestionnaireDeSauvegarde.ajouterGrilleRacine(grilleRacine)
    
  end

  ##
  # Renvois la dernière taille de grille utilisée.
  def derniereTailleDeGrille()
    return @config.derniereTailleGrille
  end


  ##
  # Définit une nouvelle @grille jouable de la taille demandée pour self.
  # :arg: taille de la grille
  def nouvelleGrilleDeTaille(taille)
    listGrlRacine = self.gestionnaireDeSauvegarde.grillesRacinesDeTaille(taille)
    grille = listGrlRacine.first#TODO prendre une grille au hasard dans la liste.
    # TODO: Si elle est vide, en créer une à la volée.
    # Créer la grille jouable depuis la grille racine trouvée
    @grille = GrilleJouable.creerDepuis(grille)
  end


  ##
  # Retourne l'état de la grille aux coordonnées demandées
  def etatGrille(i, j)
    raise i >= 0 and i < @grille.taille, "coordonnée i non valide."
    raise j >= 0 and j < @grille.taille, "coordonnée j non valide."
    return @grille.matriceDeJeu[i][j]
  end


  ##
  # Bascule l'état de la grille aux coordonnées données à l'état donné,
  # ou au suivant si l'état n'est pas communiqué
  def basculerEtat(i, j, etat = nil)
    @grille.basculer(i, j, etat)
  end


  ##
  # Sauvegarde la grille actuellement jouée dans une nouvelle sauvegarde.
  # Le nom de sauvegarde permet d'identifier la sauvegarde.
  # TODO:EN COURS D'IMPLEMENTATION
  def sauverGrilleCommeGrilleJouable(nom_sauvegarde)
    #TODO
  end


  ##
  # Sauvegarde la grille actuellement jouée comme grille racine.
  # TODO:EN COURS D'IMPLEMENTATION
  def sauverGrilleCommeGrilleRacine()
    #TODO
  end


  ##
  # Sauvegarde la grille actuelle dans un registre temporaire non persistant.
  # Ecrase une éventuelle ancienne sauvegarde, ne modifie pas la grille.
  def sauverGrilleEnRegistreTmp()
    @registreTemporaire = @grille
  end


  ##
  # Charge dans la grille le contenu du registre temporaire
  # Ecrase le contenu précédent de la grille, ne modifie pas le registre.
  def chargerRegistreTemporaire()
    @grille = @registreTemporaire
  end


  ##
  # Predicat: Vrai si la @grille correspond au facteurs.
  def grilleTerminee?()
    return @grille.terminee?    
  end


  ##
  # Predicat: Vrai si t désigne une taille de grille valide, faux sinon.
  def tailleGrilleValide?(t)
    return @@tailles.include?(t)
  end



  # Remise à zéro de la configuration
  # METHODE DE DEBUG
  def remiseAZero
    @config.prochainIdGrille = 1
    @config.derniereTailleGrille = 5
    self.sauverConfiguration
  end
end






