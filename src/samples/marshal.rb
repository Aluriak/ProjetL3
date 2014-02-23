# -*- encoding: utf-8 -*-
# MARSHAL
# Example of use of Marshal module
# BOURNEUF
#
 
#################################
# IMPORTS			#
#################################





#################################
# CLASSNAME			#
#################################
# mainteneur : BOURNEUF
class Glaieul
  @a
  @b

  attr_accessor :a, :b


  def marshal_dump
    [a, b]
  end
  def marshal_load(ary)
    @a, @b = ary
  end

end





# Creat object
c = Glaieul.new
c.a = 42
c.b = 'C6H12O6'


# dump object in testfile
File.open('testfile', 'w') do |f|
  f.puts Marshal.dump(c)
end


# Read an object in testfile
p = nil
File.open('testfile', 'r') do |f|
  p = Marshal.load(f.gets)
end
puts p.a.to_s + ":" + p.b.to_s







#################################
# FUNCTIONS			#
#################################



