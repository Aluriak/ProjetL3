

class A
  @p
  attr_accessor :p

  def initialize(p)
    self.p = p
  end

  def A.creerDepuis(a)
    ret = A.new(a.p)
    return ret
  end
end


class B < A
  @id
  attr_accessor :id

  def initialize(p, id)
    super(p)
    self.id = id
  end

  #def creerDepuis(a, id)
    #ret = B.new(a.p, id)
    #return ret
  #end
end




ma1 = A.new(42)
ma2 = A.creerDepuis(ma1)

mb1 = B.new(23, 12)
mb2 = B.creerDepuis(mb1)

mb3 = B.creerDepuis(ma1)


