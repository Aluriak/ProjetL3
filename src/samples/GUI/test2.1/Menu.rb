class Menu
	@listBtns
	
	attr_reader :listBtns
	
	#param : la box surlaquelle on attache
	#param : les différents noms des boutons
	#nb : les boutons sont stockés dans listBtns
	def Menu.creer(box,*noms)
		new(box,*noms)
	end
	
	def initialize(box,*noms)
		@listBtns = []
		
		noms.each{ |nom|
			box.add(btn = Button.new(nom))
			@listBtns << btn
		}
	end
	
end