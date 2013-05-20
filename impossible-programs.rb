def euclid(x, y)
  until x == y
    if x > y
      x = x - y
    else
      y = y - x
    end
  end

  x
end

euclid(18, 12)
euclid(867, 5309)
puts 'hello world'
program = "puts 'hello world'"
bytes_in_binary = program.bytes.map { |byte| byte.to_s(2).rjust(8, '0') }
number = bytes_in_binary.join.to_i(2)
number = 9796543849500706521102980495717740021834791
bytes_in_binary = number.to_s(2).scan(/.+?(?=.{8}*\z)/)
program = bytes_in_binary.map { |string| string.to_i(2).chr }.join
eval program

def evaluate(program, input)
  # parse program
  # evaluate program on input while capturing output
  # return output
end

require 'stringio'

def evaluate(program, input)
  old_stdin, old_stdout = $stdin, $stdout
  $stdin, $stdout = StringIO.new(input), (output = StringIO.new)

  begin
    eval program
  rescue Exception => e
    output.puts(e)
  ensure
    $stdin, $stdout = old_stdin, old_stdout
  end

  output.string
end

evaluate('print $stdin.read.reverse', 'hello world')

def evaluate_on_itself(program)
  evaluate(program, program)
end

evaluate_on_itself('print $stdin.read.reverse')
x = 1
y = 2
puts x + y
program = '…'
x = 1
y = 2
puts x + y
puts %q{Curly brackets look like { and }.}
puts %q{An unbalanced curly bracket like } is a problem.}
program = 'program = \'program = \\\'program = \\\\\\\'…\\\\\\\'\\\'\''
data = %q{
program = "data = %q{#{data}}" + data
x = 1
y = 2
puts x + y
}
program = "data = %q{#{data}}" + data
x = 1
y = 2
puts x + y
puts program
data = %q{
program = "data = %q{#{data}}" + data
puts program
}
program = "data = %q{#{data}}" + data
puts program
data = %q{
program = "data = %q{#{data}}" + data
puts program
}
program = "data = %q{#{data}}" + data
puts program

def halts?(program, input)
  if program.include?('while true')
    false
  else
    true
  end
end

always = "input = $stdin.read\nputs input.upcase"
halts?(always, 'hello world')
never = "input = $stdin.read\nwhile true\n# do nothing\nend\nputs input.upcase"
halts?(never, 'hello world')

def halts?(program, input)
  if program.include?('while true')
    if program.include?('input.include?(\'goodbye\')')
      if input.include?('goodbye')
        false
      else
        true
      end
    else
      false
    end
  else
    true
  end
end

halts?(always, 'hello world')
halts?(never, 'hello world')
sometimes = "input = $stdin.read\nif input.include?('goodbye')\nwhile true\n# do nothing\nend\nelse\nputs input.upcase\nend"
halts?(sometimes, 'hello world')
halts?(sometimes, 'goodbye world')

def halts?(program, input)
  # parse program
  # analyze program
  # return true if program halts on input, false if not
end

def halts_on_itself?(program)
  halts?(program, program)
end

def prints_hello_world?(program, input)
  # parse program
  # analyze program
  # return true if program prints "hello world", false if not
end

def halts?(program, input)
  hello_world_program = %Q{
    program = #{program.inspect}
    input = $stdin.read
    evaluate(program, input) # evaluate program, ignoring its output
    print 'hello world'
  }

  prints_hello_world?(hello_world_program, input)
end
