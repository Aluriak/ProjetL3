# -*- encoding: utf-8 -*-
# AIDE_WRAP.RB
# Wrapper sur les aides.
# BOURNEUF
#


#################################
# IMPORTS                       #
#################################
load "src/commun/commun.rb"
load "src/aide/aide.rb"



#################################
# AIDE                          #
#################################
# mainteneur : BOURNEUF

##
# L'AideWrap n'est jamais instanciée : il s'agit juste d'un conteneur pour les deux méthodes 
#  que sont aidedeniveau1 et aidedeniveau2. 
# Ces appels nécessiterons une grille en entrée, et renverrons une chaîne de caractères en sortie.
# L'aidAwrap est un wrapper pour la classe Aide; elle correspond au pattern Adaptator, afin que l'aide 
#  corresponde au attentes du dossier de conception.
class AideWrap

  # Pas d'instanciation possible de la classe
  private_class_method :new



  ##
  # [STATIC] Aide de niveau 1, consistant en un conseil vague sur une ligne ou une colonne
  def AideWrap.deNiveau1Sur(grille) 
    aides_dispo = Aide.creer(grille).aideDeNiveau1 # obtention des chaines d'aide possible
    return aides_dispo.choice # on en retourne une au hasard
  end




  ##
  # [STATIC] Aide de niveau 2, consistant en un conseil précis et clair sur un point précis de la grille.
  def AideWrap.deNiveau2Sur(grille) 
    aides_dispo = Aide.creer(grille).aideDeNiveau2 # obtention des chaines d'aide possible
    return aides_dispo.choice # on en retourne une au hasard
  end




end




