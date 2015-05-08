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
    def initialize(opt = 1, cus = "")
        @alpha,@upcase,@num,@other = [AlphaLow,AlphaUp,Numbers,Others].map{|x| (opt & x) == x}
        @custom = cus
        @alphabet = (@custom.chars |
                ((@alpha ? AlphaL : "") + 
                (@upcase ? AlphaU : "") +
                (@num ? Num : "") +
                (@other ? Other : "")).chars
            ).join
    end
    def fixed(n,&b)
        @alphabet.chars.repeated_permutation(n).map{|x| 
            tmp = x.join
            b.call(tmp) if not b.nil?
            tmp}
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
    def self.masked(mask,cus = "",&b)
        tmp = case mask[0]
            when "a" then AlphaL
            when "A" then AlphaU
            when "#" then Num
            when "@" then Other
            when "*" then cus
            else raise "Invalid mask: #{mask[0]}"
        end
        return masked(mask[1..-1],cus,&b) if tmp.empty? and mask.length > 1
        tmp.chars.map{|x| 
            if mask.length > 1
                masked(mask[1..-1],cus).map{|y| 
                    tmp2 = x+y
                    b.call(tmp2) if not b.nil?
                    tmp2}
            else 
                b.call(x) if not b.nil?
                x
            end}.flatten   
    end
end
