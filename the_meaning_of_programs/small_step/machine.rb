class Machine < Struct.new(:statement, :environment)
  def step
    self.statement, new_environment = statement.reduce(environment)
    self.environment = new_environment unless new_environment.nil?
  end

  def run
    while statement.reducible?
      puts "#{statement}, #{environment}"
      step
    end

    puts "#{statement}, #{environment}"
  end
end
