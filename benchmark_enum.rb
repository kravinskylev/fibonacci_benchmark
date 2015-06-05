require "benchmark"

def fib_jai(quantity)
  @sequence = (1..quantity).inject([0]) do |fibs, num|
    if num > 1
      fibs << fibs[-1] + fibs[-2]
    else
      fibs << 1
    end
  end
end

#Surpisingly good, pretty weird. Never considered using inject.
#_________________________________________________________________

def fib_basic(n)
  if (0..1).include? n
    return n
  else
    (fib_basic(n - 1) + fib_basic(n - 2))
  end
end

#Worst. Fibber. Ever.
#_________________________________________________________________

def fib_one_line(n)
   n <= 1 ? n :  fib_one_line(n - 1) + fib_one_line(n - 2)
end

#CODE GOLF FTW
#__________________________________________________________________

cache = {}
def fib_cache(n, cache)
  return 1 if n <= 2
  return cache[n] if cache[n]
  cache[n] = fib_cache(n - 1, cache) + fib_cache(n - 2, cache)
end

#10.times say "Hash Cache"
#__________________________________________________________________

@fib = [0, 1, 1]
def fib_array(n)
  @fib[n] ||= fib_array(n-2) + fib_array(n-1)
end

#Deceptively fast. Not very furious :(
#__________________________________________________________________

def fib_iter(n)
  curr_num, next_num = 0, 1
    (n).times do
        curr_num, next_num = next_num, curr_num + next_num
      end
  curr_num
end

#Remind me of bubble sort.
#__________________________________________________________________

def matrix_fib(num)
  if num == 1
    [0,1]
  else
    f = matrix_fib(num/2)
    c = f[0] * f[0] + f[1] * f[1]
    d = f[1] * (f[1] + 2 * f[0])
    num.even? ? [c,d] : [d,c+d]
  end
end

def fib_matrix(num)
  num.zero? ? num : matrix_fib(num)[1]
end

#CRAZY FAST. Under 1 sec up to 10,000,000! Uses Linear Algebra (basic matrix multiplication)
#Suprisingly isn't that fast for sub 1000 fibs, gets beaten by array and cache.
#___________________________________________________________________

def fib_enum
  fib = Enumerator.new do |x|
    a=b=1
    loop do
      x << a
      a, b = b, a + b
    end
  end
end

#USAGE: fib.take 100
#WOAH -  Enumerator.new makes use of Fiber, AKA Ruby's pseudo-concurrency.
#That's why enums are quicker than method calls!
#It also means I don't have to make my own Fiber Fibonacci  :)
#____________________________________________________________________

fibp =
  lambda do
    a = [0, 1]
    lambda do |n|
      if n > 1
        a[n] ||= fibp[n - 2] + fibp[n - 1]
      else
        n
      end
    end
  end \
    .call

# wtf are lambdas somebody explain this shit to me
#____________________________________________________________________

Benchmark.bmbm(10) do |x|
  x.report("basic:"  )    {  fib_basic(10)          }
  x.report("golf:"   )    {  fib_one_line(10)       }
  x.report("cached:" )    {  fib_cache(1000, cache) }
  x.report("array:"  )    {  fib_array(1000)        }
  x.report("lambda:" )    {  fibp[1000]             }
  x.report("jai:"    )    {  fib_jai(1000)          }
  x.report("iter:"   )    {  fib_iter(1000)         }
  x.report("enum:"   )    {  fib_enum.take(1000)    }
  x.report("matrix:" )    {  fib_matrix(1000)       }
end


#1000 fib nu,s for all fib methods except the 2 basic ones which get frozen past 40
#_______________________________________________________
#                 user     system      total        real
#basic:       0.000000   0.000000   0.000000 (  0.000029)
#golf:        0.000000   0.000000   0.000000 (  0.000011)
#cached:      0.000000   0.000000   0.000000 (  0.000003)
#array:       0.000000   0.000000   0.000000 (  0.000009)
#lambda:      0.000000   0.000000   0.000000 (  0.000007)
#jai:         0.000000   0.000000   0.000000 (  0.000480)
#iter:        0.000000   0.000000   0.000000 (  0.000349)
#enum:        0.000000   0.000000   0.000000 (  0.000565)
#matrix:      0.000000   0.000000   0.000000 (  0.000021)
#_______________________________________________________


#interesting alogorithm to check if num is a fib
def is_fibonacci?(num)
  n = (Math.log(num*2.23606797749979 + 0.5) * 2.0780869213681945).floor
  num == (1.6180339887**n * 0.4472135954999579).round
end

