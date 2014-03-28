# -*- encoding: utf-8 -*-
#IMAGE.RB
# créer des grilles à partir d'images
#Ewen COUSIN

require "RMagick"
include Magick

load "src/commun/commun.rb"

#Classe PicrossImage
#
# Classe qui tranforme une image en picross (en matrice noir/blanc)
#
#---------------------------------------
# Procédure de l'algorithme :
# 	1° Monochromiser l'image
# 	2° Reduire l'image à 5*5 ou 10*10 ...
# 	3° Remonochromiser l'image
#
# 	NB : 	255,255,255 = NOIR
#			0,  0,  0   = BLANC
#
# 	Utiliser la fonction toPicross qui fait tout le boulot (d'une image, renvoie une matrice)
#	A utiliser plutot sur les 20*20 et 25*25, en dessous, on ne voit pas grand chose.
#---------------------------------------
class PicrossImage
	@image
	@matrice
	
	#A l'initialisation d'une grille, il n'y a que des blancs et des noirs.
	#Et les noirs sont effacées et enregistrés dans les grilles de chiffres.
	#Donc deux états(BLANC/NOIR) sont suffisant.
	
	#l'image sur laquelle on fait des traitements
	attr_reader :image
	
	#la matrice contenant soit un Etat blanc, soit un Etat noir
	#c'est elle qu'on va remplir, et qui va être le résultat de
	#elle n'est initialisée qu'à l'appel de la méthode imageToPicross
	attr_reader :matrice
	
	#méthode de CLASSE pour créer une instance d'imagePicross
	def PicrossImage.lire(input) 
		new(input) 
	end
	
	def initialize(input) 
		@image = ImageList.new(input) 
	end
	
	#transforme une image en gamme de gris (photo noir et blanc classique)
	#pas nécessaire pour le picross
	def greyScale! 
		return @image = @image.quantize(256, GRAYColorspace) 
	end
	
	#teste si l'image est en gamme de gris
	def greyScale? 
		return @image.grey? 
	end
	
	# transforme une image en pixels qui sont soit noir soit blanc
	def monochrome! 
		return @image = @image.quantize(2, GRAYColorspace) 
	end
	
	def enregistrer(output) 
		@image.write(output) 
	end
	
	def afficher 
		@image.display 
	end
	
	#Pixelise l'image(la modifie)
	#enCombien est le nombre de pixel qu'on veut pour l'image
	#exemple enCombien = 5, ça fera une image en 5*5
	def pixeliser!(enCombien) return @image.resize_to_fit!(enCombien) end
	
	#Contraste l'image. Plus n est grand, plus le contraste est fort.
	#Par exemple n à 50 donne un assez fort contraste.
	#La méthode de contraste n'a pas besoin d'une image noir/blanc, 
	#une image couleur peut très bien être contrastée.
	def contraster!(n)
		n.times {
			@image = @image.contrast(true)
		}
	end
	
	#Convertit l'image noir et blanc en picross noir et blanc
	#0 = blanc, 1 = noir
	#J'ai pris comme composante le rouge, 
	#mais on peut tester indifféremment le rouge, le vert, ou le bleu,
	#car chaque composante a la même valeur, si l'image est en gamme de gris, ou noir et blanc pur
	def imageToPicross(taille)
		@matrice = Array.new(taille) { Array.new(taille) }
		
		0.upto(taille - 1){|y|
			0.upto(taille - 1){|x|
				#le blanc dans une image correspond à 0, ça ne varie pas
				#le noir dans une image peut correspondre à 255, 65535, etc.., selon la taille d'une couleur
				@matrice[x][y] = (@image.pixel_color(x,y).red == 0 ? Etat.Blanc(): Etat.Noir())
			}
		}
		return matrice
	end
	
	#méthode toPicross(taille)
	#
	#tranforme l'image en picross dont la taille est passée en argument
	# ALGOs
	# 1) monochrome, pixeliser, monochrome
	# 	NB:	cet algo donne de plutôt bons résultats
	#		si on ne monochrome pas avant et après le résultat est bien moins bon (cf A2)
	# 2) contraster(50 ~ beaucoup), pixeliser, monochrome
	#	NB:	si l'image est très très molle, à la place de monochromer dès le début, on contraste fort
	#
	# renvoie la matrice du picross (valeurs sont soit Etat.Blanc soit Etat.Noir)
	#
	def toPicross(taille)
		algo = 1
		case algo
		when 1 then self.ps_dbmono(taille)
		when 2 then self.ps_contrast(taille)
		#etc...
		end
		
		return @matrice
	end
	
	#algo 1
	def ps_dbmono(taille)
		self.monochrome!
		self.pixeliser!(taille)
		self.monochrome!
		
		return @matrice = self.imageToPicross(taille)
	end
	
	#algo 2
	def ps_contrast(taille)
		self.contraster!(200)
		self.afficher
		self.pixeliser!(taille)
		self.monochrome!
		
		return @matrice = self.imageToPicross(taille)
	end
	
	def afficherMatrice
		texte = ""
		0.upto(@matrice.size-1){ |y|
			0.upto(@matrice.size-1){ |x|
				texte += @matrice[x][y].to_s
			}
			texte += "\n"
		}
		return texte
	end
	
	
end #fin de classe


folder = "."

image = PicrossImage.lire(folder+"/lettreD.jpg")

#pour afficher le picross résolu
taille = 25
image.toPicross(taille)
image.enregistrer("./#{taille.to_s*2}-1.jpg")

output = File.new("output.txt", "w")
output.write(image.afficherMatrice)
=begin
#méthode qui crée une imagePicross
pi = PicrossImage.lire(folder+"/cascade4.jpg")
#méthode qui enegistrera une grille racine depuis la fenetre d'édition; 
#on cliquera, ça fera une matrice avec des noirs et des blancs, c'est cette matrice qu'on passera en argument
gr = GrilleRacine.creerDepuisEdition(pi.toPicross(taille)) 
=end
                        