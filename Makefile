TARGET := B
FLEX_SRC := b.l
BISON_SRC := b.y
BISON_FLAGS := -d

$(TARGET): b.tab.c lex.yy.c
	gcc $^ -o $@

lex.yy.c: $(b.l)
	flex $^

b.tab.c: $(BISON_SRC)
	bison $(BISON_FLAGS) $^ 
