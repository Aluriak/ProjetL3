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
    elsif @matriceNombre[index].size > (self.taille / 2) then
      raise "La ligne/colonne #{index} est pleine !"
    end
    @matriceNombre[index].push(nombre)
    return self
  end



  ##
  # Retourne un tableau contenant les nombres de l'igne/colonne d'index reçu.
  # Lève une exception si l'index est invalide.
  def nombresDeLaLigne(index)
    if index < 0 or index > self.taille then
      raise "La ligne/colonne #{index} n'existe pas ! (table de taille #{self.taille})"
    end
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
    # IMPLÉMENTER LISTE DES COLONNES
    tableColonne = TableNombre.new(tableEtat.size, TableNombre.DeColonne)

    tableEtat.size.times do |col|       # pour chacune des colonnes
      nbNoirConsecutif = 0              # compteur de noir

      tableEtat.size.times do |row|     # pour chacun des etat de la colonne
      	c = tableEtat[row][col]         # obtenir l'état de la case
        raise "Etat invalide !" if not Etat.include?(c)
      	if c != Etat.Noir then          # si c'est pas du noir
	  if nbNoirConsecutif > 0 then	# et qu'il y a eu un noir avant
	    tableColonne.ajouterNombre(col, nbNoirConsecutif)
      	    nbNoirConsecutif = 0        # insérer un entier dans la liste de la ligne actuelle
	  end						
	else
      	  nbNoirConsecutif += 1          # si c'est pas blanc, c'est noir
	end
      end
      # si la dernière case était un noir, cela n'a pas été ajouté à la liste
      # on intègre donc le nombre de dernières cases noires
      if nbNoirConsecutif > 0 then			
        tableColonne.ajouterNombre(tableColonne.taille-1, nbNoirConsecutif)
      	nbNoirConsecutif = 0 
      end						
    end

    # IMPLÉMENTER LISTE DES LIGNES
    tableLigne = TableNombre.new(tableEtat.size, TableNombre.DeLigne)

    tableEtat.size.times do |row|       # pour chacune des lignes
      nbNoirConsecutif = 0              # compteur de noir

      tableEtat.size.times do |col|     # pour chacun des etats de la ligne
      	c = tableEtat[row][col]         # obtenir l'état de la case
        raise "Etat invalide !" if not Etat.include?(c)
      	if c != Etat.Noir then          # si c'est pas du noir
	  if nbNoirConsecutif > 0 then	# et qu'il y a eu un noir avant
	    tableLigne.ajouterNombre(row, nbNoirConsecutif)
      	    nbNoirConsecutif = 0        # insérer un entier dans la liste de la ligne actuelle
	  end						
	else
          nbNoirConsecutif += 1          # si c'est pas blanc, c'est noir
	end
      end
      # si la dernière case était un noir, cela n'a pas été ajouté à la liste
      # on intègre donc le nombre de dernières cases noires
      if nbNoirConsecutif > 0 then			
        tableLigne.ajouterNombre(tableLigne.taille-1, nbNoirConsecutif)
      	nbNoirConsecutif = 0 
      end						
    end

    # RETOURNER LES DEUX TABLE DE NOMBRE
    return tableLigne, tableColonne
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



