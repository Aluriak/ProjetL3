class TableChiffre
	
	@table
	@xMax
	@yMax
	@labels
	
	#la table contient toutes cases à 3 états
	attr_reader :table
	
	def TableChiffre.creer(xMax,yMax)
		new(xMax,yMax)
	end
	
	def initialize(xMax,yMax)	
		@table = Table.new(xMax,yMax)
		@yMax, @xMax = yMax, xMax
		self.setup(xMax,yMax)
	end
	
	def reinitialiser(xMax,yMax)
		@table = @table.resize(xMax,yMax)
		self.setup(xMax,yMax)
	end
	
	def setup(xMax, yMax)
			
		@labels = Array.new(xMax) { Array.new(yMax) }
		
		0.upto(yMax - 1) { |y| 
			0.upto(xMax - 1) { |x|
				@labels[x][y] = Label.new.set_text(rand(yMax).to_s)
				
				#les 1+n éléments indiquent la position du widget
				@table.attach(@labels[x][y], x, x+1, y, y+1) 
              
				@labels[x][y].signal_connect("button_press_event") { 	
					#rien pour l'instant
				}
			}
		}
		
	end

end
