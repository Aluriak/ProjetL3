# -*- encoding: utf-8 -*-
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
		iconePreference = Gtk::Image.new CONSTANT_FICHIER_GUI_IMAGE+"preference.png"

		toolbar = Toolbar.new
		toolbar.set_toolbar_style(Toolbar::Style::ICONS)

		tooltip = Tooltips.new

		newtb = ToolButton.new(Stock::NEW)
	  	edittb = ToolButton.new(Stock::EDIT)
		opentb = ToolButton.new(Stock::OPEN)
		savetb = ToolButton.new(Stock::SAVE)
		scoretb = ToolButton.new(iconeScore, "Score")
		helptb = ToolButton.new(Stock::HELP)
		preftb = ToolButton.new(iconePreference, "Preference")
		abouttb = ToolButton.new(Stock::ABOUT)
    
		tooltip.set_tip(newtb,"Nouvelle partie",nil)
		tooltip.set_tip(edittb,"Edition d'une grille", nil)
		tooltip.set_tip(opentb,"Charger une grille", nil)
		tooltip.set_tip(savetb,"Sauvegarder cette grille", nil)
		tooltip.set_tip(scoretb,"Scores de cette grille",nil)
		tooltip.set_tip(helptb,"Manuel d'aide", nil)
		tooltip.set_tip(preftb,"Préférences", nil)
		tooltip.set_tip(abouttb,"A propos", nil)
	
		tooltip.enable

		toolbar.insert(0, newtb.set_label("Nouveau"))
		toolbar.insert(1, edittb.set_label("Editer"))
		toolbar.insert(2, opentb.set_label("Charger"))
		toolbar.insert(3, savetb.set_label("Sauvegarder"))
		toolbar.insert(4, scoretb.set_label("Score"))
		toolbar.insert(5, helptb.set_label("Manuel"))
		toolbar.insert(6, preftb.set_label("Preference"))
		toolbar.insert(7, abouttb.set_label("A Propos"))
		
		@listMenuBtns = [newtb,edittb,opentb,savetb,scoretb,helptb,preftb,abouttb]

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




