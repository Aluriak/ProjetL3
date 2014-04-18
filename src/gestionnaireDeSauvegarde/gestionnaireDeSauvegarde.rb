# -*- encoding: utf-8 -*-
# GESTIONNAIRE DE SAUVEGARDE
# définition du gestionnaire de sauvegarde
# BOURNEUF
#
 
#################################
# IMPORTS			#
#################################
load 'src/commun/commun.rb'




#################################
# GESTIONNAIRE DE SAUVEGARDE	#
#################################
# mainteneur : BOURNEUF
# Le Gestionnaire de Sauvegarde gère le chargement de sauvegarde
# de GrillesRacines et GrillesJouables.
# Il propose une API complète de lecture et écriture de ces sauvegardes,
# et doit être le seul à inférer avec les fichiers de données.
class GestionnaireDeSauvegarde
  #liste des sauvegardes de grilles racines
  @grillesRacines = nil
  #liste des sauvegardes de grilles jouables des utilisateurs
  @grillesJouables= nil
  #booléens indiquant si une modification de grille racine/jouable à été effectuée
  @grillesRacinesModifiees = false
  @grillesJouablesModifiees = false



  def initialize()
    @grillesRacines = nil
    @grillesJouables= nil
    @grillesRacinesModifiees = false
    @grillesJouablesModifiees = false
  end

  ##
  # Ajoute une grille racine à la liste.
  def ajouterGrilleRacine(grille)
    if @grillesRacines == nil then
      self.chargerGrillesRacines
    end
    @grillesRacinesModifiees = true
    @grillesRacines += [grille]
    return nil
  end
  
  ##
  # Charge les grilles racines en mémoire.
  # Cette opération est opérée par les autres 
  # méthodes si nécessaire avant d'effectuer leur traitement.
  def chargerGrillesRacines()
    if @grillesRacines == nil then
      @grillesRacines = Marshal.load(File.read(CONSTANT_FICHIER_DATA_RACINE))
    end
    if @grillesRacines.size == 0 then
      self.ajouterGrilleRacine(GrilleRacine.deTaille(5, cnf.idGrilleSuivant))
    end
    return nil
  end

  ##
  # Sauvegarde les grilles racines si une modification à été réalisée.
  # Cela écrase la sauvegarde précédente.
  def sauvegarderGrillesRacines()
    if @grillesRacinesModifiees == true then
      @grillesRacinesModifiees = false
      File.open(CONSTANT_FICHIER_DATA_RACINE, 'w') do |f|
       f.puts Marshal.dump(@grillesRacines)
      end
    end
    return nil
  end

  ##
  # Retourne une liste contenant les grilles racines de taille reçue.
  def grillesRacinesDeTaille(taille)
    grilleRacineTemp = []
    if @grillesRacines == nil then
      self.chargerGrillesRacines
    else
      @grillesRacines.each do |grl|
      	if grl.taille == taille then 
      	  grilleRacineTemp += grl
	end
      end
    end
    return grilleRacineTemp
  end


##########################################################

  ##
  # Ajoute une grille jouable à la liste.
  def ajouterGrilleJouable(grille)
    if @grillesJouables == nil then
      self.chargerGrillesJouables
    end
    @grillesJouablesModifiees = true
    @grillesJouables += [grille]
    return nil
  end
  
  ##
  # Charge les grilles jouables en mémoire.
  # Cette opération est opérée par les autres 
  # méthodes si nécessaire avant d'effectuer leur traitement.
  def chargerGrillesJouables()
    if @grillesJouables == nil then
      @grillesJouables = Marshal.load(File.read(CONSTANT_FICHIER_DATA_JOUABLE))
    end
  end

  ##
  # Sauvegarde les grilles jouables si une modification à été réalisée.
  # Cela écrase la sauvegarde précédente.
  def sauvegarderGrillesJouables()
    if @grillesJouablesModifiees == true then
      @grillesJouablesModifiees = false
      File.open(CONSTANT_FICHIER_DATA_JOUABLE, 'w') do |f|
       f.puts Marshal.dump(@grillesJouables)
      end
    end
  end

  ##
  # Retourne une liste contenant les grilles jouables de taille reçue.
  def grillesJouablesDeTaille(taille)
    grillesJouablesTemp = []
    if @grillesJouables == nil then
      self.chargerGrillesJouables
    else
      @grillesJouables.each do |grl|
      	if grl.taille == taille then 
      	  grillesJouablesTemp += grl
	end
      end
    end
    return grillesJouablesTemp
  end
  



  # Affichage de grillesRacines et grillesJouables
  def to_s
    str = @grillesRacines.to_s
    str += @grillesJouables.to_s
    str += "\n"
    return str
  end


end



#################################
# FUNCTIONS			#
#################################

#File.open(CONSTANT_FICHIER_DATA_RACINE, 'w') do |f|
  #f.puts Marshal.dump([])
#end


# DEBUG
#s = GestionnaireDeSauvegarde.new
#s.chargerGrillesRacines
#print "s = " + s.to_s
#s.ajouterGrilleRacine 43
#s.sauvegarderGrillesRacines
#/DEBUG
