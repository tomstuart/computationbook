class Assign
  def type(context)
    if context[name] == expression.type(context)
      Type::VOID
    end
  end
end
