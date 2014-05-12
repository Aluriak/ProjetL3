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
		@modeEdition = modeEdition
		#self.setup(jouable)
		@image = Array.new(jouable.taille) { Array.new(jouable.taille) }
		@event_box = Array.new(jouable.taille) { Array.new(jouable.taille) }
		
		0.upto(jouable.taille - 1) { |y| 
			0.upto(jouable.taille - 1) { |x|                         
				@image[x][y] = self.image(jouable.matriceDeJeu[x][y])
				@event_box[x][y] = EventBox.new.add(@image[x][y])  
				
				@table.attach(@event_box[x][y], x, x+1, y, y+1) 
              
				#crée les évenements de click sur chaque cases
				@event_box[x][y].signal_connect("button_press_event") { 
					# si on est en mode edition -> noir/blanc
					if modeEdition then
						@jouable.basculer(x,y) 
                                                if @jouable.etat(x,y) == Etat.Drapeau then
                                                  @jouable.basculer(x,y) 
                                                end
					# sinon mode normal -> noir/blanc/drapeau
					else												
						@jouable.basculer(x,y)												
					end
					actualiser(x,y)                                  
				}
			}
		}
	end
	
	def image(etat)
		if Etat.include?(etat) then return Image.new(@tabImg[etat]) end
	end
	
	#actualise(affiche la nouvelle valeur) la case en (x, y)
	def actualiser(x,y)
		@image[x][y].file = @tabImg[@jouable.etat(x,y)]
	end

end #fin de classe
