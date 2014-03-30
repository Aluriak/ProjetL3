class Menu
	@listBtns
	
	attr_reader :listBtns
	
	#param : la box sur laquelle on attache
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
	
	#private :nom
	
	#renvoie le bouton correspond au nom passé en paramètre
	def nom(leNom)
		@listBtns.each { |b|
			if b.label == leNom then return b end
		}
		raise "ce bouton n'existe pas"
	end
	
	#éxécute les actions du bloc du bouton appelé leNom(p.e. "Editer")
	def clickerSur(leNom,&bloc)
		nom(leNom).signal_connect("clicked") {
			bloc.call
		}
	end
end