def zero
  0
end

def increment(n)
  n + 1
end

def recurse(f, g, *values)
  *other_values, last_value = values

  if last_value.zero?
    send(f, *other_values)
  else
    easier_last_value = last_value - 1
    easier_values = other_values + [easier_last_value]

    easier_result = recurse(f, g, *easier_values)
    send(g, *easier_values, easier_result)
  end
end

def minimize
  n = 0
  n = n + 1 until yield(n).zero?
  n
end
