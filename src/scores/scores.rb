# -*- encoding: utf-8 -*-
# SCORE.RB
# définition des classes Scores et Score
# MARECHAL
 

#################################
# IMPORTS                       #
#################################
load "src/commun/commun.rb"




#################################
# SCORE                         #
#################################
# mainteneur : MARECHAL

# Un score contient le temps mis pour la résolution d'une grille, sa taille et le nombre d'aide utilisé.
# Elle implemente Comparable pour pouvoir effectuer des comparaisons entre Score.
class Score
  include Comparable
  @temps
  @taille
  @nbrAide
  @points
  
  #temps réalisé
  attr_reader :temps
  #taille de la grille réalisée
  attr_reader :taille
  #nombre d'appels à l'aide effectués
  attr_reader :nbrAide
  #points, calculés à partir du temps, de la taille et du nombre d'appel à l'aide
  attr_reader :points
  



  private_class_method:new

  def Score.creer(taille, temps, aide)
    new(taille, temps, aide)
  end
  



  def initialize(taille, temps, aide)
    @temps = temps 
    @taille = taille
    @nbrAide = aide 
    @points = (((@taille*100**2) / (@nbrAide+1)) / (1+@temps)).to_i
  end
  



  # Méthode de comparaison de score
  # Nécessaire pour ordonner les listes et définir les meilleurs joueurs
  # Comparaison sur le temps
  def <=>(another)  
    another.points <=> self.points
  end




  ## 
  # Affichage du score
  def to_s()
    if @nbrAide == 0 then
      return "#{@temps} secondes sans appel à l'aide"
    elsif @nbrAide == 1 then
      return "#{@temps} secondes avec 1 unique appel à l'aide"
    else
      return "#{@temps} secondes avec #{@nbrAide} appels à l'aide"
    end
  end

end #end class






#################################
# SCORES                        #
#################################
# mainteneur : MARECHAL
#La classe Scores référencie les meilleurs scores pour chaque grille, ainis que le meilleur score de chaque joueur.
class Scores
  @scoreGrille
  @scoreProfil
  @max_score_par_grille


  # hashtable nom de grille => liste des meilleurs scores de la forme [nom_profil, score]
  attr_reader :scoreGrille
  # hashtable nom de profil => meilleur score du profil
  attr_reader :scoreProfil
  



  private_class_method :new

  def Scores.creer(max_score_par_grille = 3)
    return new(max_score_par_grille)
  end
  


  def initialize(max_score_par_grille)
    @max_score_par_grille = max_score_par_grille
    @scoreGrille = Hash.new
    @scoreProfil = Hash.new
  end
  



  # Ajoute aux scores des grilles, un id grille et son score, 
  #  avec le nom du joueur l'ayant réalisé. 
  #  Si les scores déjà entrés sont meilleurs, le score donné ne sera pas ajouté.
  def ajouterScoreALaGrille(grille_nom, score, profil_nom)    
    score_ajoute = [profil_nom, score]
    # si la grille a déjà des scores
    if @scoreGrille.has_key?(grille_nom) then
      @scoreGrille[grille_nom].push(score_ajoute)      # on ajoute
      @scoreGrille[grille_nom].sort! {|a,b| a[1] <=> b[1] }   # on trie
    # et s'il y en a trop, on enlève le dernier
      if @scoreGrille[grille_nom].size > @max_score_par_grille then
        score_retire = @scoreGrille[grille_nom].pop
      end

    # si pas de scores existant, on créé l'entrée
    else
      @scoreGrille[grille_nom] = [score_ajoute]
    end

    if score_ajoute != score_retire then
      Logs.add("Le score de " + profil_nom + " est dans les high scores de la grille #{grille_nom} !")
    end
  end
  



  # Ajoute aux scores des profil, un nom de profil et son score, 
  #  avec l'id de la grille réalisée. 
  def ajouterScoreAuProfil(grille_nom, score, profil_nom)    
    if @scoreProfil.has_key?(profil_nom) then
      if score > @scoreProfil[profil_nom].first then
        @scoreProfil[profil_nom] = [grille_nom, score]
      end
    else
      @scoreProfil[profil_nom] = [grille_nom, score]
    end
  end
  



  # Retourne la liste [meilleur score sur la grille donnée, nom du joueur]
  def scoresDeGrille(grille_nom)    
    return @scoreGrille[grille_nom]
  end
  



  # Retourne la liste [meilleur score du joueur donné, id de la grille]
  def scoreDuProfil(profil_nom)    
    return @scoreProfil[profil_nom]
  end




  ##
  # Marshal API : méthode de dump
  def marshal_dump
    [@scoreGrille, @scoreProfil, @max_score_par_grille]
  end
  
  # Marshal API : méthode de chargement
  def marshal_load(ary)
    @scoreGrille, @scoreProfil, @max_score_par_grille = ary
  end
	


end #end class
	
