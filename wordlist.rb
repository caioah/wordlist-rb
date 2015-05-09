Other = "!?@#$%&*_-+=,<.:;>/\\|()[]{}^`~\'\""
AlphaL = "abcdefghijklmnopqrstuvwxz"
AlphaU = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Num = "0123456789"
AlphaLow = 1
AlphaUp = 2
Numbers = 4
Others = 8
class Wordlist
    attr_accessor :alpha, :upcase, :num, :other, :custom, :alphabet
    def initialize(opt = 1, cust = "")
        @alpha,@upcase,@num,@other = [AlphaLow,AlphaUp,Numbers,Others].map{|x| (opt & x) == x}
        @custom = cust
        @alphabet = (@custom.chars |
                ((@alpha ? AlphaL : "") + 
                (@upcase ? AlphaU : "") +
                (@num ? Num : "") +
                (@other ? Other : "")).chars
            ).join
    end
    def fixed(n,&b)
        @alphabet.chars.repeated_permutation(n){|x| 
            tmp = x.join
            (b.nil? ? tmp : b.call(tmp))}
    end
    def variable(s,e,&b)
        return nil if s <= 0
        return fixed(s,&b)+variable(s+1,e,&b) if s+1 <= e
        return fixed(s,&b) if s == e
        raise "Start/end error"
    end
    def masked(mask,&b)
        Wordlist.masked(mask,@custom,&b)
    end
    def self.masked(mask,cust = "",&b)
        tmp = case mask[0]
            when "a" then AlphaL
            when "A" then AlphaU
            when "#" then Num
            when "@" then Other
            when "*" then cust
            else raise "Invalid mask: #{mask[0]}"
        end
        if tmp.empty?
            return masked(mask[1..-1],cust,&b) if mask.length > 1
            return []
        end
        tmp.chars.map{|x| 
            if mask.length > 1
                a = masked(mask[1..-1],cust)
                (a.empty? ? 
                    (b.nil? ? x : b.call(x)) : 
                    a.map{|y| 
                        w = x+y
                        (b.nil? ? w : b.call(w))})
            else 
                (b.nil? ? x : b.call(x))
            end}.flatten   
    end
end
