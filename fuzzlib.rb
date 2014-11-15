def one(v)
  v.respond_to?(:call) ? v[] : v
end

def oneOf(arr)
  proc { one(arr[rand arr.size]) }
end

def weighted(pairs)
  weightSum = pairs.inject(0) { |a, k| a + k[0] }
  proc {
    rv = rand weightSum
    pairs.each do |pair|
      rv -= pair[0]
      break one(pair[1]) if rv < 0
    end
  }
end

def randomNormDist
  (((1..12).inject(0.0) { |a, k| a + rand }) - 6.0) / 6.0
end

class Integer
  def plusMinus(n)
    v = self + (2 * n * randomNormDist).round
    return v <= self - n ? self - n : v >= self + n ? self + n : v
  end
end

if ARGV.length >= 1
  srand(ARGV[0].to_i)
end
