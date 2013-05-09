require 'pgm'
require 'set'

describe 'the simplest factor' do
  before :each do
    @factor = PGM::Factor.new do
      a | 1
    end
  end

  it 'should create a valid @vars instance variables' do
    @factor.vars.should eq({Set.new([{:a => nil}]) => 1})
  end

  it 'should print out the variables in tabular form' do
    @factor.to_s.should eq("a | 1")
  end
end

describe 'a factor with numerical levels' do
  before :each do
    @factor = PGM::Factor.new do
      foo[1] | bar[1] | 0.2
      foo[1] | bar[2] | 0.8
      foo[2] | bar[1] | 0.1
      foo[2] | bar[2] | 0.9
    end
  end

  it 'should create a valid @vars instance variables' do
    @factor.vars.should eq({
      Set.new([{:foo => 1}, {:bar => 1}]) => 0.2,
      Set.new([{:foo => 1}, {:bar => 2}]) => 0.8,
      Set.new([{:foo => 2}, {:bar => 1}]) => 0.1,
      Set.new([{:foo => 2}, {:bar => 2}]) => 0.9})
  end

  it 'should print out the variables in tabular form' do
    @factor.to_s.should eq([
      "foo[1] | bar[1] | 0.2",
      "foo[1] | bar[2] | 0.8",
      "foo[2] | bar[1] | 0.1",
      "foo[2] | bar[2] | 0.9"].join("\n"))
  end
end

describe 'a factor with non-numerical levels' do
  before :each do
    @factor = PGM::Factor.new do
      gender[male]   | age[young] | 0.3
      gender[male]   | age[old]   | 0.7
      gender[female] | age[young] | 0.4
      gender[female] | age[old]   | 0.6
    end
  end

  it 'should create a valid @vars instance variables with variable names as symbols' do
    @factor.vars.should eq({
      Set.new([{:gender => :male},   {:age => :young}]) => 0.3,
      Set.new([{:gender => :male},   {:age => :old}])   => 0.7,
      Set.new([{:gender => :female}, {:age => :young}]) => 0.4,
      Set.new([{:gender => :female}, {:age => :old}])   => 0.6})
  end

  it 'should print out the variables in tabular form' do
    @factor.to_s.should eq([
      "gender[female] | age[old] | 0.6",
      "gender[female] | age[young] | 0.4",
      "gender[male] | age[old] | 0.7",
      "gender[male] | age[young] | 0.3"].join("\n"))
  end

  it 'should marginalize correctly' do
    pending 'implementation'
  end

  it 'should should calculate factor products correctly' do
    pending 'implementation'
  end
end
