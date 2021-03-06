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
    if not @grillesRacines.include?(grille) then
      @grillesRacinesModifiees = true
      @grillesRacines.push(grille)
      Logs.add("Grille racine %s ajoutée à la liste des grilles racines." % [grille.nom])
    end
    return nil
  end
  



  ##
  # Charge les grilles racines en mémoire.
  def chargerGrillesRacines()
    @grillesRacinesModifiees = false
    begin
      File.open(CONSTANT_FICHIER_DATA_RACINE, "r") do |f|
        @grillesRacines = Marshal.load(f)
        Logs.add("%i grilles racines chargées depuis le fichier %s." % [@grillesRacines.size, CONSTANT_FICHIER_DATA_RACINE])
      end
    rescue Errno::ENOENT
      puts "ERREUR: GestionnaireDeSauvegarde: chargerGrillesRacines(): le fichier #{CONSTANT_FICHIER_DATA_RACINE} n'est pas accessible. "
      puts "Aucun modèle de grille de sera chargé.\n"
      @grillesRacines = []
    end
  end




  ##
  # Sauvegarde les grilles racines si une modification à été réalisée.
  # Cela écrase la sauvegarde précédente.
  def sauvegarderGrillesRacines()
    @grillesRacinesModifiees = false
    File.open(CONSTANT_FICHIER_DATA_RACINE, 'w') do |f|
     f.puts Marshal.dump(@grillesRacines)
      Logs.add("%i grilles racines sauvegardées dans le fichier %s." % [@grillesRacines.size, CONSTANT_FICHIER_DATA_RACINE])
    end
    return nil
  end




  ##
  # Retourne une liste contenant les grilles racines de taille reçue.
  def grillesRacinesDeTaille(taille)
    raise "Grilles racines non chargées" if @grillesRacines == nil
    return @grillesRacines.select { |g| g.taille == taille }
  end




##########################################################




  ##
  # Ajoute une grille jouable à la liste. Si force_sauvegarde est vrai, 
  # la grille ayant le même nom de sauvegarde sera remplacée.
  # Retourne true si la grille a été ajoutée, false si la grille,
  # existant déjà, n'a pas été ajoutée.
  def ajouterGrilleJouable(grille, force_sauvegarde = false)
    raise "Grilles jouables non chargées" if @grillesJouables == nil
    # trouver la grille de même nom de sauvegarde
    @grillesJouables.each do |g|
      if g.nom_de_sauvegarde == grille.nom_de_sauvegarde then
        if force_sauvegarde then
          g = grille 
          grille = nil
          @grillesJouablesModifiees = true
          Logs.add("Grille jouable %s ajoutée à la liste des grilles jouables." % [grille.nom_de_sauvegarde])
          return true
        else
          return false
        end
      end
    end

    # si aucune sauvegarde n'a été trouvée
    @grillesJouables.push(grille)
    @grillesJouablesModifiees = true
    Logs.add("Grille jouable %s ajoutée à la liste des grilles jouables." % [grille.nom_de_sauvegarde])
    return true
  end
  


  ##
  # Charge les grilles jouables en mémoire.
  def chargerGrillesJouables()
    @grillesJouablesModifiees = false
    begin
      File.open(CONSTANT_FICHIER_DATA_JOUABLE, "r") do |f|
        @grillesJouables = Marshal.load(f)
        Logs.add("%i grilles jouables chargées depuis le fichier %s." % [@grillesJouables.size, CONSTANT_FICHIER_DATA_JOUABLE])
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
    @grillesJouablesModifiees = false
    File.open(CONSTANT_FICHIER_DATA_JOUABLE, 'w') do |f|
      f.puts Marshal.dump(@grillesJouables)
      Logs.add("%i grilles jouables sauvegardées dans le fichier %s." % [@grillesJouables.size, CONSTANT_FICHIER_DATA_JOUABLE])
    end
  end




  ##
  # Retourne une liste contenant les grilles jouables de taille reçue.
  def grillesJouablesDeTaille(taille)
    raise "Grilles jouables non chargées" if @grillesJouables == nil
    return @grillesJouables.select { |g| g.taille == taille }
  end
  


  # Supprime la grille jouable de nom de sauvegarde et de taille donnée
  def supprimerGrilleJouable(nom_de_sauvegarde, taille)
    @grillesJouables.delete_if {|g| g.nom_de_sauvegarde == nom_de_sauvegarde }
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
