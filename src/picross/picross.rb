# -*- encoding: utf-8 -*-
# PICROSS.RB
# définition de la classe Picross
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "commun/commun.rb"
load "configuration/configuration.rb"
load "grille/jouable.rb"
load "grille/racine.rb"


#################################
# CLASSNAME			#
#################################
# mainteneur : BOURNEUF
class Picross
  @config
  @grille

  # Référence vers une instance de classe Configuration
  attr_reader :config
  # Référence vers une instance de classe GrilleJouable
  attr_reader :grille


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
    end
    # Chargement d'une grille
    #TODO
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


  # Remise à zéro de la configuration
  # METHODE DE DEBUG
  def remiseAZero
    @config.prochainIdGrille = 1
    @config.derniereTailleGrille = 5
    self.sauverConfiguration
  end
end






