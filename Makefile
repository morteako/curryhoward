ppt:
	npx @marp-team/marp-cli@latest slides.md -o  output.pptx

code:
	 cat slides.md | codedown haskell > code.hs
