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

# Une Grille Jouable est une grille Racine avec une matrice d'état.
# de Picross modifiée par l'utilisateur.
class GrilleJouable < GrilleRacine
  @matriceDeJeu

  # matrice carrée d'états de cases du picross
  attr_reader :matriceDeJeu



  #initialisation de la grille
  def initialize(taille, nom = nil, tableLigne = nil, tableColonne = nil)
    super(taille, nom, tableLigne, tableColonne)
    @matriceDeJeu = Array.new(taille) { Array.new(taille) {Etat.Blanc} }
  end




  ##
  # Attend la taille de la grille, et optionnellement les matrices 
  # de ligne/colonne et le nom. 
  # Si les matrices de lignes et colonnes sont renseignées, 
  # elles sont utilisées telles quelles.
  # Sinon, elles sont remplacées par des matrices initialisées aléatoirement.
  # Le nom généré aléatoirement se base sur la taille et la date courante.
  def GrilleJouable.deTaille(taille, nom = nil, 
  			    tableLigne = nil, tableColonne = nil)
    raise "Taille #{taille} non définie" if not Grille.tailles.include?(taille)
    return new(taille, nom, tableLigne, tableColonne)
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
  



  # Bascule l'état de la case située en (i, j) vers l'état donné.
  # Si l'état est nil ou laissé par défaut, l'état de la case passera 'au suivant' 
  # (voir ordonnancement de la classe Etat)
  # Lève des exceptions en cas d'état ou de coordonées non valides
  def basculer(i, j, etat = nil)
    # Assertion
    #raise "Etat #{etat} non valide" if not (Etat.include?(etat) and etat != nil)
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
    # Etudie les tables de nombre attendues et celle générées depuis 
    # la grille courante. Si elles sont identiques, la grille est considérée
    # comme justement remplie.
    actuelleColonne, actuelleLigne = 
      TableNombre.creerDepuis(@matriceDeJeu)
    tables_identiques = true
    # comparaison entre tables attendues et actuelles
    actuelleColonne.largeur.times do |col_id|
      nb_actuels = actuelleColonne.nombresDeLaColonne(col_id)
      nb_attendu = @tableColonne.nombresDeLaColonne(col_id)
      tables_identiques = nb_actuels == nb_attendu
      puts nb_actuels
      puts nb_attendu
      puts nb_actuels == nb_attendu
    end
    if tables_identiques then 
      actuelleLigne.hauteur.times do |row_id|
        nb_actuels = actuelleColonne.nombresDeLaColonne(row_id)
        nb_attendu = @tableColonne.nombresDeLaColonne(row_id)
        tables_identiques = nb_actuels == nb_attendu
      end
    end
    return tables_identiques
  end


  ##
  # Marshal API : méthode de dump
  def marshal_dump
    # concaténation de la structure de la classe mère et de self
    # l'item de self est placé en dernière place de tableau
    super + [matriceDeJeu]
  end

  ##
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    # le dernier item est pour self
    @matriceDeJeu = ary.pop
    # les autres sont pour la classe-mère
    super ary
  end
end




