#un timer mais avec plein de trucs en plus
class Chronometre
	@text
	@minutes
	@secondes
	attr_reader :text
	
	# initialisation du chronométre
	def Chronometre.initialiser(notes)
		new(notes)
	end
	
	def initialize(notes)
		@minutes, @secondes = 0,0
		@text = Label.new.set_text(notes + " " + @minutes.to_s + ":" + @secondes.to_s)
	end
	
	
end
