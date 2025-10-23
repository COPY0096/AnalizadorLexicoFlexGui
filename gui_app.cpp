#include "gui_app.h"
#include <QApplication>
#include <QFile>
#include <QTextStream>
#include <iostream>

extern "C" {
    extern FILE* yyin;
    int yylex(void);
    void enviar_token_a_gui(const char* tipo, const char* valor);
}

MainWindow* MainWindow::instancia = nullptr;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    instancia = this;
    this->setWindowTitle("Analizador Léxico - Flex");
    this->resize(600, 400);

    QWidget *central = new QWidget(this);
    QVBoxLayout *layout = new QVBoxLayout(central);

    botonAnalizar = new QPushButton("Analizar archivo", this);
    listaTokens = new QListWidget(this);

    layout->addWidget(botonAnalizar);
    layout->addWidget(listaTokens);

    setCentralWidget(central);

    connect(botonAnalizar, &QPushButton::clicked, this, &MainWindow::analizarArchivo);
}

MainWindow* MainWindow::getInstance() {
    return instancia;
}

void MainWindow::agregarToken(const char* tipo, const char* valor) {
    QString linea = QString("TOKEN: %1 (%2)").arg(tipo).arg(valor);
    listaTokens->addItem(linea);
}

void MainWindow::analizarArchivo() {
    QString rutaArchivo = QFileDialog::getOpenFileName(this, "Seleccionar archivo de código", "", "Archivos de texto (*.txt *.c *.cpp)");
    if (rutaArchivo.isEmpty()) return;

    FILE* archivo = fopen(rutaArchivo.toStdString().c_str(), "r");
    if (!archivo) {
        QMessageBox::critical(this, "Error", "No se pudo abrir el archivo seleccionado.");
        return;
    }

    listaTokens->clear();
    yyin = archivo;
    yylex();
    fclose(archivo);

    QMessageBox::information(this, "Análisis completado", "El análisis léxico ha finalizado.");
}

// ==== FUNCIÓN C USADA POR EL LEXER ====
extern "C" void enviar_token_a_gui(const char* tipo, const char* valor) {
    if (MainWindow::getInstance()) {
        MainWindow::getInstance()->agregarToken(tipo, valor);
    }
}
