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
# 	de GrillesRacines et GrillesJouables.
# Il propose une API complète de lecture et écriture de ces sauvegardes,
# 	et doit être le seul à inférer avec les fichiers de données.
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

  # Ajoute une grille racine à la liste.
  def ajouterGrilleRacine(grille)
    if @grillesRacines == nil then
      raise "GestionnaireDeSauvegarde.ajouterGrilleRacine(1) "+
    	    "nécessite que les grilles racines soient chargées. \n"
    end
    @grillesRacinesModifiees = true
    @grillesRacines += [grille] 
    return nil
  end

  # Retourne une liste contenant les grilles racines de taille reçue.
  # Retourne nil si aucune grille valide trouvée.
  def grillesRacinesDeTaille(taille)
    print("DEBUG: GestionnaireDeSauvegarde.grillesRacinesDeTaille(1) "+
    	  "n'effectue aucun traitement dans cette version\n")
    return nil
  end
  
  # Charge les grilles racines en mémoire.
  # Cette opération est nécessaire pour traiter les grilles racines
  def chargerGrillesRacines()
    File.open(CONSTANT_FICHIER_DATA_RACINE, 'r') do |f|
      @grillesRacines = Marshal.load(f.gets)
    end
  end

  # Sauvegarde les grilles racines si une modification à été réalisée.
  # Cela écrase la sauvegarde précédente.
  def sauvegarderGrillesRacines()
    if @grillesRacinesModifiees == true then
      @grillesRacinesModifiees = false
      File.open(CONSTANT_FICHIER_DATA_RACINE, 'w') do |f|
      	f.puts Marshal.dump(@grillesRacines)
      end
    end
  end


  def to_s
    str  = @grillesRacines.to_s
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
s = GestionnaireDeSauvegarde.new
s.chargerGrillesRacines
print "s = " + s.to_s
s.ajouterGrilleRacine 43
s.sauvegarderGrillesRacines
#/DEBUG


