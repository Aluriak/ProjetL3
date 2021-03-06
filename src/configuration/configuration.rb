# -*- encoding: utf-8 -*-
# CONFIGURATION.RB
# définition de la classe Configuration
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "src/commun/commun.rb"
load "src/scores/scores.rb"
 

#################################
# CONFIGURATION CLASS		#
#################################
# mainteneur : BOURNEUF
# Groupement de valeurs nécessaires à l'autoconfiguration du prgm de Picross.
# Classe instanciée une seule fois, chargée au démarrage et sauvegardée 
# lors des modifications des attributs.
class Configuration
  @derniereTailleGrille
  @scores
  @profils
  @nomTexture

  # taille de la dernière grille jouée
  attr_reader :derniereTailleGrille
  # scores liés au picross
  attr_reader :scores
  # liste de nom de profils
  attr_reader :profils
  # nom de texture
  attr_accessor :nomTexture




  ##
  # Constructeur
  def initialize(taille, scores, profils, nomTexture)
    @derniereTailleGrille, @scores, @profils, @nomTexture = taille, scores, profils, nomTexture
  end




  ## 
  # Sauvegarde la configuration dans le fichier de config
  def sauvegarder()
    begin
      File.open(CONSTANT_FICHIER_DATA_CONFIG, "w") do |f|
      	f.puts Marshal.dump(self)
      end
    rescue Errno::ENOENT
      puts "ERREUR: Configuration: sauvegarder(): le fichier #{CONSTANT_FICHIER_DATA_CONFIG} n'est pas accessible."
    end
  end


  ## 
  # Charge la configuration depuis le fichier de config
  def Configuration.charger()
    config = nil
    begin
      File.open(CONSTANT_FICHIER_DATA_CONFIG, "r") do |f|
      	config = Marshal.load(f)
      end
    rescue Errno::ENOENT
      # En cas d'absence de fichier de configuration,
      #   création d'une configuration par défaut
      config = Configuration.new(1)
      config.sauvegarder
    end
    return config
  end
  



  ##
  # Affecte la nouvelle taille de grille
  # Lève une exception si la taille reçue est invalide
  def derniereTailleGrille=(taille)
    raise "Taille non définie" if not Grille.tailles.include?(taille)
    @derniereTailleGrille = taille
    return self
  end




  ## 
  # Retourne la liste de noms de profils
  def profils()
    return @profils
  end


  ## 
  # Ajoute le profil donné à la liste des profils
  def ajouterProfil(nom_profil)
    if not @profils.include?(nom_profil) then
      @profils.push(nom_profil) 
      Logs.add("Profil %s ajouté." % [nom_profil])
    end

    return nil
  end




  ##
  # Ajoute le score demandé, et met à jour la liste des profils et des scores du profil.
  def ajouterScoreALaGrille(grille_nom, score, profil_nom)
    # ajout du score
    @scores.ajouterScoreALaGrille(grille_nom, score, profil_nom)
    # ajout du profil si nécessaire
    self.ajouterProfil(profil_nom)
    # actualisation du profil
    @scores.ajouterScoreAuProfil(grille_nom, score, profil_nom)
  end



  ##
  # Marshal API : méthode de dump
  def marshal_dump
    [@derniereTailleGrille, @scores, @profils, @nomTexture]
  end
  
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @derniereTailleGrille, @scores, @profils, @nomTexture = ary
  end

end






