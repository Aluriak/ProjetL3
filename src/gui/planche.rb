# -*- encoding: utf-8 -*-
load "src/commun/commun.rb"
load "src/grille/jouable.rb"


class Planche
	
	@tabImg
	@event_box
	@image
	@table
	@jouable
	@modeEdition

	DEBUG = false
	
	#la table est un conteneur d'images/event box
	attr_reader :table
	
	#listes de images
	attr_reader :tabImg		
	
	#event sur la jouable d'image
	attr_reader :event_box	
	
	#jouable d'image
	attr_reader :image		
	
	# la grille jouable qui est en train d'etre jouée
	attr_reader :jouable
	
	# si on est en mode édition, alors les etats sont soit blanc soit noir
	# sinon, en mode normal(ou jeu), les états sont drapeau, blanc, ou noir
	attr_reader :modeEdition
	
	#creation de planche
	def Planche.creer(jouable, modeEdition = false)
		new(jouable, modeEdition)
	end
	
	def initialize(jouable, modeEdition)
		dossier = CONSTANT_FICHIER_GUI_IMAGE #dossier contenant les images
		@tabImg = ["blanc.jpg", "noir.jpg", "croix.jpg"]
		@tabImg.map!{|img| dossier + img}
		@jouable = jouable
		@table = Table.new(jouable.taille,jouable.taille)
		self.setup(jouable)
		@modeEdition = modeEdition
	end
	
=begin
	#reinitialisation de grille jouable
	def reinitialiser(jouable)
		@table = @table.resize(jouable.taille,jouable.taille)
		self.setup(jouable)
	end
=end
	
	def image(etat)
		if Etat.include?(etat) then return Image.new(@tabImg[etat]) end
	end
	
	#si la case est cochée, elle devient noire, etc..
	def suivante(image)
		
		if modeEdition == true
			image.file = (@tabImg[@tabImg.index(image.file)] == Etat.Noir) ?
				@tabImg[Etat.Blanc] : @tabImg[Etat.Noir]
		else
			image.file = @tabImg[Etat.suivant(@tabImg.index(image.file))]
		end
		#normalement à la place de tout ça : 
		#image.file = @tabImg[@picross.etatGrille(x,y)] en changeant le prototype 
		#pour qu'il prenne les coordonnées, et non l'objet 'image'
	end
	
	#pour l'edition seulement(normalement inutile, si le picross est actualisé)
	def toMatrice
		matrice = Array.new(@jouable.taille) { Array.new(@jouable.taille) }
		0.upto(jouable.taille - 1) { |y| 
			0.upto(jouable.taille - 1) { |x|                     
				matrice[x][y] = @tabImg.index(@image[x][y].file) == 1 ? 1 : 0
			}
		}
		return matrice
	end	

	
	#fonction qui prend la matrice jouable de jeu en parametre
	def setup(jouable)
			
		@image = Array.new(jouable.taille) { Array.new(jouable.taille) }
		@event_box = Array.new(jouable.taille) { Array.new(jouable.taille) }
		
		p @jouable
		
		0.upto(jouable.taille - 1) { |y| 
			0.upto(jouable.taille - 1) { |x|                         
				@image[x][y] = self.image(jouable.matriceDeJeu[x][y])
				@event_box[x][y] = EventBox.new.add(@image[x][y])  
				
				#les 1+n éléments indiquent la position du widget
				@table.attach(@event_box[x][y], x, x+1, y, y+1) 
              
				#crée les évenements de click sur chaque cases
				@event_box[x][y].signal_connect("button_press_event") { 
					#self.suivante(@image[x][y]) 
					# normalement à la place :
					# 1 MODIF DE L'ETAT DU PICROSS
					 if modeEdition then
						if @jouable.etat(x,y) == Etat.Blanc then
							@jouable.basculer(x,y,Etat.Noir) 
						else
							@jouable.basculer(x,y,Etat.Blanc)
						end
					else												
						@jouable.basculer(x,y)												
					end
					
					#2 ACTUALISATION
					#
					@image[x][y].file = @tabImg[@jouable.etat(x,y)]
				}
			}
		}
		self.miseAJour
	end
	
	#sensé faire la mise à jour du nombre de cases..
	def miseAJour
		while(Gtk.events_pending?)
			Gtk.main_iteration_do(true)
		end
	end

end
