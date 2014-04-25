
include Gtk

class MenuAide

	
	@listHelpBtns


	attr_reader :listHelpBtns
	

	


	def initialize(box, *noms)
		@listHelpBtns = []
    	noms.each{ |nom|    		
			box.add(tb = Button.new(nom))
			@listHelpBtns << tb
		}
    end	





    #Creation du menuDroit dans lequel on ajoute les boutons d'aide
    #param : la box sur laquelle on attache les boutons
    #param : les différents noms des boutons
    def MenuAide.creerMenuDroit(box, *noms)
		new(box, *noms)
    end	

   
#renvoie le bouton correspond au nom passé en paramètre
	def nom(leNom)
		@listBtns.each { |b|
			if b.label == leNom then return b end
		}
		raise "ce bouton n'existe pas"
	end
	
	#éxécute les actions du bloc du bouton appelé leNom(p.e. "Editer")
	def MenuAide.clickerSur(leNom,&bloc)
		nom(leNom).signal_connect("clicked") {
			bloc.call
		}
	end
	

end