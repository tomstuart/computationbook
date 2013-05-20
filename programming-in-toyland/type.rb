class Type < Struct.new(:name)
  NUMBER, BOOLEAN, VOID = [:number, :boolean, :void].map { |name| new(name) }

  def inspect
    "#<Type #{name}>"
  end
end
