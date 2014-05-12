#Encoding: UTF-8
#class GrillePicross
#

load "Commun.rb"

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
  
  
  
  def Aide.Creer(uneGrille)
    new(uneGrille)
  end
  
  def initialize(uneGrille)
    @GrillePicross = uneGrille
    @Largeur = @GrillePicross.length
    @Longueur = @GrillePicross[0].length
 
    @LargeurTabL = (@Largeur / 2) + (@Largeur % 2)
    @LongueurTabC = (@Longueur / 2) + (@Longueur % 2)
    
    @TabLignes = Array.new(@Longueur){Array.new(@LargeurTabL)}
    @TabColonnes = Array.new(@LongueurTabC){Array.new(@Largeur)}
    @TabAideDispo = Array.new()

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
    
  end

  def VoirMatrices

     #Affiche le Picross

    print "\n"
    print "Matrices des colonnes : \n"
    0.upto(@LongueurTabC-1){|o|
      0.upto(@Largeur-1){|p|
         print @TabColonnes[o][p]
      }
       print "\n"
    }
    
    print "\n"
    print "Matrices des Lignes : \n"
    0.upto(@Longueur -1){|o|
      0.upto(@LargeurTabL -1){|p|
         print @TabLignes[o][p]
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
    return @TabLignes
  end
  
  def getTabColonnes
    return @TabColonnes
  end
  
  #Définition des aides possible à partir de la matrice TabLignes

  def AideDeNiveau1
    i = 0
    0.upto(@Longueur-1){|o|
      somme = 0
      0.upto(@LargeurTabL - 1){|p|
        somme += @TabLignes[o][p] 
          if(somme == @Largeur)
            val = o + 1
            #print "Oui, regardez à la ligne " + val.to_s() + ", vous pouvez colorier toutes les cases !! :) \n"
            @TabAideDispo[i] = "Oui, regardez à la ligne " + val.to_s() + ", vous pouvez colorier toutes les cases !! :)"
            i += 1
          elsif(somme == @Largeur - 1)
            val = o + 1
            #print "Oui, regardez à la ligne " + val.to_s() + " ... FACILE non ? :) \n"
            @TabAideDispo[i] = "Oui, regardez à la ligne " + val.to_s() + " ... FACILE non ? :)"
            i += 1
          elsif(@TabLignes[o][p] > @Largeur / 2)
            val = o + 1
            #print "Oui, regardez à la ligne " + val.to_s() + ", la case du milieu est forcement coloriée !! :) \n"
            @TabAideDispo[i] = "Oui, regardez à la ligne " + val.to_s() + ", la case du milieu est forcement coloriée !! :)"
            i += 1
          end
      }
       if(somme == 0) 
         val = o + 1
         #print"Oui, regardez à la ligne " + val.to_s() + " ... HYPER simple :) \n"
         @TabAideDispo[i] = "Oui, regardez à la ligne " + val.to_s() + " ... HYPER simple :)"
         i += 1
       end
    }

	 0.upto(@Largeur-1){|o|
      somme = 0
      0.upto(@LongueurTabC - 1){|p|
        somme += @TabColonnes[p][o] 
          if(somme == @Longueur)
            val = o + 1
            #print "Oui, regardez à la colonne " + val.to_s() + ", vous pouvez colorier toutes les cases !! :) \n"
            @TabAideDispo[i] = "Oui, regardez à la colonne " + val.to_s() + ", vous pouvez colorier toutes les cases !!"
            i += 1
          elsif(somme == @Longueur - 1)
            val = o + 1
            #print "Oui, regardez à la colonne "+ val.to_s() + " \n"
            @TabAideDispo[i] = "Oui, regardez à la colonne "+ val.to_s() + ", vous pouvez colorier toutes les cases sauf une !!"
            i += 1
          elsif(@TabColonnes[p][o] > @Longueur / 2)
            val = o + 1
            #print "Oui, regardez à la colonne " + val.to_s() + ", la case du milieu est forcement coloriée !! :) \n"
            @TabAideDispo[i] = "Oui, regardez à la colonne " + val.to_s() + ", la case du milieu est forcement coloriée !!"
            i += 1
          end
      }
       if(somme == 0) 
         val = o + 1
         #print"Oui, regardez à la colonne " + val.to_s() + " ... HYPER simple :) \n"
         @TabAideDispo[i] = "Oui, regardez à la colonne " + val.to_s() + ", aucune case n'est coloriée !!"
         i += 1
       end
    }

    if(i == 0)
		@TabAideDispo[i] = "Il n'y a aucune aide dispo"
		print @TabAideDispo[0]
	else
		r = rand(0..i-1)
		print @TabAideDispo[r]
	end
    
  end
  
  def AideDeNiveau2

  i = 0
    0.upto(@Longueur-1){|o|
      somme = 0
      0.upto(@LargeurTabL - 1){|p|
        somme += @TabLignes[o][p]
        
          if(somme == @Largeur)
            val = o + 1
            #print "Vous pouvez appliquer la technique "Le baton de feu" sur la ligne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique 'Le baton de feu' sur la ligne " + val.to_s()
            i += 1
          elsif(somme == @Largeur - 1)
            val = o + 1
            #print "Vous pouvez appliquer la technique 'La cave à vin' la ligne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique 'La cave à vin' sur la ligne " + val.to_s()
            i += 1
          elsif(@TabLignes[o][p] > @Largeur / 2)
            val = o + 1
            #print "Vous pouvez appliquer la technique "L'ilot bleu" sur la ligne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique 'L'ilot bleu' sur la ligne " + val.to_s()
            i += 1
          end
      }
      
       if(somme == 0) 
         val = o + 1
         #print"Vous pouvez appliquer la technique "Le desert aride" sur la ligne " + val.to_s() + "\n"
         @TabAideDispo[i] = "Vous pouvez appliquer la technique 'Le desert aride' sur la ligne " + val.to_s()
         i += 1
       end
    }

	 0.upto(@Largeur-1){|o|
      somme = 0
      0.upto(@LongueurTabC - 1){|p|
        somme += @TabColonnes[p][o] 
          if(somme == @Longueur)
            val = o + 1
            #print "Vous pouvez appliquer la technique "Le baton de feu" sur la colonnne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique 'Le baton de feu' sur la colonne " + val.to_s()
            i += 1
          elsif(somme == @Longueur - 1)
            val = o + 1
            #print "Vous pouvez appliquer la technique 'La cave à vin' sur la colonnne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique 'La cave à vin' sur la colonne " + val.to_s()
            i += 1
          elsif(@TabColonnes[p][o] > @Longueur / 2)
            val = o + 1
            #print "Vous pouvez appliquer la technique "L'ilot bleu" sur la colonnne " + val.to_s() + "\n"
            @TabAideDispo[i] = "Vous pouvez appliquer la technique 'L'ilot bleu' sur la colonne " + val.to_s()
            i += 1
          end
      }
       if(somme == 0) 
         val = o + 1
         #print "Vous pouvez appliquer la technique "Le desert aride" sur la colonnne " + val.to_s() + "\n"
         @TabAideDispo[i] = "Vous pouvez appliquer la technique 'Le desert aride' sur la colonne " + val.to_s()
         i += 1
       end
    }
    
    if(i == 0)
		@TabAideDispo[i] = "Il n'y a aucune aide dispo"
		print @TabAideDispo[0]
	else
		r = rand(0..i-1)
		print @TabAideDispo[r]
	end
  end
end
