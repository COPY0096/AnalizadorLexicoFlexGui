
CXX = g++
CXXFLAGS = -std=c++17 -I/c/msys64/mingw64/include -I/c/msys64/mingw64/include/QtWidgets -I/c/msys64/mingw64/include/QtCore -I/c/msys64/mingw64/include/QtGui
LDFLAGS = -L/c/msys64/mingw64/lib -lQt5Widgets -lQt5Core -lQt5Gui

TARGET = AnalizadorLexicoGUI.exe
OBJS = main.o gui_app.o lex.yy.c

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET) $(LDFLAGS)

lex.yy.c: lexer.l
	flex -o lex.yy.c lexer.l

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)



CXX = g++
CXXFLAGS = -std=c++17 -I/c/msys64/mingw64/include -I/c/msys64/mingw64/include/QtWidgets -I/c/msys64/mingw64/include/QtCore -I/c/msys64/mingw64/include/QtGui
LDFLAGS  = -L/c/msys64/mingw64/lib -lQt5Widgets -lQt5Core -lQt5Gui
FLEX = flex
TARGET = AnalizadorLexicoGUI.exe

OBJS = main.o gui_app.o lex.yy.o moc_gui_app.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(TARGET) $(LDFLAGS)

lex.yy.c: lexer.l
	$(FLEX) -o lex.yy.c lexer.l

moc_gui_app.cpp: gui_app.h
	moc gui_app.h -o moc_gui_app.cpp

main.o: main.cpp gui_app.h
	$(CXX) $(CXXFLAGS) -c main.cpp -o main.o

gui_app.o: gui_app.cpp gui_app.h
	$(CXX) $(CXXFLAGS) -c gui_app.cpp -o gui_app.o

lex.yy.o: lex.yy.c
	$(CXX) -c lex.yy.c -o lex.yy.o

moc_gui_app.o: moc_gui_app.cpp
	$(CXX) $(CXXFLAGS) -c moc_gui_app.cpp -o moc_gui_app.o

clean:
	rm -f $(OBJS) $(TARGET) lex.yy.c moc_gui_app.cpp
