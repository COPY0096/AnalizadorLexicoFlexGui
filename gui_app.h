#ifndef GUI_APP_H
#define GUI_APP_H

#include <QMainWindow>
#include <QListWidget>
#include <QPushButton>
#include <QVBoxLayout>
#include <QFileDialog>
#include <QTextStream>
#include <QMessageBox>

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    static MainWindow* getInstance();

    void agregarToken(const char* tipo, const char* valor);

private slots:
    void analizarArchivo();

private:
    static MainWindow* instancia;
    QListWidget *listaTokens;
    QPushButton *botonAnalizar;
};

extern "C" {
    void enviar_token_a_gui(const char* tipo, const char* valor);
}

#endif // GUI_APP_H
