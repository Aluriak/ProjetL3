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
class SuperGlaieul
  @o
  @p
  attr_accessor :o, :p
  def marshal_dump
    [o,p]
  end
  def marshal_load(ary)
    @o, @p = ary
  end
end
class Glaieul < SuperGlaieul
  @a
  @b

  attr_accessor :a, :b


  def marshal_dump
    return super + [a, b]
  end
  def marshal_load(ary)
    print ary
    super ary[0,2]
    @a, @b = ary[2], ary[3]
  end

end





# Creat object
c = Glaieul.new
c.a = 42
c.b = 'C6H12O6'
c.o = 0x44
c.p = 0x68


# dump object in testfile
File.open('testfile', 'w') do |f|
  f.puts Marshal.dump(c)
end


# Read an object in testfile
p = nil
File.open('testfile', 'r') do |f|
  p = Marshal.load(f.gets)
end
puts p.a.to_s + ":" + p.b.to_s + ":" + p.p.to_s + ":" + p.o.to_s







#################################
# FUNCTIONS			#
#################################



