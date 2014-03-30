# -*- encoding: utf-8 -*-
# SCORE.RB
# définition de la classe SCORE
# MARECHAL
 

# NB : score, scoreS, peut-être mieux dans deux fichiers différents?
#################################
# IMPORTS #
#################################
load "src/commun/commun.rb"




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
	
	#commentaires A FAIRE
	attr_reader :temps
	
	#commentaires A FAIRE
	attr_reader :taille
	
	#commentaires A FAIRE
	attr_reader :nbrAide
	
	private_class_method:new
	
	def Score.creer(taille, tps, aide)
	
		new(taille,tps,aide)
	end
	
	def initialize(taille,tps,aide)
		@temps = tps
		@taille = taille
		@nbrAide = aide
	end
	
	#Cette methode est voué à être modifié par la suite. 
	#Ce n'est qu'un brouillon
	def <=>(another)		
		@temps <=> another.@temps
		@taille = another.@taille
		@nbrAide = another.@nbrAide
	end

end#end class



#La classe Score contient deux Hash permettant de stocker les scores.
#Le hash des grilles prend l'idGrille en tant que clé.
#Le hash des joueurs prend le nom du joueur en tant que clé.
#
#NB : 	- comment on s'en sert?
#		- quels liens dans le projet? (utilisé par quelles classes? indépendantes?)
#		- utile de faire une méthode de classe sans arguments????
class Scores

	@scoreGrille
	@scoreJoueur
	
	#commentaires A FAIRE
	attr_reader :scoreGrille
	
	#commentaires A FAIRE
	attr_reader :scoreJoueur
	
	private_class_method:new

	def Scores.creer()
		new()
	end
	
	def initialize
		@scoreGrille = Hash.new
		@scoreJoueur = Hash.new
	end
	
	#Ajoute au hash des grilles, un id grille et son score. 
	#Si l'idGrille est déjà présent, met à jour le hash. 	
	def ajouterScoresGrille(idGrille, score)		
		if @scoreGrille.has_key?(idGrille)
			if (@scoreGrille.fetch(idGrille) <=> score) >= 0
				@scoreGrille[idGrille] = score
			end
		else
			@scoreGrille[idGrille] = score
		end
	end
	
	#Ajoute au hash des joueurs, un nom de joueur et son score. 
	#Si le nomjoueur est déjà présent, met à jour le hash. 
	def ajouterScoresJoueur(nomjoueur, score)		
		if @scoreJoueur.has_key?(nomjoueur)
			if (@scoreJoueur.fetch(nomjoueur) <=> score) >= 0
				@scoreJoueur[nomjoueur] = score
			end
		else
			@scoreJoueur[nomjoueur] = score
		end
	end
	
	#Retourne la pair idGrille-score associé
	def getScoresGrille(idGrille)		
		return @scoreGrille.assoc(idGrille)
	end
	
	#Retourne la pair nomJoueur-score associé
	def getScoreJoueur(nomJoueur)		
		return @scoreJoueur.assoc(nomJoueur)
	end
	
	
end	#end class
	
