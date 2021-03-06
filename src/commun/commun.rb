# -*- encoding: utf-8 -*-
# COMMUN.RB
# définition de types et fonctions communes au programme
# BOURNEUF,COUSIN
 
#################################



#################################
# CONSTANT			#
#################################
# Fichier hébergeant la configuration du programme
CONSTANT_FICHIER_DATA_CONFIG 	= 'data/config' 	unless defined? CONSTANT_FICHIER_DATA_CONFIG
# Répertoire contenant les grilles racines
CONSTANT_FICHIER_DATA_RACINE 	= 'data/racines'	unless defined?	CONSTANT_FICHIER_DATA_RACINE
# Répertoire contenant les grilles jouables
CONSTANT_FICHIER_DATA_JOUABLE 	= 'data/jouables'	unless defined?	CONSTANT_FICHIER_DATA_JOUABLE
# Répertoire contenant les sauvegardes
CONSTANT_FICHIER_DATA_SAVE 	= 'data/saves'		unless defined?	CONSTANT_FICHIER_DATA_SAVE
#modes d'utilisation des grille;utile pour la gui
CONSTANT_MODE_JOUABLE		= -5 			unless defined?	CONSTANT_MODE_JOUABLE
CONSTANT_MODE_EDTION		= -6 			unless defined?	CONSTANT_MODE_EDTION

# Fichiers texture pour la GUI
CONSTANT_FICHIER_GUI_TEXTURE	= 'data/gui/texture/'	unless defined?	CONSTANT_FICHIER_GUI_TEXTURE
# Fichiers images pour la GUI
CONSTANT_FICHIER_GUI_IMAGE = 'data/gui/' unless defined?	CONSTANT_FICHIER_GUI_IMAGE

# Mode d'interprétation.
CONSTANT_MODE_DEBUG		= true			unless defined?	CONSTANT_MODE_DEBUG

#################################
# GRILE.TAILLE			#
#################################
# mainteneur : BOURNEUF

# Définition de la taille d'une grille de picross
# toutes les tailles possibles sont référencées dans cette classe
class Grille
  @@tailles = [5,10,15,20,25]
  # les tailles possibles de grilles sont listée dans la table de classe
  def Grille.tailles() return @@tailles end
end




#################################
# ARRAY.CHOICE			#
#################################
#mainteneur : BOURNEUF
class Array
  ##
  # Obtention d'un élément au hasard du table.
  def choice
    return self.shuffle.pop
  end
	
	def orientationHorizontale?
		# c"est effectivement l"inverse pour une orientation Verticale
		return self.size > self[0].size 
	end
end



#################################
# ETAT				#
#################################
# mainteneur : BOURNEUF

# Définition de l'état d'une case.
# Oscille obligatoirement entre blanc, noir et drapeau.
class Etat
  @@blanc	= 0
  @@noir 	= 1
  @@drapeau 	= 2

  ##
  # Renvois true si la valeur reçue est un état valide
  def Etat.include?(ceci)
    return [@@blanc, @@noir, @@drapeau].include? ceci
  end

  ##
  # Renvois l'état suivant à celui reçu
  # Lève une exception si l'état n'est pas valide
  def Etat.suivant(etat)
    # Assertion
    raise "Etat non valide" if not (Etat.include?(etat) and etat != nil)
    # Retour
    if etat == @@blanc 		then return @@noir
    elsif etat == @@noir	then return @@drapeau
    elsif etat == @@drapeau 	then return @@blanc
    end
  end

  # Accesseur vers l'état blanc
  def Etat.Blanc() return @@blanc end
  # Accesseur vers l'état noir
  def Etat.Noir() return @@noir end
  # Accesseur vers l'état drapeau
  def Etat.Drapeau() return @@drapeau end

end






#################################
# LOGS				#
#################################
# mainteneur : BOURNEUF

class Logs

  # impossible d'instancier cette classe
  private_class_method :new
	
	@fileLog = File.new("log.txt", "w")

  ##
  # Ajoute le texte reçu dans les logs
  def Logs.add(txt)
    #puts txt
		@fileLog.write(txt)
  end

end






