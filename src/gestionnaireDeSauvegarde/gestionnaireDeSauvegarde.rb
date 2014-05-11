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



  def initialize(init_sans_matrice = false)
    @grillesRacinesModifiees = false
    @grillesJouablesModifiees = false
    if init_sans_matrice then
      @grillesRacines = []
      @grillesJouables= []
    else
      @grillesRacines = nil
      @grillesJouables= nil
    end
  end




  ##
  # Ajoute une grille racine à la liste.
  def ajouterGrilleRacine(grille)
    raise "Grilles racines non chargées" if @grillesRacines == nil
    @grillesRacinesModifiees = true
    @grillesRacines += [grille]
    return nil
  end
  



  ##
  # Charge les grilles racines en mémoire.
  def chargerGrillesRacines()
    @grillesRacinesModifiees = false
    begin
      File.open(CONSTANT_FICHIER_DATA_RACINE, "r") do |f|
        @grillesRacines = Marshal.load(f)
      end
    rescue Errno::ENOENT
      puts "ERREUR: GestionnaireDeSauvegarde: chargerGrillesRacines(): le fichier #{CONSTANT_FICHIER_DATA_JOUABLE} n'est pas accessible. "
      puts "Aucun modèle de grille de sera chargé.\n"
      @grillesRacines = []
    end
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
    raise "Grilles racines non chargées" if @grillesRacines == nil
    @grillesRacines.each do |grl|
      if grl.taille == taille then 
        grilleRacineTemp.push(grl)
      end
    end
    return grilleRacineTemp
  end




##########################################################




  ##
  # Ajoute une grille jouable à la liste.
  def ajouterGrilleJouable(grille)
    raise "Grilles jouables non chargées" if @grillesJouables == nil
    @grillesJouablesModifiees = true
    @grillesJouables += [grille]
    return nil
  end
  


  ##
  # Charge les grilles jouables en mémoire.
  def chargerGrillesJouables()
    @grillesJouablesModifiees = false
    begin
      File.open(CONSTANT_FICHIER_DATA_JOUABLE, "r") do |f|
        @grillesJouables = Marshal.load(f)
      end
    rescue Errno::ENOENT
      puts "ERREUR: GestionnaireDeSauvegarde: chargerGrillesJouables(): le fichier #{CONSTANT_FICHIER_DATA_JOUABLE} n'est pas accessible. "
      puts "Aucune sauvegarde utilisateur de sera chargée.\n"
      @grillesJouables = []
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
    raise "Grilles jouables non chargées" if @grillesJouables == nil
    @grillesJouables.each do |grl|
      if grl.taille == taille then 
        grillesJouablesTemp += grl
      end
    end
    return grillesJouablesTemp
  end
  



  ##
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
