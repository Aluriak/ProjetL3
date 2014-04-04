class TableChiffre
	
	@table
	@largeur
	@hauteur
	@matrice
	@labels
	
	#la table contient toutes cases à 3 états(graphique)
	attr_reader :table
	
	#la matrice est un lien vers une matriceDeLigne ou matriceDeColonne(réél)
	attr_reader :matrice
	
	#les dimensions de la table
	attr_reader :largeur, :hauteur
	
	#les conteneurs afficheurs
	attr_reader :labels
	
	#creation de la tableChiffre
	def TableChiffre.creer(matrice)
		new(matrice)
	end
	
	def initialize(matrice)	
		
		@matrice = matrice
		
		if matrice.orientationHorizontale?
			@largeur = matrice[0].length	
			@hauteur = matrice.length
		else
			@largeur = matrice.length	
			@hauteur = matrice[0].length
			
		end
		
		#@matrice = 5#matrice.size
		@table = Table.new(@largeur, @hauteur) #à remplacer par matrice.largeur, materice.longueur
		self.setup(@largeur, @hauteur)
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
				@labels[x][y] = Label.new(@matrice[x][y].to_s)
				
				#les 1+n éléments indiquent la position du widget
				@table.attach(@labels[x][y], x, x+1, y, y+1) 
              
		                        
				#@labels[x][y].signal_connect("move-cursor"){
					#@labels[x][y].label.set_markup("<color = blue>Small text</color>")
				#}

				@labels[x][y].signal_connect("button_press_event"){
					#rien pour l'instant
				}
			}
		}
		
	end

end
