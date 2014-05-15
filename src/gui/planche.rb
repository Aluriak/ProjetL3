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
	

	#creation de planche
	def Planche.creer(tableEtat, modeEdition = false, texture = "coeurrouge")
		new(tableEtat, modeEdition, texture)
	end
	
	def initialize(tableEtat, modeEdition, texture)
                @modeDragAndAssign = false
		dossier = CONSTANT_FICHIER_GUI_TEXTURE #dossier contenant les images
		@tabImg = ["blanc.jpg", "noir.jpg", "croix.jpg"]
		@tabImg.map!{|img| dossier + texture + "/" + img}
		@tableEtat = tableEtat
		@table = Table.new(tableEtat.size,tableEtat.size)
                @table.add_events(Gdk::Event::BUTTON_PRESS_MASK)
		@modeEdition = modeEdition
		#self.setup(tableEtat)
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
						#@tableEtat.basculer(x,y)												
                                                if @tableEtat[x][y] == Etat.Noir then
                                                  basculer(x,y, Etat.Blanc)   if clic_gauche
                                                  basculer(x,y, Etat.Drapeau) if not clic_gauche
                                                elsif @tableEtat[x][y] == Etat.Blanc then
                                                  basculer(x,y, Etat.Noir)    if clic_gauche
                                                  basculer(x,y, Etat.Drapeau) if not clic_gauche
                                                else
                                                  basculer(x,y, Etat.Noir)  if clic_gauche
                                                  basculer(x,y, Etat.Blanc) if not clic_gauche
                                                end
					end
                                        @modeDragAndAssign = true
                                        @etatModeDragAndAssign = @tableEtat[x][y]
					actualiser(x,y)                                  
				}
                                @event_box[x][y].signal_connect("button_release_event") {
                                        @modeDragAndAssign = false
                                }
                                @event_box[x][y].signal_connect("enter-notify-event") {
                                  if @modeDragAndAssign then
                                    basculer(x,y, @etatModeDragAndAssign)
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

        ## 
        # Bascule l'état de la case (x;y) de la table d'état.
        # Si l'arguement est nil, l'état passera au suivant.
        def basculer(x, y, etat = nil)
          @tableEtat[x][y] = Etat.suivant(@tableEtat[x][y]) if etat == nil
          @tableEtat[x][y] = etat if etat != nil
        end



end #fin de classe
