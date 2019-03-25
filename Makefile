#
# Rules for compiling and linking the typechecker/evaluator
#
# Type
#   make         to rebuild the executable files
#   make clean   to remove all intermediate and temporary files
#

# Files that need to be generated from other files
DEPEND += Tokens.hs Grammar.hs myinterpreter.hs

# When "make" is invoked with no arguments, we build an executable
#  after building everything that it depends on
all: $(DEPEND) Eval

# Build an executable for Toy interpreter
Eval: $(DEPEND) myinterpreter.hs
	ghc myinterpreter.hs

# Build an executable for interactive mode
#Toyi: $(DEPEND) Toyi.hs
#	ghc Toyi.hs

# Generate ML files from a parser definition file
Grammar.hs : Grammar.y
	@rm -f Grammar.hs
	happy Grammar.y
	@chmod -w Grammar.hs

# Generate ML files from a lexer definition file
Tokens.hs : Tokens.x
	@rm -f Tokens.hs
	alex Tokens.x
	@chmod -w Tokens.hs

# Clean up the directory
clean::
	rm -rf Grammar.hs Tokens.hs *.hi *.o *.info myinterpreter








#
# Rules for compiling and linking the typechecker/evaluator
#
# Type
#   make         to rebuild the executable files
#   make clean   to remove all intermediate and temporary files
#

# Files that need to be generated from other files
#DEPEND += Evaluator.hs

# When "make" is invoked with no arguments, we build an executable
#  after building everything that it depends on
#all: $(DEPEND) Evaluator

# Build an executable for Toy interpreter
#Evaluator: $(DEPEND) Evaluator.hs
#	ghc -o Evaluator Evaluator.hs

# Build an executable for interactive mode

# Generate ML files from a parser definition file

# Generate ML files from a lexer definition file

# Clean up the directory
#clean::
#	rm -rf *.hi *.o *.info *.exe
