# -*- encoding: utf-8 -*-
# CHRONOMETRE.RB
# définition du chronomètre utilisé par la GUI.
# BOURNEUF
#
 
#################################
# IMPORTS			#
#################################




#################################
# CHRONOMETRE           	#
#################################
# mainteneur : BOURNEUF
#
# Peut être lancé, stoppé, et remis à zéro.
# Nécessite une référence à un Gtk::Label, qui sera mis à jour chaque seconde.
# Affiche le temps au format H:M:S
class Chronometre
  @reflabel
  @sec
  @pause
  @chrono
  @dixieme


  def initialize(ref_label)
    @sec = 0
    @dixieme = 0      
    @ref_label = ref_label
    @pause = true
    majlabel()
  end

  ##
  # Relance le chronomètre
  def start()
    if @pause then 
      @pause = false
      @chrono = Thread.new { self.run() }
    end
  end

  ##
  # Stoppe le chronomètre
  def stop()
    if not @pause then 
      @pause = true
      @chrono.join()
    end
  end

  ##
  # Remet le chronomètre à zéro.
  def raz()
        @sec = 0
        @dixieme = 0
        majlabel()
  end

  ##
  # Predicat vrai si chronomètre actuellement en pause.
  def paused?()
    return @pause
  end


  ##
  # Compte les secondes et met le label référencé à jour
  def run()
    # garder en mémoire les dixièmes de seconde permet de diminuer la perte de temps induite par la pause.
    while not @pause do 
      if @dixieme == 10 then
        @dixieme = 0
        @sec += 1
        majlabel()
      end
      @dixieme += 1
      sleep(0.1)
    end
  end


  ##
  # Met à jour le texte du label.
  def majlabel()
    s, m = @sec % 60, @sec / 60
    h = m / 60
    m = m % 60
    @ref_label.set_text("%02d:%02d:%02d" % [h, m, s])
  end 
  private :majlabel

end




