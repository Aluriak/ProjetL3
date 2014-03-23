# -*- encoding: utf-8 -*-
load "grille/jouable.rb"


class Planche
	
	@tabImg
	@event_box
	@image
	@table
	
	@taille
	
	#la table est un conteneur d'images/event box
	attr_reader :table
	
	#listes de images
	attr_reader :tabImg		
	
	#event sur la jouable d'image
	attr_reader :event_box	
	
	#jouable d'image
	attr_reader :image		
	
	#taille de la jouable
	attr_reader :taille
	
	def Planche.creer(jouable)
		new(jouable)
	end
	
	def initialize(jouable)
		dossier =  "gui/ressources/" #dossier contenant les images
		@tabImg = ["blanc.jpg", "noir.jpg", "croix.jpg"]
		@tabImg.map!{|img| dossier + img}
		@table = Table.new(jouable.taille,jouable.taille)
		self.setup(jouable)
	end
	
	def reinitialiser(jouable)
		@table = @table.resize(jouable.taille,jouable.taille)
		self.setup(jouable)
	end
	
	def image(etat)
		if Etat.include?(etat) then return Image.new(@tabImg[etat]) end
	end
	
	#si la case est cochée, elle devient noire, etc..
	def suivante(image)
		 image.file = @tabImg[Etat.suivant(@tabImg.index(image.file))]
	end
	
	def setup(jouable)#prend la matrice jouable de jeu en parametre
			
		@image = Array.new(jouable.taille) { Array.new(jouable.taille) }
		@event_box = Array.new(jouable.taille) { Array.new(jouable.taille) }
		
		0.upto(jouable.taille - 1) { |y| 
			0.upto(jouable.taille - 1) { |x|
				#p jouable[x][y]
				@image[x][y] = self.image(jouable.matriceDeJeu[x][y]) # à la place de 0
				@event_box[x][y] = EventBox.new.add(@image[x][y])  
				
				#les 1+n éléments indiquent la position du widget
				@table.attach(@event_box[x][y], x, x+1, y, y+1) 
              
				#crée les évenements de click sur chaque cases
				@event_box[x][y].signal_connect("button_press_event") { 	
					self.suivante(@image[x][y])
				}
		                               
				#A faire : les autres evenements
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
