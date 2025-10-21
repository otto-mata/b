TARGET := B
FLEX_SRC := b.l
BISON_SRC := b.y
BISON_FLAGS := -d

$(TARGET): b.tab.c lex.yy.c
	gcc $^ -o $@

lex.yy.c: $(FLEX_SRC) b.tab.h
	flex $<

b.tab.c b.tab.h: $(BISON_SRC)
	bison $(BISON_FLAGS) $^ 
