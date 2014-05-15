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
    
=begin
    #Initialize toutes les cases à 0 (indicatif!!)  
    0.upto(@Longueur -1){|o|
      0.upto(@LargeurTabL -1){|p|
        @TabLignes[o][p] = 0
      }
    }
    
    0.upto(@Largeur -1){|o|
      0.upto(@LongueurTabC -1){|p|
        @TabColonnes[p][o] = 0
      }
    }

    #Genere la matrice TabLignes d'apres la GrillePicross
    0.upto(@Longueur -1){|o|
      tmp = 0
    
        0.upto(@Largeur -2){|p|
          itt = @LargeurTabL -1
        
          if (@GrillePicross[o][p] ==1)
            tmp+=1
          elsif (@GrillePicross[o][p] == 0 && tmp != 0)
            if (@TabLignes[o][@LargeurTabL-1] == 0)
              @TabLignes[o][@LargeurTabL-1] = tmp
              tmp = 0
            else
            
              while(@TabLignes[o][itt] != 0)
                itt -=1
              end
              (itt + 1).upto(@LargeurTabL -1){|b|
                @TabLignes[o][b-1] = @TabLignes[o][b]
              }

              @TabLignes[o][@LargeurTabL-1] = tmp
              tmp = 0

            end
          end
   
        }
      

        f = @Largeur-1
        itt = @LargeurTabL -1
        if (@GrillePicross[o][f] == 1)
          tmp+=1
        
          while(@TabLignes[o][itt] != 0)
            itt -=1
          end
          (itt + 1).upto(@LargeurTabL -1){|b|
            @TabLignes[o][b-1] = @TabLignes[o][b]
          }
        
          @TabLignes[o][@LargeurTabL-1] = tmp

        elsif(@GrillePicross[o][f] == 0 && tmp != 0)
          if (@TabLignes[o][@LargeurTabL-1] == 0)
            @TabLignes[o][@LargeurTabL-1] = tmp
          else
          
            while(@TabLignes[o][itt] != 0)
              itt -=1
            end
            (itt + 1).upto(@LargeurTabL-1){|b|
              @TabLignes[o][b-1] = @TabLignes[o][b]
            }
            @TabLignes[o][@LargeurTabL-1] = tmp
          end
        end
    }
  
    #Genere la matrice TabColonnes
    
    0.upto(@Largeur-1){|o|
      tmp = 0
    
        0.upto(@Longueur -2){|p|
          itt = @LongueurTabC -1
        
          if (@GrillePicross[p][o] ==1)
            tmp+=1
          elsif (@GrillePicross[p][o] == 0 && tmp != 0)
            if (@TabColonnes[@LongueurTabC-1][o] == 0)
              @TabColonnes[@LongueurTabC-1][o] = tmp
              tmp = 0
            else
            
              while(@TabColonnes[itt][o] != 0)
                itt -=1
              end
              (itt + 1).upto(@LongueurTabC -1){|b|
                @TabColonnes[b-1][o] = @TabColonnes[b][o]
              }

              @TabColonnes[@LongueurTabC-1][o] = tmp
              tmp = 0

            end
          end
   
        }
      
        f = @Longueur-1
        itt = @LongueurTabC -1
        if (@GrillePicross[f][o] == 1)
          tmp+=1
        
          while(@TabColonnes[itt][o] != 0)
            itt -=1
          end
          (itt + 1).upto(@LongueurTabC -1){|b|
            @TabColonnes[b-1][o] = @TabColonnes[b][o]
          }
        
          @TabColonnes[@LongueurTabC-1][o] = tmp

        elsif(@GrillePicross[f][o] == 0 && tmp != 0)
          if (@TabColonnes[@LongueurTabC-1][o] == 0)
            @TabColonnes[@LongueurTabC-1][o] = tmp
          else
          
            while(@TabColonnes[itt][o] != 0)
              itt -=1
            end
            (itt + 1).upto(@LongueurTabC-1){|b|
              @TabColonnes[b-1][o] = @TabColonnes[b][o]
            }
            @TabColonnes[@LongueurTabC-1][o] = tmp
          end
        end
    }
