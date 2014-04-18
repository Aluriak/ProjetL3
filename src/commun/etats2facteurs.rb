# -*- encoding: utf-8 -*-
# ETATS2FACTEURS.RB
# définition d'une méthode compliquée de Grille.
# BOURNEUF
 
#################################
# IMPORTS			#
#################################


class Grille
  # Retourne le duet facteursColonne et facteursLigne correspondant 
  # à la matrice d'état envoyée en arguments
  def Grille.matriceEtats2facteurs(matriceEtats) 
    # IMPLÉMENTER LISTE DES COLONNES
    matriceFacteursColonne = Array.new
    # pour chacune des lignes
    matriceEtats.size.times do |col|
      # compteur de noir
      nbNoirConsecutif = 0 
      # ajouter une liste d'entier à la matrice de facteurs
      matriceFacteursColonne.push(Array.new)
      # pour chacune des colonnes
      matriceEtats.size.times do |row|
      	# obtenir l'état de la case
      	c = matriceEtats[row][col]
	# si c'est du blanc
      	if c == Etat.Blanc or c == Etat.Drapeau then 
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
    matriceEtats.size.times do |row|
      # compteur de noir
      nbNoirConsecutif = 0 
      # ajouter une liste d'entier à la matrice de facteurs
      matriceFacteursLigne.push(Array.new)
      # pour chacune des colonnes
      matriceEtats.size.times do |col|
      	# obtenir l'état de la case
      	c = matriceEtats[row][col]
	# si c'est du blanc
      	if c == Etat.Blanc or c == Etat.Drapeau then 
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

    # RETOURNER LES DEUX MATRICES D'ENTIERS
    return matriceFacteursColonne, matriceFacteursLigne
  end # fin de fonction

# fin de classe
end




