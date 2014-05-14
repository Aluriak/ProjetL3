load "src/commun/commun.rb"

include Gtk

class MenuPrincipal

	@listMenuBtns

	# la listes de menus(ce sont des boutons avec de images)
	attr_reader :listMenuBtns
	
	#Creation du menuHaut dans lequel on ajoute les boutons principaux
	#param : la box sur laquelle on attache les boutons
	def MenuPrincipal.creerMenuHaut(box)
		new(box)
	end 

	def initialize(box)

		#Chargement de l'icone pour le boutton score
		iconeScore = Gtk::Image.new CONSTANT_FICHIER_GUI_IMAGE+"score.png"

		toolbar = Toolbar.new
		toolbar.set_toolbar_style(Toolbar::Style::ICONS)

		newtb = ToolButton.new(Stock::NEW)
	  	edittb = ToolButton.new(Stock::EDIT)
      	opentb = ToolButton.new(Stock::OPEN)
      	savetb = ToolButton.new(Stock::SAVE)
      	scoretb = ToolButton.new(iconeScore, "Score")
      	helptb = ToolButton.new(Stock::HELP)
      	abouttb = ToolButton.new(Stock::ABOUT)
    

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
      	scoretb.set_label("Score")
      	helptb.set_label("Manuel")
      	abouttb.set_label("A Propos")
		
		@listMenuBtns = [newtb,edittb,opentb,savetb,scoretb,helptb,abouttb]

      	box.pack_start(toolbar)
	end	

	# renvoie le menu(le bouton) correspondant au nom qu'on a rentré
	def nomToMenu(nom) 
		@listMenuBtns.each { |menu|
			if menu.label == nom then return menu end
		}
		# si on est arrivé là, c'est que rien n'a été trouvé
		raise "#{nom} : nom de bouton inconnu - mauvaise orthographe, majuscule?\n"
	end
	
	def clickerSur(nom, &bloc)
		nomToMenu(nom).signal_connect("clicked") {bloc.call}
	end

	#nomToMenu n'est utilisée que pour clickerSur
	private :nomToMenu
end




