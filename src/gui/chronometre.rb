#un timer mais avec plein de trucs en plus
class Chronometre
	@text
	@minutes
	@secondes
	attr_reader :text

	# initialisation du chronométre
	def Chronometre.initialiser(refLabel)
		new(refLabel)
	end

	 #initialisation des attributs
	def initialize(refLabel)
		@minutes, @secondes = 0,0
		@finish, @pause = false, false

	end
	
	#mise en pause du chronomètre
	def enpause(){
		
		if @pause != false then
			@pause = true
		else
			@pause = false
		end

		
	end

	#Methode qui lance le chronomètre et affiche le temps
	def tictacmieux() 
		counter = 0
		while not @finish do
			if not @pause and counter >= 10 then
				counter = 0
				puts(@minutes.to_s + ":" + @secondes.to_s)
				@secondes += 1
				if @secondes == 60 then
					@secondes = 0
					@minutes += 1
				end
			end
			sleep(0.1)
			counter += 1
		end
		
		
	end


	#remise à zero du chronomètre
	def raz()
		@secondes = 0
		@minutes = 0
	end
end







c = Chronometre.new("plop")

c.tictacmieux




