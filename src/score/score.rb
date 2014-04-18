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
	
	#temps réalisé
	attr_reader :temps

	#taille de la grille réalisée
	attr_reader :taille
	
	#nombre d'appels à l'aide effectués
	attr_reader :nbrAide
	
	private_class_method:new
	
	def Score.creer(taille, temps, aide)
		new(taille, temps, aide)
	end
	
	def initialize(taille, temps, aide)
		@temps = temps
		@taille = taille
		@nbrAide = aide
	end
	
	# Méthode de comparaison de score
	# Nécessaire pour ordonner les listes et définir les meilleurs joueurs
	# Comparaison sur le temps
	def <=>(another)	
		selfscore = @temps * @taille / @nbrAide	
		othrscore = another.temps * another.taille / another.nbrAide	
		selfscore <=> othrscore
	end

end #end class



#La classe Score contient deux Hash permettant de stocker les scores.
# Hashtable des grilles tel que idGrille => score (meilleur score sur la grille)
# Hashtable des joueurs tel que nom du joueur => score (meilleur du joueur)
class Scores

	@scoreGrille
	@scoreJoueur
	
	# hashtable des scores de grilles
	attr_reader :scoreGrille
	
	# hashtable des scores de joueurs
	attr_reader :scoreJoueur
	
	private_class_method :new

	def Scores.creer()
		new()
	end
	
	def initialize
		@scoreGrille = Hash.new
		@scoreJoueur = Hash.new
	end
	
	#Ajoute au hash des grilles, un id grille et son score, 
	#  avec le nom du joueur l'ayant réalisé. 
	#Si l'idGrille est déjà présent, met à jour le hash. 	
	def ajouterScoresGrille(idGrille, score, nomJoueur)		
		if @scoreGrille.has_key?(idGrille) then
			if score > @scoreGrille[idGrille] then
				@scoreGrille[idGrille] = [score, nomJoueur]
			end
		else
			@scoreGrille[idGrille] = [score, nomJoueur]
		end
	end
	
	#Ajoute au hash des joueurs, un nom de joueur et son score, 
	#  avec l'id de la grille réalisée. 
	#Si le nomjoueur est déjà présent, met à jour le hash. 
	def ajouterScoresJoueur(nomjoueur, score, idGrille)		
		if @scoreJoueur.has_key?(nomjoueur) then
			if score > @scoreJoueur[nomjoueur].first then
				@scoreJoueur[nomjoueur] = [score, idGrille]
			end
		else
			@scoreJoueur[nomjoueur] = [score, idGrille]
		end
	end
	
	# Retourne la liste [meilleur score sur la grille donnée, nom du joueur]
	def getScoresGrille(idGrille)		
		return @scoreGrille[idGrille]
	end
	
	# Retourne la liste [meilleur score du joueur donné, id de la grille]
	def getScoreJoueur(nomJoueur)		
		return @scoreJoueur[nomJoueur]
	end
	
	
end #end class
	
