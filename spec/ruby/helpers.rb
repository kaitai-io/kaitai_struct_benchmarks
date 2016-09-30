require 'benchmark'

class Series
  attr_reader :count, :sum

  def initialize
    @count = 0
    @sum = 0.0
    @sum2 = 0.0
  end

  def <<(x)
    @count += 1
    @sum += x
    @sum2 += (x * x)
  end

  def avg
    @sum / @count
  end

  def stdev
    Math.sqrt((@count * @sum2 - @sum * @sum) / (@count * (@count - 1)))
  end
end
