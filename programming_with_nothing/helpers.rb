def to_integer(proc)
  proc[-> n { n + 1 }][0]
end

def to_boolean(proc)
  IF[proc][true][false]
end

def to_array(proc)
  array = []

  until to_boolean(IS_EMPTY[proc])
    array.push(FIRST[proc])
    proc = REST[proc]
  end

  array
end

def to_char(c)
  '0123456789BFiuz'.slice(to_integer(c))
end

def to_string(s)
  to_array(s).map { |c| to_char(c) }.join
end
