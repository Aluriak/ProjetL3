# -*- encoding: utf-8 -*-
# TABLENOMBRE.RB
# définition de la classe TableNombre, utilisée par les Grilles.
# BOURNEUF
#
 
#################################
# IMPORTS			#
#################################





#################################
# TABLENOMBRE			#
#################################
# mainteneur : BOURNEUF

# Dans un Picross, deux tables de nombres coexistent : celle pour les lignes, et celle pour les colonnes,
# chacune d'elle indiquant le nombre de cases à noircir pour chaque ligne ou colonne.
# C'est l'information sur laquelle le joueur ou l'algorithme de résolution se basent pour résoudre le picross.
class TableNombre
  @type
  @matriceNombre

  # type de la table de nombre, égal à TableNombre.DeLigne ou TableNombre.DeColonne
  attr_reader :type

  
  ##
  # Description des deux types de table de nombre possible
  @@LIGNE = 0
  @@COLONNE = 1
  ##
  # Accesseur vers le type LIGNE
  def TableNombre.DeLigne() return @@LIGNE end
  def TableNombre.DeColonne() return @@COLONNE end


  ## 
  # Predicat sur le type de l'instance
  def deLigne?() return @type == @@LIGNE end
  def deColonne?() return @type == @@COLONNE end


  def initialize(taille, type)
    if TableNombre.DeLigne != type and TableNombre.DeColonne != type then
      raise "type de TableNombre doit être TableNombre.DeLigne ou TableNombre.DeColonne" 
    end
    @type = type
    @matriceNombre = Array.new(taille) { Array.new }
  end



  ##
  # Ajoute le nombre donné à la ligne ou la colonne d'index donné.
  # Lève des exception si l'index est invalide ou la ligne/colonne déjà pleine.
  def ajouterNombre(index, nombre)
    if index < 0 or index > self.taille then
      raise "La ligne/colonne #{index} n'existe pas ! (table de taille #{self.taille})"
    elsif @matriceNombre[index].size > (self.taille / 2 + 1) then
      raise "La #{self.deLigne? ? "ligne":"colonne" } #{index} est pleine : #{@matriceNombre[index]} de taille max #{self.taille / 2 + 1}."
    end
    @matriceNombre[index].push(nombre)
    #puts "nombre #{nombre} ajoutés à la #{self.deLigne? ? "ligne":"colonne" } #{index}"
    return self
  end



  ##
  # Retourne un tableau contenant les nombres de ligne/colonne d'index reçu.
  # Lève une exception si l'index est invalide.
  def nombresDeLaLigne(index)
    if index < 0 or index > self.taille then
      raise "La #{self.deLigne? ? "ligne":"colonne" } #{index} n'existe pas ! (table de taille #{self.taille})"
    end
    #puts "La #{self.deLigne? ? "ligne":"colonne" } d'index #{index} est #{@matriceNombre[index]}"
    return @matriceNombre[index]
  end


  # Le traitement est exactement le même, mais cela clarifie l'API.
  alias_method :nombresDeLaColonne, :nombresDeLaLigne




  ##
  # Retourne la taille du picross décrit par cette table de nombre
  def taille()
    return @matriceNombre.size
  end




  ## 
  # Retourne la largeur de la table.
  # Si c'est une table de type ligne, la largeur est variable et égale au nombre maximum de nombre contenu par les lignes
  # Si c'est une table de type colonne, la largeur est égale à la taille de la grille
  def largeur()
    if @type == @@LIGNE then
      return (@matriceNombre.max { |a,b| a.size <=> b.size }).size
    else
      return self.taille()
    end
  end




  ## 
  # Retourne la hauteur de la table.
  # Si c'est une table de type ligne, la hauteur est égale à la taille de la grille
  # Si c'est une table de type colonne, la hauteur est variable et égale au nombre maximum de nombre contenu par les colonnes
  def hauteur()
    if @type == @@COLONNE then
      return (@matriceNombre.max { |a,b| a.size <=> b.size }).size
    else
      return self.taille()
    end
  end




  ##
  # Etudie la table d'Etat reçue, et renvois deux TableNombre décrivant cette table d'état.
  def TableNombre.creerDepuis(tableEtat) 
    raise "Taille #{tableEtat.size} invalide !" if not Grille.tailles.include?(tableEtat.size)

    # IMPLÉMENTER LISTE DES COLONNES
    tableColonne = TableNombre.new(tableEtat.size, TableNombre.DeColonne)

    0.upto(tableEtat.size-1) do |col|   # pour chacune des colonnes
      nbNoirConsecutifs = 0             # compteur de noir (consécutifs)

      0.upto(tableEtat.size-1) do |row| # pour chacun des etat de la colonne
      	c = tableEtat[row][col]         # obtenir l'état de la case
        #print "(%i;%i:%s), " % [ row, col, c == Etat.Noir ? "Noire": "Blanc"]
        raise "Etat invalide !" if not Etat.include?(c)
      	if c != Etat.Noir then          # si c'est pas du noir
	  if nbNoirConsecutifs > 0 then	# et qu'il y a eu un noir avant
	    tableColonne.ajouterNombre(col, nbNoirConsecutifs)
      	    nbNoirConsecutifs = 0       # insérer un entier dans la liste de la ligne actuelle
	  end
	else
      	  nbNoirConsecutifs += 1        # si c'est pas blanc, c'est noir
          if row == tableEtat.size-1 then   # si des noirs n'ont pas encore été ajoutés en fin de colonne
            tableColonne.ajouterNombre(col, nbNoirConsecutifs)
            nbNoirConsecutifs = 0 
          end
	end
      end
      print "\n"
    end

    # IMPLÉMENTER LISTE DES LIGNES
    tableLigne = TableNombre.new(tableEtat.size, TableNombre.DeLigne)

    0.upto(tableEtat.size-1) do |row|   # pour chacune des lignes
      nbNoirConsecutifs = 0             # compteur de noir (consécutifs)

      0.upto(tableEtat.size-1) do |col| # pour chacun des etats de la ligne
        c = tableEtat[row][col]         # obtenir l'état de la case
        raise "Etat invalide !" if not Etat.include?(c)
        if c != Etat.Noir then          # si c'est pas du noir
          if nbNoirConsecutifs > 0 then	# et qu'il y a eu un noir avant
            tableLigne.ajouterNombre(row, nbNoirConsecutifs)
            nbNoirConsecutifs = 0       # insérer un entier dans la liste de la ligne actuelle
          end
        else
          nbNoirConsecutifs += 1        # si c'est pas blanc, c'est noir
          if col == tableEtat.size-1 then   # si des noirs n'ont pas encore été ajoutés en fin de ligne
            tableLigne.ajouterNombre(row, nbNoirConsecutifs)
            nbNoirConsecutifs = 0 
          end
        end
      end
    end


    # RETOURNER LES DEUX TABLE DE NOMBRE
    return tableLigne, tableColonne
  end 



  def to_s
    s = ""
    0.upto(self.taille) do |id|
      nombres = self.nombresDeLaLigne(id)
      s += nombres.to_s + "\n"
    end
    return s
  end


  # Marshal API : méthode de dump
  def marshal_dump
    [@type, @matriceNombre]
  end
  
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @type, @matriceNombre = ary
  end


end



#################################
# FUNCTIONS			#
#################################



