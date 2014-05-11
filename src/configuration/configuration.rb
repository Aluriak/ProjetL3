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

  # taille de la dernière grille jouée
  attr_reader :derniereTailleGrille
  # scores liés au picross
  attr_reader :scores



  ##
  # Constructeur
  def initialize(taille, scores)
    @derniereTailleGrille, @scores = taille, scores
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
  # Marshal API : méthode de dump
  def marshal_dump
    [@derniereTailleGrille, @scores]
  end
  
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @derniereTailleGrille, @scores = ary
  end

end