=end 
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
        @TabAideDispo.push("Regardez à la ligne " + num_ligne.to_s() + ",\nVous pouvez colorier toutes les cases !! :)")
      elsif(somme == @Largeur - 1)
        @TabAideDispo.push("Regardez à la ligne " + num_ligne.to_s() + "\nFACILE non ? :)")
      elsif(val_max > @Largeur / 2)
        @TabAideDispo.push("Regardez à la ligne " + num_ligne.to_s() + ",\nLa case du milieu est forcement coloriée !! :)")
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
        @TabAideDispo.push("Regardez à la colonne " + num_colonne.to_s() + ",\nVous pouvez colorier toutes les cases !! :)")
      elsif(somme == @Hauteur-1)
        @TabAideDispo.push("Regardez à la colonne " + num_colonne.to_s() + "\nFACILE non ? :)")
      elsif(val_max > @Hauteur / 2)
        @TabAideDispo.push("Regardez à la colonne " + num_colonne.to_s() + ",\nLa case du milieu est forcement coloriée !! :)")
      end
    }



    @TabAideDispo.push("Il n'y a aucune aide dispo") if @TabAideDispo.size == 0
    Logs.add(@TabAideDispo)
    return @TabAideDispo
  end
  






  def aideDeNiveau2

  i = 0
    0.upto(@Longueur-1){|o|
      somme = 0
      0.upto(@LargeurTabL - 1){|p|
        somme += @TabLigne.nombresDeLaLigne(o)[p]
        
          if(somme == @Largeur)
            val = o + 1
            #print "Vous pouvez appliquer la technique "Le baton de feu" sur la ligne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'Le baton de feu' sur la ligne " + val.to_s()
            i += 1
          elsif(somme == @Largeur - 1)
            val = o + 1
            #print "Vous pouvez appliquer la technique 'La cave à vin' la ligne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'La cave à vin' sur la ligne " + val.to_s()
            i += 1
          elsif(@TabLigne.nombresDeLaLigne(o)[p] > @Largeur / 2)
            val = o + 1
            #print "Vous pouvez appliquer la technique "L'ilot bleu" sur la ligne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'L'ilot bleu' sur la ligne " + val.to_s()
            i += 1
          end
      }
      
       if(somme == 0) 
         val = o + 1
         #print"Vous pouvez appliquer la technique "Le desert aride" sur la ligne " + val.to_s() + "\n"
         @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'Le desert aride' sur la ligne " + val.to_s()
         i += 1
       end
    }

	 0.upto(@Largeur-1){|o|
      somme = 0
      0.upto(@Longueur - 1){|p|
        somme += @TabColonne[p][o] 
          if(somme == @Longueur)
            val = o + 1
            #print "Vous pouvez appliquer la technique "Le baton de feu" sur la colonnne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'Le baton de feu' sur la colonne " + val.to_s() 
            i += 1
          elsif(somme == @Longueur - 1)
            val = o + 1
            #print "Vous pouvez appliquer la technique 'La cave à vin' sur la colonnne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'La cave à vin' sur la colonne " + val.to_s()
            i += 1
          elsif(@TabColonne[p][o] > @Longueur / 2)
            val = o + 1
            #print "Vous pouvez appliquer la technique "L'ilot bleu" sur la colonnne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'L'ilot bleu' sur la colonne " + val.to_s()
            i += 1
          end
      }
       if(somme == 0) 
         val = o + 1
         #print "Vous pouvez appliquer la technique "Le desert aride" sur la colonnne " + val.to_s() + "\n"
         @TabAideDispo[i] = "Vous pouvez appliquer la technique \n'Le desert aride' sur la colonne " + val.to_s()
         i += 1
       end
    }
    
    if(i == 0)
		@TabAideDispo[i] = "Il n'y a aucune aide dispo\n"
		#print @TabAideDispo[0]
	else
		r = rand(0..i-1)
		#print @TabAideDispo[r]
	end
    return @TabAideDispo
  end
end
