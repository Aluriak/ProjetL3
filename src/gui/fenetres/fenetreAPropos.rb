
			
require "gtk2"
require "glib2"
include Gtk

class FenetreAPropos


	def initialize

		auteurs = [
			"\nLucas Bourneuf(Chef de Projet)", 
			"Charlie Marechal(Documentaliste)",
			"Nicolas Bourdin(Developpeur)",
			"Ewen Cousin(Developpeur)",
			"Jaweed Parwany(Developpeur)",
			"Julien Le Gall(Developpeur)\n\nadresse : prenom.nom.etu@univ-lemans.fr", 
		]
		about = AboutDialog.new
		about.set_program_name "ProjetPicrossL3"
		about.set_version "0.1"
		about.set_authors(auteurs)
		about.set_copyright "(c) Groupe B"
		about.run
		about.destroy


	end

end
