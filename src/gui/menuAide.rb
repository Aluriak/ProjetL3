# -*- encoding: utf-8 -*-

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
	def nomToBouton(leNom)
		@listBtns.each { |bouton|
			if bouton.label == leNom then return bouton end
		}
		raise "ce bouton n'existe pas"
	end
	
	#éxécute les actions du bloc du bouton appelé leNom(p.e. "Editer")
	def clickerSur(leNom,&bloc)
		nomToBouton(leNom).signal_connect("clicked") {
			bloc.call
		}
	end
	

end




