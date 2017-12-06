# https://www.cs.rochester.edu/~brown/173/readings/05_grammars.txt
#
#  "TINY" Grammar
#
# PGM        -->   STMT+
# STMT       -->   ASSIGN   |   "print"  EXP
# ASSIGN     -->   ID  "="  EXP
# EXP        -->   TERM   ETAIL
# ETAIL      -->   "+" TERM   ETAIL  | "-" TERM   ETAIL | EPSILON
# TERM       -->   FACTOR  TTAIL
# TTAIL      -->   "*" FACTOR TTAIL  | "/" FACTOR TTAIL | EPSILON
# FACTOR     -->   "(" EXP ")" | INT | ID
#
# ID         -->   ALPHA+
# ALPHA      -->   a  |  b  | … | z  or
#                  A  |  B  | … | Z
# INT        -->   DIGIT+
# DIGIT      -->   0  |  1  | …  |  9
# WHITESPACE -->   Ruby Whitespace

#
#  Class Scanner - Reads a TINY program and emits tokens
#
class Scanner
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead
    begin
    def initialize(filename)
          @f = File.open(filename,'r:utf-8')

          if (! @f.eof?)
              @c = @f.getc()
          else
              @c = "!eof!"
              @f.close()
          end
          # Will handle attempts at opening files that don't exist and type errors
          rescue Exception => e
              puts "\n"
              puts e.message
              exit(1)
          end
    end


    # Method nextCh() returns the next character in the file
    def nextCh()
        if (! @f.eof?)
          @c = @f.getc()
        else
          @c = "!eof!"
        end
        return @c
    end

    # Method nextToken() reads characters in the file and returns
    # the next token
    def nextToken()
        if (@c == "!eof!")
        return Token.new(Token::EOF,"eof")

        # Identifies whitespace chars, [\t\r\n\f\s] tokens
        elsif (whitespace?(@c))
            str =""
            while (whitespace?(@c))
                if (@c == "\n")
                    @c = " "
                end
                str += @c
                nextCh()
            end
            tok = Token.new(Token::WS,str)
            return tok

        # Identifies digits, [0-9] tokens
        elsif (numeric?(@c))
            str = ""
            while (numeric?(@c))
                str += @c
                nextCh()
            end
            tok = Token.new(Token::NUMBER, str)
            return tok

        elsif (letter?(@c))
            str = ""
            while (letter?(@c))
                str += @c
                nextCh()
            end
            if (str.length < 2 && str != "print")
                tok = Token.new(Token::ALPHABET, str)
                return tok
            end
            if str == "print"
                return Token.new(Token::PRINT, str)
            end
            # Some new expression we have not yet used
            tok = Token.new(Token::ID, str)
            return tok

        elsif (@c == "(")
            tok = Token.new(Token::LPAREN, @c)
            nextCh()
        return tok

        elsif (@c == ")")
            tok = Token.new(Token::RPAREN, @c)
            nextCh()
        return tok

        elsif (@c == "+")
            tok = Token.new(Token::ADDOP, @c)
            nextCh()
        return tok

        elsif (@c == "-")
            tok = Token.new(Token::MINUSOP, @c)
            nextCh()
        return tok

        elsif (@c == "*")
            tok = Token.new(Token::MULTOP, @c)
            nextCh()
        return tok

        elsif (@c == "/")
            tok = Token.new(Token::DIVOP, @c)
            nextCh()
        return tok

        elsif (@c == "=")
            tok = Token.new(Token::EQUALOP, @c)
            nextCh()
        return tok

        else
            tok = Token.new("UNK","Unknown Token: #{@c}")
            nextCh()
        return tok
    end
  end
  #
  # Helper methods for Scanner
  #
  def letter?(lookAhead)
    lookAhead =~ /^[a-z]|[A-Z]$/
  end

  def numeric?(lookAhead)
    lookAhead =~ /^(\d)+$/
  end

  def whitespace?(lookAhead)
    lookAhead =~ /^(\s)+$/
  end
  end