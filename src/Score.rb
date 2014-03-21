# -*- encoding: utf-8 -*-
# SCORE.RB
# définition de la classe SCORE
# MARECHAL
 
#################################
# IMPORTS #
#################################
load 'src/commun/commun.rb'




#################################
# SCORE                         #
#################################
# mainteneur : MARECHAL

# Un score contient le temps mis pour la résolution d'une grille, sa taille et le nombre d'aide utilisé.
# Elle implemente Comparable pour pouvoir effectuer des comparaisons entre Score.
class Score
	
	include Comparable
	
	@temps
	@taille
	@nbrAide
	
	def initialize(taille,tps,aide)
	
		@temps = tps
		@taille = taille
		@nbrAide = aide
		
	end
	
	private_class_method:new
	
	def Score.creer(taille, tps, aide)
	
		new(taille,tps,aide)
	end
	
	def <=>(another)		#Cette methode est voué à être modifié par la suite. Ce n'est qu'un brouillon
		@temps <=> another.@temps
		@taille = another.@taille
		@nbrAide = another.@nbrAide
	end

end





#La classe Score contient deux Hash permettant de stocker les scores.
#Le hash des grilles prend l'idGrille en tant que clé.
#Le hash des joueurs prend le nom du joueur en tant que clé.
class Scores

	@scoreGrille
	@scoreJoueur

	def initialize ()
	
		@scoreGrille = Hash.new
		@scoreJoueur = Hash.new
	
	end
	
	private_class_method:new
	
	def Scores.creer()
		new()
	end
	
	
	
	def ajouterScoresGrille(idGrille, score)		#Ajoute au hash des grilles, un id grille et son score. Si l'idGrille est déjà présent, met à jour le hash. 	
		if (@scoreGrille.has_key?(idGrille))
			
			if ((@scoreGrille.fetch(idGrille) <=> score) >= 0)
				@scoreGrille[idGrille] = score
			
			end
		else
				@scoreGrille[idGrille] = score
		end
		
		
	end
	
	
	
	def ajouterScoresJoueur(nomjoueur, score)		#Ajoute au hash des joueurs, un nom de joueur et son score. Si le nomjoueur est déjà présent, met à jour le hash. 
		if (@scoreJoueur.has_key?(nomjoueur))
			
			if ((@scoreJoueur.fetch(nomjoueur) <=> score) >= 0)
				@scoreJoueur[nomjoueur] = score
			
			end
		else
				@scoreJoueur[nomjoueur] = score
		end
	end
	
	def getScoresGrille(idGrille)		#Retourne la pair idGrille-score associé
	
		return @scoreGrille.assoc(idGrille)
	end
	
	
	def getScoreJoueur(nomJoueur)		#Retourne la pair nomJoueur-score associé
	
		return @scoreJoueur.assoc(nomJoueur)
	end
		
end	
	
