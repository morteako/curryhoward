
ppt:
	npx @marp-team/marp-cli@latest slides.md -o  output.pptx


pdf:
	npx @marp-team/marp-cli@latest slides.md -o  output.pdf

code:
	 cat slides.md | codedown haskell > code.hs

all : 
	make code
	make ppt
	make pdf

