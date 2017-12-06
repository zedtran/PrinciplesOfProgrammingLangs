load "TinyToken.rb"
load "TinyScanner.rb"

# filename.txt below is simply the "source code"
# that you write that adheres to your grammar rules
# if it is in the same directory as this file, you can
# simply include the file name, otherwise, you will need
# to specify the entire path to the file as we did above
# to load the other ruby modules
scan = Scanner.new('input.txt')
tok = scan.nextToken()

# Opens an output file which will contain the tokens we can later use
# to create a parse tree
output = File.open("parsefile.txt", 'w+')

while (tok.get_type() != Token::EOF)
    if (tok.get_type() == "print" || tok.get_type() == "unassigned")
        puts "Token: #{tok} \t\t\ttype: #{tok.get_type()}\n"
        output << "Token: #{tok} \t\t\ttype: #{tok.get_type()}\n"
        tok = scan.nextToken()
    end
    puts "Token: #{tok} \t\t\t\ttype: #{tok.get_type()}"
    output << "Token: #{tok} \t\t\t\ttype: #{tok.get_type()}\n"
    tok = scan.nextToken()
end
puts "Token: #{tok} \t\t\t\ttype: #{tok.get_type()}"
# Appends End of File token to output parsefile
output << "Token: #{tok} \t\t\t\ttype: #{tok.get_type()}\n\n"
output.close()