require 'rational'
module Artworker
  module Fractions
    
    #This code is derived from Chris O'Sullivan's "Fractional" at http://github.com/thechrisoshow/fractional
  
    [:+, :-, :*, :/].each do |math_operator|
      define_method(math_operator) do |another_fraction|
        Artworker::Fractions.new(Artworker::Fractions.to_s(self.to_f.send(math_operator, another_fraction.to_f)))      
      end
    end
  
    def self.to_f(value=0)
      result = 0
    
      if mixed_fraction?(value)
        whole, numerator, denominator = value.scan(/(\-?\d*)\s(\d+)\/(\d+)/).flatten
      
        result = (numerator.to_f / denominator.to_f) + whole.to_f.abs
      
        result = whole.to_f > 0 ? result : -result
      elsif single_fraction?(value)
        numerator, denominator = value.split("/")
        result =  numerator.to_f / denominator.to_f
      else
        result = value.to_f
      end
    
      result
    end
 
    def self.to_s(value=0, args={})
      whole_number = value.to_f.truncate.to_i
    
      if whole_number == 0
        fractional_part_to_string(value, args[:to_nearest])
      else
        decimal_point_value = get_decimal_point_value(value.to_f)
        return whole_number.to_s if decimal_point_value == 0
      
        fractional_part = fractional_part_to_string(decimal_point_value.abs, args[:to_nearest])
      
        if (fractional_part == "1") || (fractional_part == "0")
          (whole_number + fractional_part.to_i).to_s
        else
          whole_number.to_s + " " + fractional_part
        end
      end 
    end
  
    def self.round_to_nearest_fraction(value=0, to_nearest_fraction)
      if value.is_a? String
        to_nearest_float = to_f(to_nearest_fraction)
 
        to_s((self.to_f(value) / to_nearest_float).round * to_nearest_float)
      else
        to_nearest_float = to_f(to_nearest_fraction)
 
        (value / to_nearest_float).round * to_nearest_float
      end
    
    end
 
    private
    
    def self.fraction?(value)
      value.to_s.count('/') == 1
    end
 
    def self.single_fraction?(value)
      fraction?(value) and !mixed_fraction?(value)
    end
 
    def self.mixed_fraction?(value)
      fraction?(value) and value.match(/\-?\d*\s+\d+\/\d+/)
    end
  
    def self.get_decimal_point_value(value)
      value - value.truncate
    end
  
    def self.fractional_part_to_string(value, round)
      if round
        round_to_nearest_fraction(float_to_rational(value.to_f).to_s, round)
      else
        float_to_rational(value.to_f).to_s  
      end
    end
 

    def self.float_to_rational(value)
      if value.nan? 
        return Rational(0,0)
      elsif value.infinite? 
        return Rational(value<0 ? -1 : 1,0)
      end 
      s,e,f = [value].pack("G").unpack("B*").first.unpack("AA11A52") 
      s = (-1)**s.to_i 
      e = e.to_i(2) 
      if e.nonzero? and e<2047
        Rational(s)* Rational(2)**(e-1023)*Rational("1#{f}".to_i(2),0x10000000000000) 
      elsif e.zero? 
        Rational(s)* Rational(2)**(-1024)*Rational("0#{f}".to_i(2),0x10000000000000) 
      end 
    end 
  end
end