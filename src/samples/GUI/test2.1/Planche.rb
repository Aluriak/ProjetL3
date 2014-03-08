class Planche
	
	@table
	@tabImg
	@event_box
	@image
	
	#la table contient toutes cases à 3 états
	attr_reader :table
	
	def Planche.creer(taille)
		new(taille)
	end
	
	def initialize(taille)
		dossier =  "ressources"+"/" #dossier contenant les images
		@tabImg = ["blanc.jpg", "noir.jpg", "croix.jpg"]
		@tabImg.map!{|img| dossier + img}
		
		@table = Table.new(taille,taille)
		self.setup(taille)
	end
	
	def reinitialiser(taille)
		@table = @table.resize(taille,taille)
		self.setup(taille)
	end
	
	def imageHasard
		return Image.new(@tabImg[rand(2)])
	end
	
	#si la case est cochée, elle devient noire, etc..
	def suivante(image)
		 image.file = @tabImg[(@tabImg.index(image.file)+1)%@tabImg.size]
	end
	
	def setup(taille)
			
		@image = Array.new(taille) { Array.new(taille) }
		@event_box = Array.new(taille) { Array.new(taille) }
		
		0.upto(taille - 1) { |y| 
			0.upto(taille - 1) { |x|
				@image[x][y] = self.imageHasard
				@event_box[x][y] = EventBox.new.add(@image[x][y])  
				
				#les 1+n éléments indiquent la position du widget
				@table.attach(@event_box[x][y], x, x+1, y, y+1) 
              
				#crée les évenements de click sur chaque cases
				@event_box[x][y].signal_connect("button_press_event") { 	
					self.suivante(@image[x][y])
				}
			}
		}
		
		while(Gtk.events_pending?)
			Gtk.main_iteration_do(true)
		end
	end

end
