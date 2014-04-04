class TableChiffre
	
	@table
	@largeur
	@hauteur
	@labels
	
	#la table contient toutes cases à 3 états(graphique)
	attr_reader :table
	
	#la matrice est un lien vers une matriceDeLigne ou matriceDeColonne(réél)
	attr_reader :matrice
	
	#les dimensions de la table
	attr_reader :largeur, :hauteur
	
	#creation de la tableChiffre
	def TableChiffre.creer(matrice)
		new(matrice)
	end
	
	def initialize(matrice)	
		#il faudrait avoir ça
		#@hauteur, @largeur = matrice.hauteur, matrice.largeur
		@hauteur, @largeur = 5,5
		
		@table = Table.new(@hauteur, @largeur)
		
		
		self.setup(@hauteur, @largeur)
	end
	
	# affichage
	def afficher
		print "l=#{@largeur};h=#{@hauteur}\n"
	end
	
	def reinitialiser(largeur,hauteur)
		@table = @table.resize(largeur,hauteur)
		self.setup(largeur,hauteur)
	end
	
	def setup(largeur, hauteur)
			
		@labels = Array.new(largeur,Array.new(hauteur))
		
		0.upto(hauteur - 1) { |y| 
			0.upto(largeur - 1) { |x|
				
				#ce qu'il faudrait avoir
				#@labels[x][y] = Label.new.set_text(matrice[x][y])
				@labels[x][y] = Label.new.set_text(rand(10).to_s) #arbitraire
				
				#les 1+n éléments indiquent la position du widget
				@table.attach(@labels[x][y], x, x+1, y, y+1) 
              
				@labels[x][y].signal_connect("button_press_event") { 	
					#rien pour l'instant
				}
			}
		}
		
	end

end
