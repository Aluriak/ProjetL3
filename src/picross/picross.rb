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
    @config = Configuration.charger
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
  # Si aucun nom n'est spécifié, il sera généré aléatoirement
  def creerGrilleRacine(matriceEtat, nom=nil) 
    matriceFacteursColonne, matriceFacteursLigne = 
      Grille.matriceEtats2facteurs(matriceEtat)

    # Créer la grille racine
    grilleRacine = GrilleRacine.deTaille(matriceEtat.size, 
	nom,
      	matriceFacteursLigne,
	matriceFacteursColonne
    )

    # Enregistrer la grille racine
    @gestionnaireDeSauvegarde.ajouterGrilleRacine(grilleRacine)
    
  end



  ##
  # Renvois la dernière taille de grille utilisée.
  def derniereTailleDeGrille()
    return @config.derniereTailleGrille
  end



  ##
  # Définit une nouvelle @grille jouable de la taille demandée pour self.
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
    raise "coordonnée i non valide." if i >= 0 and i < @grille.taille
    raise "coordonnée j non valide." if j >= 0 and j < @grille.taille
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
  def sauverGrilleCommeGrilleJouable(nom_sauvegarde = nil)
    @grille.genererNom(nom_sauvegarde)
    @gestionnaireDeSauvegarde.ajouterGrilleJouable(@grille)
    @gestionnaireDeSauvegarde.sauvegarderGrillesJouables
  end


  ##
  # Sauvegarde la grille actuellement jouée comme grille racine.
  def sauverGrilleCommeGrilleRacine()
    grille = GrilleRacine.creerDepuis(@grille)
    @gestionnaireDeSauvegarde.ajouterGrilleRacine(grille)
    @gestionnaireDeSauvegarde.sauvegarderGrillesRacines
    return nil
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

end # end class






