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
# PICROSS			#
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
    self.gestionnaireDeSauvegarde = GestionnaireDeSauvegarde.new
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
  def creerGrilleRacine(tableEtat) 
    # substituer les états DRAPEAU par l'état BLANC
    tableEtat.each do |ligne| 
      ligne.each do |c| 
      	if c == Etat.Drapeau then c = Etat.Blanc end
      end
    end

    # IMPLÉMENTER LISTE DES COLONNES
    matriceFacteursColonne = Array.new
    # pour chacune des lignes
    tableEtat.size.times do |col|
      # compteur de noir
      nbNoirConsecutif = 0 
      # ajouter une liste d'entier à la matrice de facteurs
      matriceFacteurColonne.push(Array.new)
      # pour chacune des colonnes
      tableEtat.size.times do |row|
      	# obtenir l'état de la case
      	c = tableEtat[row][col]
	# si c'est du blanc
      	if c == Etat.Blanc then 
	  # et qu'il y a eu un noir avant
	  if nbNoirConsecutif > 0 then			
	    # insérer un entier dans la liste de la ligne actuelle
	    matriceFacteursColonne.last.push(nbNoirConsecutif)	
      	    nbNoirConsecutif = 0 
	  end						
	else
	  # si c'est pas blanc, c'est noir
      	  nbNoirConsecutif += 1				
	end
      end
      # si la dernière case était un noir, cela n'a pas été ajouté à la liste
      # on intègre donc le nombre de dernières cases noires
      if nbNoirConsecutif > 0 then			
	# insérer un entier dans la liste de la ligne actuelle
	matriceFacteursColonne.last.push(nbNoirConsecutif)	
      	nbNoirConsecutif = 0 
      end						
    end

    # IMPLÉMENTER LISTE DES LIGNES
    matriceFacteursLigne = Array.new
    # pour chacune des lignes
    tableEtat.size.times do |row|
      # compteur de noir
      nbNoirConsecutif = 0 
      # ajouter une liste d'entier à la matrice de facteurs
      matriceFacteurColonne.push(Array.new)
      # pour chacune des colonnes
      tableEtat.size.times do |col|
      	# obtenir l'état de la case
      	c = tableEtat[row][col]
	# si c'est du blanc
      	if c == Etat.Blanc then 
	  # et qu'il y a eu un noir avant
	  if nbNoirConsecutif > 0 then			
	    # insérer un entier dans la liste de la ligne actuelle
	    matriceFacteursLigne.last.push(nbNoirConsecutif)	
      	    nbNoirConsecutif = 0 
	  end						
	else
	  # si c'est pas blanc, c'est noir
      	  nbNoirConsecutif += 1				
	end
      end
      # si la dernière case était un noir, cela n'a pas été ajouté à la liste
      # on intègre donc le nombre de dernières cases noires
      if nbNoirConsecutif > 0 then			
	# insérer un entier dans la liste de la ligne actuelle
	matriceFacteursLigne.last.push(nbNoirConsecutif)	
      	nbNoirConsecutif = 0 
      end						
    end

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

  # Remise à zéro de la configuration
  # METHODE DE DEBUG
  def remiseAZero
    @config.prochainIdGrille = 1
    @config.derniereTailleGrille = 5
    self.sauverConfiguration
  end
end






