load "src/commun/commun.rb"

include Gtk

class Menu

	@listMenuBtns
	@listHelpBtns

	attr_reader :listMenuBtns
	attr_reader :listHelpBtns
	

	def initialize(box)

		p "Va te faire foutre"
		@listMenuBtns = []


		#Chargement de l'icone pour le boutton score
		iconeScore = Gtk::Image.new CONSTANT_FICHIER_GUI_IMAGE+"/score.png"

		toolbar = Toolbar.new
		toolbar.set_toolbar_style Toolbar::Style::ICONS

		newtb = ToolButton.new Stock::NEW
	  	edittb = ToolButton.new Stock::EDIT
      	opentb = ToolButton.new Stock::OPEN
      	savetb = ToolButton.new Stock::SAVE
      	scoretb = ToolButton.new(iconeScore, "Score")
      	helptb = ToolButton.new Stock::HELP
      	abouttb = ToolButton.new Stock::ABOUT
    

      	toolbar.insert(0, newtb)
      	toolbar.insert(1, edittb)
      	toolbar.insert(2, opentb)
      	toolbar.insert(3, savetb)
      	toolbar.insert(4, scoretb)
      	toolbar.insert(5, helptb)
      	toolbar.insert(6, abouttb)



      	newtb.set_label("Nouveau")
      	edittb.set_label("Editer")
      	opentb.set_label("Charger")
      	savetb.set_label("Sauvegarder")
      	scoretb.set_label("Charger")
      	helptb.set_label("Manuel")
      	abouttb.set_label("A Propos")

      	@listMenuBtns << newtb
      	@listMenuBtns << edittb
      	@listMenuBtns << opentb
      	@listMenuBtns << savetb
      	@listMenuBtns << scoretb
      	@listMenuBtns << helptb
      	@listMenuBtns << abouttb

      	p "ya : ", @listMenuBtns, "dans liste btn"

      	box.pack_start(toolbar)
	end	



	#Creation du menuHaut dans lequel on ajoute les boutons principaux
    #param : la box sur laquelle on attache les boutons
	def Menu.creerMenuHaut(box)
		p "Menu Haut"
		new(box)
		p "Va te faire foutre"
	end 

	def initialize(box, *noms)
		p "Initialize de merde"
		@listHelpBtns = []
    	noms.each{ |nom|    		
			box.add(tb = Button.new(nom))
			@listHelpBtns << tb
		}
    end	





    #Creation du menuDroit dans lequel on ajoute les boutons d'aide
    #param : la box sur laquelle on attache les boutons
    #param : les différents noms des boutons
    def Menu.creerMenuDroit(box, *noms)
    	p "Menu Droit"
		new(box, *noms)
    end	

    


      

	
	#private :stock
=begin	
	#renvoie le bouton correspond au stock passé en paramètre
	def stock(leSTOCK)
		p @listBtns
		@listBtns.each { |tb|
			p tb.label
			if tb.label == leSTOCK then return tb end
		}
		raise "ce bouton n'existe pas"
	end
	
	#éxécute les actions du bloc du bouton appelé lestock(p.e. "Editer")
	def clickerSur(leSTOCK, &bloc)
		stock(leSTOCK).signal_connect("clicked") {
			bloc.call
		}
	
	
	end
=end
 
end