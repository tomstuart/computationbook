class Tape < Struct.new(:left, :middle, :right, :blank)
  def inspect
    "#<Tape #{left.join}(#{middle})#{right.join}>"
  end
end

tape = Tape.new(['1', '0', '1'], '1', [], '_')
tape.middle

class Tape
  def write(character)
    Tape.new(left, character, right, blank)
  end

  def move_head_left
    Tape.new(left[0..-2], left.last || blank, [middle] + right, blank)
  end

  def move_head_right
    Tape.new(left + [middle], right.first || blank, right.drop(1), blank)
  end
end

tape
tape.move_head_left
tape.write('0')
tape.move_head_right
tape.move_head_right.write('0')

class TMConfiguration < Struct.new(:state, :tape)
end

class TMRule < Struct.new(:state, :character, :next_state,
                          :write_character, :direction)
  def applies_to?(configuration)
    state == configuration.state && character == configuration.tape.middle
  end
end

rule = TMRule.new(1, '0', 2, '1', :right)
rule.applies_to?(TMConfiguration.new(1, Tape.new([], '0', [], '_')))
rule.applies_to?(TMConfiguration.new(1, Tape.new([], '1', [], '_')))
rule.applies_to?(TMConfiguration.new(2, Tape.new([], '0', [], '_')))

class TMRule
  def follow(configuration)
    TMConfiguration.new(next_state, next_tape(configuration))
  end

  def next_tape(configuration)
    written_tape = configuration.tape.write(write_character)

    case direction
    when :left
      written_tape.move_head_left
    when :right
      written_tape.move_head_right
    end
  end
end

rule.follow(TMConfiguration.new(1, Tape.new([], '0', [], '_')))

class DTMRulebook < Struct.new(:rules)
  def next_configuration(configuration)
    rule_for(configuration).follow(configuration)
  end

  def rule_for(configuration)
    rules.detect { |rule| rule.applies_to?(configuration) }
  end
end

rulebook = DTMRulebook.new([
  TMRule.new(1, '0', 2, '1', :right),
  TMRule.new(1, '1', 1, '0', :left),
  TMRule.new(1, '_', 2, '1', :right),
  TMRule.new(2, '0', 2, '0', :right),
  TMRule.new(2, '1', 2, '1', :right),
  TMRule.new(2, '_', 3, '_', :left)
])
configuration = TMConfiguration.new(1, tape)
configuration = rulebook.next_configuration(configuration)
configuration = rulebook.next_configuration(configuration)
configuration = rulebook.next_configuration(configuration)

class DTM < Struct.new(:current_configuration, :accept_states, :rulebook)
  def accepting?
    accept_states.include?(current_configuration.state)
  end

  def step
    self.current_configuration = rulebook.next_configuration(current_configuration)
  end

  def run
    step until accepting?
  end
end

dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.current_configuration
dtm.accepting?
dtm.step; dtm.current_configuration
dtm.accepting?
dtm.run
dtm.current_configuration
dtm.accepting?
tape = Tape.new(['1', '2', '1'], '1', [], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run

class DTMRulebook
  def applies_to?(configuration)
    !rule_for(configuration).nil?
  end
end

class DTM
  def stuck?
    !accepting? && !rulebook.applies_to?(current_configuration)
  end

  def run
    step until accepting? || stuck?
  end
end

dtm = DTM.new(TMConfiguration.new(1, tape), [3], rulebook)
dtm.run
dtm.current_configuration
dtm.accepting?
dtm.stuck?
rulebook = DTMRulebook.new([
  # state 1: scan right looking for a
  TMRule.new(1, 'X', 1, 'X', :right), # skip X
  TMRule.new(1, 'a', 2, 'X', :right), # cross out a, go to state 2
  TMRule.new(1, '_', 6, '_', :left),  # find blank, go to state 6 (accept)

  # state 2: scan right looking for b
  TMRule.new(2, 'a', 2, 'a', :right), # skip a
  TMRule.new(2, 'X', 2, 'X', :right), # skip X
  TMRule.new(2, 'b', 3, 'X', :right), # cross out b, go to state 3

  # state 3: scan right looking for c
  TMRule.new(3, 'b', 3, 'b', :right), # skip b
  TMRule.new(3, 'X', 3, 'X', :right), # skip X
  TMRule.new(3, 'c', 4, 'X', :right), # cross out c, go to state 4

  # state 4: scan right looking for end of string
  TMRule.new(4, 'c', 4, 'c', :right), # skip c
  TMRule.new(4, '_', 5, '_', :left),  # find blank, go to state 5

  # state 5: scan left looking for beginning of string
  TMRule.new(5, 'a', 5, 'a', :left),  # skip a
  TMRule.new(5, 'b', 5, 'b', :left),  # skip b
  TMRule.new(5, 'c', 5, 'c', :left),  # skip c
  TMRule.new(5, 'X', 5, 'X', :left),  # skip X
  TMRule.new(5, '_', 1, '_', :right)  # find blank, go to state 1
])
tape = Tape.new([], 'a', ['a', 'a', 'b', 'b', 'b', 'c', 'c', 'c'], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [6], rulebook)
10.times { dtm.step }; dtm.current_configuration
25.times { dtm.step }; dtm.current_configuration
dtm.run; dtm.current_configuration
rulebook = DTMRulebook.new([
  # state 1: read the first character from the tape
  TMRule.new(1, 'a', 2, 'a', :right), # remember a
  TMRule.new(1, 'b', 3, 'b', :right), # remember b
  TMRule.new(1, 'c', 4, 'c', :right), # remember c

  # state 2: scan right looking for end of string (remembering a)
  TMRule.new(2, 'a', 2, 'a', :right), # skip a
  TMRule.new(2, 'b', 2, 'b', :right), # skip b
  TMRule.new(2, 'c', 2, 'c', :right), # skip c
  TMRule.new(2, '_', 5, 'a', :right), # find blank, write a

  # state 3: scan right looking for end of string (remembering b)
  TMRule.new(3, 'a', 3, 'a', :right), # skip a
  TMRule.new(3, 'b', 3, 'b', :right), # skip b
  TMRule.new(3, 'c', 3, 'c', :right), # skip c
  TMRule.new(3, '_', 5, 'b', :right), # find blank, write b

  # state 4: scan right looking for end of string (remembering c)
  TMRule.new(4, 'a', 4, 'a', :right), # skip a
  TMRule.new(4, 'b', 4, 'b', :right), # skip b
  TMRule.new(4, 'c', 4, 'c', :right), # skip c
  TMRule.new(4, '_', 5, 'c', :right)  # find blank, write c
])
tape = Tape.new([], 'b', ['c', 'b', 'c', 'a'], '_')
dtm = DTM.new(TMConfiguration.new(1, tape), [5], rulebook)
dtm.run; dtm.current_configuration.tape

def increment_rules(start_state, return_state)
  incrementing = start_state
  finishing = Object.new
  finished = return_state

  [
    TMRule.new(incrementing, '0', finishing,    '1', :right),
    TMRule.new(incrementing, '1', incrementing, '0', :left),
    TMRule.new(incrementing, '_', finishing,    '1', :right),
    TMRule.new(finishing,    '0', finishing,    '0', :right),
    TMRule.new(finishing,    '1', finishing,    '1', :right),
    TMRule.new(finishing,    '_', finished,     '_', :left)
  ]
end

added_zero, added_one, added_two, added_three = 0, 1, 2, 3
rulebook = DTMRulebook.new(
  increment_rules(added_zero, added_one) +
  increment_rules(added_one, added_two) +
  increment_rules(added_two, added_three)
)
rulebook.rules.length
tape = Tape.new(['1', '0', '1'], '1', [], '_')
dtm = DTM.new(TMConfiguration.new(added_zero, tape), [added_three], rulebook)
dtm.run; dtm.current_configuration.tape
