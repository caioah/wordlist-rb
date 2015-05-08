# Ruby wordlist generator
Custom wordlist generator written in Ruby
# Usage
Initialization
--------------
syntax: Wordlist.new(<opt>, <custom>)

* opt: 4-bit integer comoposed of 4 flags, wether lowercase, uppercase, numeric or other.
* custom: string of custom characters to be included. (optional)

The flags define what character sets are going to be included in the wordlist alphabet. 
They are defined by the constants:
* AlphaLow = 1
* AlphaUp = 2
* Numbers = 4
* Others = 8

Each can be used by itself or they can be combined with the "|" (OR) or "+" (sum) operator. 
For example, to include alphanumeric lowercase and uppercase, you can use either

Wordlist.new(AlphaLow|AlphaUp|Numbers) 

or

Wordlist.new(AlphaLow+AlphaUp+Numbers).

They can also be represented by their resulting integer. The previous example would be the same as Wordlist.new(7).

If no opt is specified, the default lowercase will be used.

```ruby
alphabetic = Wordlist.new(AlphaLow)
alphabetic = Wordlist.new(AlphaLow|AlphaUp)
alphabetic = Wordlist.new(3)
alphanum = Wordlist.new(AlphaLow|AlphaUp|Numbers)
alphanum = Wordlist.new(Numbers+3)
alphanum = Wordlist.new(7)
```
Generation
----------
The class has 3 wordlist generating functions:

* fixed(n): generates an array of repeated permutations of the alphabet with fixed length n.
* variable(s,n): generates an array of variable length (from s to n) with repeated permutations.
* masked(mask): generates an array according to the mask parameter.

The mask parameter is an string composed of 5 characters that identify the character set to be included. 
The characters are:
* "a" = lowercase
* "A" = uppercase
* "#" = numeric
* "@" = other
* "*" = custom
The mask parameter overrides current flags if masked is called from an instantiated class. The function masked can also be called from an uninstantiated class like Wordlist.masked(mask,custom), where custom is an string with custom characters to be included.

A block of code with a parameter can be passed to each function. It will be executed with every generated word as parameter.
```ruby
Wordlist.new(5).fixed(4) #generates an array of 4 alphanumeric lowercase characters
Wordlist.new(6).variable(1,5) #generates an array of 1 to 5 alphanumeric uppercase characters
Wordlist.new.masked("A#*a*", "!@#$") #generates an array with words in the mask "A#*a", i.e. from "A0!a" to "Z9$z"
Wordlist.new(1).fixed(2){|w| puts w} #generates lowercase words of 2 letters and prints each on stdout 
```
