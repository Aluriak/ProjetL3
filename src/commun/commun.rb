# -*- encoding: utf-8 -*-
# COMMUN.RB
# définition de types et fonctions communes au programme
# BOURNEUF
 
#################################
# IMPORTS			#
#################################



#################################
# CONSTANT			#
#################################
class Constant
  # Fichier hébergeant la configuration du programme
  def Constant.FICHIER_DATA_CONFIG 
    return 'data/config'
  end
  # Répertoire contenant les grilles
  def Constant.REPERTOIRE_DATA_GRILLE 
    return 'data/grilles/'
  end
  # Répertoire contenant les sauvegardes
  def Constant.REPERTOIRE_DATA_SAVE 
    return 'data/saves/'
  end
end




#################################
# TAILLE			#
#################################
# mainteneur : BOURNEUF

# Définition de la taille d'une grille
# toutes les tailles possibles sont référencées dans cette classe
class Grille
  @@tailles = [5,10,15,20,25]
  # les tailles possibles de grilles sont listée dans la table de classe
  def Grille.tailles() return @@tailles end
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

  # Renvois true si la valeur reçue est un état valide
  def Etat.include?(ceci)
    return [@@blanc, @@noir, @@drapeau].include? ceci
  end

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






