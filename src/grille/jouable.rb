# -*- encoding: utf-8 -*-
# JOUABLE.RB
# définition de la classe GrilleJouable
# BOURNEUF
 
#################################
# IMPORTS			#
#################################
load "src/commun/commun.rb"
load "src/grille/racine.rb"



#################################
# JOUABLE			#
#################################
# mainteneur : BOURNEUF

# Une Grille Jouable est une grille Racine avec une matrice d'état et quelques données permettant de gérer les sauvegardes.
# Un Picross modifié par l'utilisateur.
class GrilleJouable < GrilleRacine
  @matriceDeJeu
  @nom_de_sauvegarde
  @temps_ecoule

  # matrice carrée d'états de cases du picross
  attr_reader :matriceDeJeu
  # nom sous lequel la grille jouable est connue
  attr_accessor :nom_de_sauvegarde
  # temps écoulé depuis que l'utilisateur planche sur cette grille, en secondes
  attr_accessor :temps_ecoule


  #initialisation de la grille
  def initialize(taille, nom = nil, tableLigne = nil, tableColonne = nil, nom_de_sauvegarde = nil, temps_ecoule = 0)
    super(taille, nom, tableLigne, tableColonne)
    @nom_de_sauvegarde = nom_de_sauvegarde
    @temps_ecoule = temps_ecoule
    @matriceDeJeu = Array.new(taille) { Array.new(taille) {Etat.Blanc} }
    Logs.add("Grille Jouable créée : taille=%i, nom=%s, nom_de_sauvegarde=%s, temps_ecoule=%i" % [taille, nom, nom_de_sauvegarde, temps_ecoule])
  end




  ##
  # Attend la taille de la grille, et optionnellement les matrices 
  # de ligne/colonne et le nom. 
  # Si les matrices de lignes et colonnes sont renseignées, 
  # elles sont utilisées telles quelles.
  # Sinon, elles sont remplacées par des matrices initialisées aléatoirement.
  # Le nom généré aléatoirement se base sur la taille et la date courante.
  def GrilleJouable.deTaille(taille, nom = nil, 
  	                      tableLigne = nil, tableColonne = nil, 
                              nom_de_sauvegarde = nil, temps_ecoule = 0)
    raise "Taille #{taille} non définie" if not Grille.tailles.include?(taille)
    return new(taille, nom, tableLigne, tableColonne, nom_de_sauvegarde, temps_ecoule)
  end




  ## 
  # Retourne une GrilleJouable créée depuis la GrilleRacine envoyée en argument
  def GrilleJouable.creerDepuis(grilleRacine)
    # création et retour de la grille
    return GrilleJouable.new(grilleRacine.taille,
      grilleRacine.nom,
      # recopie profonde des matrices de facteurs
      Marshal.load(Marshal.dump(grilleRacine.tableLigne)),
      Marshal.load(Marshal.dump(grilleRacine.tableColonne))
    )
  end
  



  ##
  # Retourne une grille jouable créé à partir de la table d'état reçue.
  def GrilleJouable.creerDepuisTableEtat(table)
    tableL, tableC = TableNombre.creerDepuis(table)
    return GrilleJouable.creerDepuis(GrilleRacine.deTaille(table.size, nil, tableL, tableC))
  end





  # Bascule l'état de la case située en (i, j) vers l'état donné.
  # Si l'état est nil ou laissé par défaut, l'état de la case passera 'au suivant' 
  # (voir ordonnancement de la classe Etat)
  # Lève des exceptions en cas d'état ou de coordonées non valides
  def basculer(i, j, etat = nil)
    # Assertion
    raise "Coordonnées(#{x},#{y}) non valide" if not (i.between?(0, @matriceDeJeu.size) and j.between?(0, @matriceDeJeu.size))
    # Bascule
    if etat == nil then
      @matriceDeJeu[i][j] = Etat.suivant(@matriceDeJeu[i][j])
    else
      @matriceDeJeu[i][j] = etat
    end
  end




  ##
  # Renvoie l'état de la case située en (i, j)
  def etat(i, j)
	return @matriceDeJeu[i][j]
  end




  ##
  # Prédicat sur l'état actuel du jeu.
  # :return: Vrai si la matrice de jeu correspond aux facteurs
  def terminee?()
    #puts "BEGIN"
    # Etudie les tables de nombre attendues et celle générées depuis 
    # la grille courante. Si elles sont identiques, la grille est considérée
    # comme justement remplie.
    actuelleLigne, actuelleColonne = TableNombre.creerDepuis(@matriceDeJeu)
    tables_identiques = true
    # comparaison entre tables attendues et actuelles
    actuelleColonne.largeur.times do |col_id|
      nb_actuels = actuelleColonne.nombresDeLaColonne(col_id)
      nb_attendu = @tableColonne.nombresDeLaColonne(col_id)
      #puts "col_id     : " + col_id.to_s 
      #puts "col_actuels: " + nb_actuels.to_s
      #puts "col_attendu: " + nb_attendu.to_s
      tables_identiques = (tables_identiques and (nb_actuels == nb_attendu))
    end

    #puts "MIDDLE"

    if tables_identiques then 
      actuelleLigne.hauteur.times do |row_id|
        nb_actuels = actuelleLigne.nombresDeLaLigne(row_id)
        nb_attendu = @tableLigne.nombresDeLaLigne(row_id)
        #puts "row_id     : " + row_id.to_s 
        #puts "row_actuels: " + nb_actuels.to_s
        #puts "row_attendu: " + nb_attendu.to_s
        tables_identiques = (tables_identiques and nb_actuels == nb_attendu)
      end
    end
    #puts "END WITH " + tables_identiques.to_s
    return tables_identiques
  end


  ##
  # Marshal API : méthode de dump
  def marshal_dump
    # concaténation de la structure de la classe mère et de self
    # l'item de self est placé en dernière place de tableau
    super + [@matriceDeJeu, @nom_de_sauvegarde, @temps_ecoule]

  
  end

  ##
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    # les derniers items sont pour self
    @temps_ecoule = ary.pop
    @nom_de_sauvegarde = ary.pop
    @matriceDeJeu = ary.pop
    # les autres sont pour la classe-mère
    super ary
  end
end




