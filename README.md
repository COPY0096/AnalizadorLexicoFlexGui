---
JEREMY SURIEL 1-20-2049
---

## 🧩 Analizador Léxico con Interfaz Gráfica (Qt + FLEX)

### 📖 Descripción del Proyecto

Este proyecto implementa un **Analizador Léxico** desarrollado en **C++ utilizando FLEX** para la generación del analizador y **Qt** para la interfaz gráfica.
El programa permite analizar el contenido de un archivo de texto, identificando los **tokens** definidos en el lenguaje diseñado, y mostrando los resultados visualmente en una tabla dentro de la ventana principal.

El proyecto incluye una **carpeta deploy/** con todas las DLL necesarias para ejecutar el programa en Windows sin necesidad de instalar Qt o copiar DLLs manualmente.

---

### ⚙️ Tecnologías Utilizadas

* **Lenguaje:** C++
* **Analizador Léxico:** FLEX
* **Interfaz Gráfica:** Qt5 (QtWidgets)
* **Compilación:** g++ / make
* **Sistema Operativo Recomendado:** Windows 10 / 11 o Linux

---

### 📚 Estructura del Proyecto

```

📁 AnalizadorLexicoGUI/
│
├── lexer.l                 # Definición del analizador léxico en FLEX
├── gui_app.h               # Cabecera de la aplicación Qt
├── gui_app.cpp             # Lógica principal de la GUI
├── main.cpp                # Punto de entrada de la aplicación
├── Makefile                # Archivo de compilación automatizada
├── deploy/                 # Ejecutable y DLLs listas para distribución en Windows
│   ├── AnalizadorLexicoGUI.exe
│   ├── *.dll
│   └── platforms/qwindows.dll
└── README.md               # Documentación del proyecto

````

---

### 💬 Descripción del Lenguaje Analizado

El analizador reconoce los siguientes **tipos de tokens**:

| Tipo de Token       | Ejemplo                               | Descripción                               |
| ------------------- | ------------------------------------- | ----------------------------------------- |
| Palabras Reservadas | `if`, `else`, `while`, `int`, `float` | Palabras propias del lenguaje             |
| Identificadores     | `variable1`, `_contador`              | Nombres definidos por el usuario          |
| Números Enteros     | `123`, `42`                           | Constantes numéricas enteras              |
| Números Reales      | `3.14`, `0.5`                         | Constantes con punto decimal              |
| Operadores          | `+`, `-`, `*`, `/`, `=`               | Operaciones aritméticas o de asignación   |
| Delimitadores       | `(`, `)`, `{`, `}`, `;`               | Símbolos de agrupación o fin de sentencia |
| Comentarios         | `// comentario`                       | Texto ignorado por el analizador          |
| Desconocidos        | `@`, `#`                              | Caracteres no válidos                     |

---

### 🧠 Pruebas del Lenguaje

Ejemplo de código fuente a analizar:

```c
int main() {
    float x = 3.14;
    int y = 5;
    if (x > y) {
        // comentario de prueba
        y = y + 1;
    }
}
````

**Salida esperada en la interfaz:**

| Token | Tipo              |
| ----- | ----------------- |
| int   | Palabra reservada |
| main  | Identificador     |
| (     | Delimitador       |
| )     | Delimitador       |
| {     | Delimitador       |
| float | Palabra reservada |
| x     | Identificador     |
| =     | Operador          |
| 3.14  | Número real       |
| ;     | Delimitador       |
| ...   | ...               |

---

### 🧑‍💻 Instrucciones de Compilación

#### 🔹 Opción 1: Usando Makefile 

1. Abre una terminal en la carpeta del proyecto.
2. Ejecuta:

   ```bash
   make clean 
   make
   ```
3. Se generará el ejecutable:

   ```
   AnalizadorLexicoGUI.exe  (Windows)
   ./AnalizadorLexicoGUI    (Linux)
   ```

#### 🔹 Opción 2: Manual con g++

Si prefieres compilar manualmente:

```bash
flex lexer.l
g++ -std=c++17 -o AnalizadorLexicoGUI main.cpp gui_app.cpp lex.yy.c -lQt5Widgets -lQt5Core
```

---

### 🪟 Ejecución

#### 🔹 Windows (con carpeta deploy/) (Recomendado)

1. Abre la carpeta `deploy/`.
2. Ejecuta directamente:

   ```
   AnalizadorLexicoGUI.exe
   ```
3. Usa el botón **"Abrir Archivo"** para seleccionar un archivo de texto con código fuente.
4. Presiona **"Analizar"** para visualizar los tokens reconocidos.
5. La tabla mostrará el **lexema** y su **tipo de token**.

> ✅ Nota: Todo lo necesario (DLLs de Qt, ICU, Winpthread, platforms/qwindows.dll) ya está incluido. No se requiere instalar Qt ni copiar DLLs manualmente.

#### 🔹 Linux

```bash
./AnalizadorLexicoGUI
```

---

### 📤 Link en GitHub

[https://github.com/COPY0096/AnalizadorLexicoFlexGui](https://github.com/COPY0096/AnalizadorLexicoFlexGui)

---

### 📺 Link en Video Youtube

[https://youtu.be/ub43HkJdUi8](https://youtu.be/ub43HkJdUi8)

---
