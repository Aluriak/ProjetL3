# -*- encoding: utf-8 -*-
# AIDE.RB
# implémentation des aides au picross.
# LEGALL
#


#################################
# IMPORTS                       #
#################################
load "src/commun/commun.rb"



#################################
# AIDE                          #
#################################
# mainteneur : LE GALL

class Aide

  
  @Largeur #Largeur de la grille (x)
  @longueur #Hauteur de la grille (y)
  @GrillePicross #Grille de Picross
  @TabLignes #Matrice pour les lignes
  @TabColonnes #Matrice pour les colonnes
  @LargeurTabL
  @LongueurTabC
  
  @TabAideDispo
  
  attr :Largeur, true 
  attr :Longueur, true 
  attr :GrillePicross, true 
  attr :TabLignes, true 
  attr :TabColonnes, true
  attr :LargeurTabL, true
  attr :LongueurTabC, true
  attr :TabAideDispo, true
    
  private_class_method :new
  
  
  
  def Aide.creer(uneGrille)
    new(uneGrille)
  end
  
  def initialize(uneGrille)
    @GrillePicross = uneGrille
    @Largeur = @GrillePicross.taille
    @Hauteur = @GrillePicross.taille
 
    #@LargeurTabL = (@Largeur / 2) + (@Largeur % 2)
    #@LongueurTabC = (@Longueur / 2) + (@Longueur % 2)
    
    @TabLigne = uneGrille.tableLigne
    @TabColonne = uneGrille.tableColonne
    @TabAideDispo = Array.new()
    

  end

  def VoirMatrices

     #Affiche le Picross

    print "\n"
    print "Matrices des colonnes : \n"
    0.upto(@Longueur-1){|o|
      0.upto(@Largeur-1){|p|
         print @TabColonne[o][p]
      }
       print "\n"
    }
    
    print "\n"
    print "Matrices des Lignes : \n"
    0.upto(@Longueur -1){|o|
      0.upto(@Largeur -1){|p|
         print @TabLigne.nombresDeLaLigne(o)[p]
      }
      print "\n"
    }
    
        print "\n"
    print "Grille picross : \n"
    0.upto(@Longueur -1){|o|
      0.upto(@Largeur -1){|p|
         print @GrillePicross[o][p]
      }
      print "\n"
    }
  

  end
  
  def getTabLignes
    return @TabLigne
  end
  
  def getTabColonnes
    return @TabColonne
  end
  
  #Définition des aides possible à partir de la matrice TabLignes

  def aideDeNiveau1
    # TABLE LIGNE
    0.upto(@TabLigne.hauteur-1){ |o|
      num_ligne = o + 1
      nombres = @TabLigne.nombresDeLaLigne(o)
      somme = nombres.inject { |val, sum| sum += val }
      val_max = @TabLigne.nombresDeLaLigne(o).max
      val_max = 0 if val_max == nil # cas où la ligne est vide
      if(somme == @Largeur)
        @TabAideDispo.push("Regardez à la ligne " + num_ligne.to_s() + ",\nVous pouvez colorier toutes les cases !!")
      elsif(somme == @Largeur - 1)
        @TabAideDispo.push("Regardez à la ligne " + num_ligne.to_s() + "\nFACILE non ?")
      elsif(val_max > @Largeur / 2)
        @TabAideDispo.push("Regardez à la ligne " + num_ligne.to_s() + ",\nLa case du milieu est forcement coloriée !!")
      elsif(nombres > @Largeur / 2)
        @TabAideDispo.push("Regardez à la ligne" + num_ligne.to_s()+",\nVous pouvez colorier la premiere case !!")
      end
    }


    # TABLE COLONNE
    0.upto(@TabColonne.hauteur-1){ |o|
      num_colonne = o + 1
      nombres = @TabColonne.nombresDeLaColonne(o)
      somme = nombres.inject { |val, sum| sum += val }
      val_max = @TabColonne.nombresDeLaColonne(o).max
      val_max = 0 if val_max == nil # cas où la colonne est vide
      if(somme == @Hauteur)
        @TabAideDispo.push("Regardez à la colonne " + num_colonne.to_s() + ",\nVous pouvez colorier toutes les cases !!")
      elsif(somme == @Hauteur-1)
        @TabAideDispo.push("Regardez à la colonne " + num_colonne.to_s() + "\nFACILE non ?")
      elsif(val_max > @Hauteur / 2)
        @TabAideDispo.push("Regardez à la colonne " + num_colonne.to_s() + ",\nLa case du milieu est forcement coloriée !!")
      elsif(nombres > @Hauteur / 2)
        @TabAideDispo.push("Regardez à la ligne" + num_colonne.to_s()+",\nVous pouvez colorier la premiere case !!")
      end
    }

    @TabAideDispo.push("Il n'y a aucune aide dispo") if @TabAideDispo.size == 0
    Logs.add(@TabAideDispo)
    return @TabAideDispo
  end
  






  def aideDeNiveau2
    # TABLE LIGNE
    0.upto(@TabLigne.hauteur-1){ |o|
      num_ligne = o + 1
      nombres = @TabLigne.nombresDeLaLigne(o)
      somme = nombres.inject { |val, sum| sum += val }
      val_max = @TabLigne.nombresDeLaLigne(o).max
      val_max = 0 if val_max == nil # cas où la ligne est vide
      if(somme == @Largeur)
        @TabAideDispo.push("Vous pouvez appliquer la technique \n'Le baton de feu' sur la ligne " + num_ligne.to_s())
      elsif(somme == @Largeur - 1)
        @TabAideDispo.push("Vous pouvez appliquer la technique \n'La cave à vin' sur la ligne " + num_ligne.to_s())
      elsif(val_max > @Largeur / 2)
        @TabAideDispo.push("Vous pouvez appliquer la technique \n'L'ilot bleu' sur la ligne " + num_ligne.to_s())
      elsif(nombres.size > @Largeur / 2)
        @TabAideDispo.push("Regardez à la ligne" + num_ligne.to_s()+",\nVous pouvez colorier la premiere case !!")
      end
    }
 
	# TABLE COLONNE
    0.upto(@TabColonne.hauteur-1){ |o|
      num_colonne = o + 1
      nombres = @TabColonne.nombresDeLaColonne(o)
      somme = nombres.inject { |val, sum| sum += val }
      val_max = @TabColonne.nombresDeLaColonne(o).max
      val_max = 0 if val_max == nil # cas où la colonne est vide
      if(somme == @Hauteur)
        @TabAideDispo.push("Vous pouvez appliquer la technique \n'Le baton de feu' sur la colonne " + num_colonne.to_s())
      elsif(somme == @Hauteur-1)
        @TabAideDispo.push("Vous pouvez appliquer la technique \n'La cave à vin' sur la colonne " + num_colonne.to_s())
      elsif(val_max > @Hauteur / 2)
        @TabAideDispo.push("Vous pouvez appliquer la technique \n'L'ilot bleu' sur la colonne " + num_colonne.to_s())
      elsif(nombres.size > @Hauteur / 2)
        @TabAideDispo.push("Regardez à la ligne" + num_colonne.to_s()+",\nVous pouvez colorier la premiere case !!")
      end
    }

    @TabAideDispo.push("Il n'y a aucune aide dispo") if @TabAideDispo.size == 0
    Logs.add(@TabAideDispo)
    return @TabAideDispo
	
  end
end
