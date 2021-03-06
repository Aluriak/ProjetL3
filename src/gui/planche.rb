# -*- encoding: utf-8 -*-
load "src/commun/commun.rb"
load "src/grille/jouable.rb"


class Planche
	
	@tabImg
	@event_box
	@image
	@table
	@tableEtat
	@modeEdition
  @modeDragAndAssign
  @etatModeDragAndAssign

	DEBUG = false
	
	#la table est un conteneur d'images/event box
	attr_reader :table
	
	#listes de images
	attr_reader :tabImg		
	
	#event sur la tableEtat d'image
	attr_reader :event_box	
	
	#tableEtat d'image
	attr_reader :image		
	
	# la grille tableEtat qui est en train d'etre jouée
	attr_reader :tableEtat
	
	# si on est en mode édition, alors les etats sont soit blanc soit noir
	# sinon, en mode normal(ou jeu), les états sont drapeau, blanc, ou noir
	attr_reader :modeEdition

	# Si vrai, le mode drag and assign est activé. Dans le ce mode, toute case 
	# rencontrée par la souris de l'utilisateur est basculée à l'état suivant.
	attr_accessor :modeDragAndAssign
	
	#texture des cases
	attr_accessor :texture


	#creation de planche
	def Planche.creer(tableEtat, modeEdition = false, texture = "coeurrouge")
		new(tableEtat, modeEdition, texture)
	end
	
	def initialize(tableEtat, modeEdition, texture)

		@modeDragAndAssign = false
		dossier = CONSTANT_FICHIER_GUI_TEXTURE #dossier contenant les images
		if tableEtat.size >= 20
			@tabImg = ["blanc25.jpg", "noir25.jpg", "croix25.jpg"]
		else
			@tabImg = ["blanc.jpg", "noir.jpg", "croix.jpg"]
		end
		
		@texture = texture
		
		print "la texture est #{@texture}\n"
		
		@tabImg.map!{|img| dossier + @texture + "/" + img}
		@tableEtat = tableEtat
		@table = Table.new(tableEtat.size,tableEtat.size)
		@table.add_events(Gdk::Event::BUTTON_PRESS_MASK)
		@modeEdition = modeEdition
		@image = Array.new(tableEtat.size) { Array.new(tableEtat.size) }
		@event_box = Array.new(tableEtat.size) { Array.new(tableEtat.size) }
		
		0.upto(@tableEtat.size-1) { |y| 
			0.upto(@tableEtat.size-1) { |x|                         
		
				@image[x][y] = self.image(@tableEtat[x][y])
				@event_box[x][y] = EventBox.new.add(@image[x][y])  
				
				@table.attach(@event_box[x][y], y, y+1, x, x+1) 
              
				#crée les évenements de click sur chaque cases
				@event_box[x][y].signal_connect("button_press_event") { |widget, event|
					# si on est en mode edition -> noir/blanc
					if modeEdition then
						basculer(x,y) 
						if @tableEtat[x][y] == Etat.Drapeau then
							basculer(x,y) 
						end
					# sinon mode normal -> noir/blanc/drapeau
					else
						clic_gauche = (event.button == 1)
						
						case @tableEtat[x][y]
						when Etat.Noir
							basculer(x,y, clic_gauche ? Etat.Blanc : Etat.Drapeau)  
						when Etat.Blanc
							basculer(x,y, clic_gauche ? Etat.Noir : Etat.Drapeau) 
						when Etat.Drapeau
							basculer(x,y, clic_gauche ? Etat.Noir : Etat.Blanc)
						end
					end
					
					@modeDragAndAssign = true
					@etatModeDragAndAssign = @tableEtat[x][y]
					actualiser(x,y)
					# lors de l'appuis du bouton et jusqu'au relâchement de bouton, 
					# Gdk "grab" ce widget : les évènements ne parviennent plus qu'à cet unique bouton.
					# Avec la commande suivante, le bouton est "ungrabé", permettant aux autres boutons de
					# recevoir l'évènement "enter_notify_event".
					Gdk.pointer_ungrab(Gdk::Event::CURRENT_TIME)
				}
				
				@event_box[x][y].signal_connect("button_release_event") {
					@modeDragAndAssign = false
				}
				
				@event_box[x][y].signal_connect("enter_notify_event") {
					if @modeDragAndAssign then
						self.basculer(x, y, @etatModeDragAndAssign)
					end
				}
			}
		}


	end
	
	def image(etat)
		if Etat.include?(etat) then return Image.new(@tabImg[etat]) end
	end
	
	#actualise(affiche la nouvelle valeur) la case en (x, y)
	def actualiser(x,y)
		@image[x][y].file = @tabImg[@tableEtat[x][y]]
	end
	
	def toutActualiser
		0.upto(@tableEtat.size-1) { |y| 
			0.upto(@tableEtat.size-1) { |x|                         
				@image[x][y].file = @tabImg[@tableEtat[x][y]]
			}
		}
	end
	
	def set_texture(texture)
		@texture = texture
		print "la texture est #{@texture}\n"	
	end

	## 
	# Bascule l'état de la case (x;y) de la table d'état.
	# Si l'arguement est nil, l'état passera au suivant.
	def basculer(x, y, etat = nil)
		@tableEtat[x][y] = Etat.suivant(@tableEtat[x][y]) if etat == nil
		@tableEtat[x][y] = etat if etat != nil
		self.actualiser(x, y)
	end



end #fin de classe
