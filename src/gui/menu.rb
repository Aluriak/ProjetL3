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


=begin		
		mb = MenuBar.new
		
		filemenu = Menu.new
		filem = MenuItem.new "Fichier"
		filem.set_submenu filemenu
		
		editmenu = Menu.new
		editm = MenuItem.new "Editer"
		editm.set_submenu editmenu
		
		chargmenu = Menu.new
		chargm = MenuItem.new "Charger"
		chargm.set_submenu chargmenu
		
		#savemenu = Menu.new
		savem = MenuItem.new "Sauver"
		#savem.set_submenu savemenu
		savem.signal_connect("activate"){
			printf("on sauve le tout")
		}
		
		exit = MenuItem.new "Exit"
		exit.signal_connect("activate"){ Gtk.main_quit}
		
		filemenu.append exit
		
		mb.append filem
		mb.append editm
		mb.append chargm
		mb.append savem
		
		vbox = VBox.new false, 2
		vbox.pack_start(mb, false, false, 0)
=end
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