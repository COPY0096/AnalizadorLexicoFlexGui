#!/usr/bin/env bash
set -euo pipefail

# Nombre del ejecutable (ajusta si lo cambiaste)
EXE="AnalizadorLexicoGUI.exe"

# Carpetas
PROJECT_DIR="$(pwd)"
DEPLOY_DIR="$PROJECT_DIR/deploy"

echo
echo "== DEPLOY SCRIPT =="
echo "Project: $PROJECT_DIR"
echo "Executable: $EXE"
echo

# 1) Limpiar y crear deploy/
rm -rf "$DEPLOY_DIR"
mkdir -p "$DEPLOY_DIR"

# 2) Copiar exe
if [ ! -f "$EXE" ]; then
  echo "ERROR: Ejecutable $EXE no encontrado en $(pwd)"
  exit 1
fi
cp "$EXE" "$DEPLOY_DIR/"

# 3) Copiar carpeta platforms si existe en el proyecto
if [ -d "platforms" ]; then
  echo "Copiando carpeta platforms/ a deploy/ ..."
  cp -r platforms "$DEPLOY_DIR/"
else
  echo "Nota: no se encontró platforms/ en el proyecto. Asegúrate de tener platforms/qwindows.dll si usas Qt."
fi

# 4) Intentar ejecutar windeployqt para que copie Qt DLLs y plugins donde pueda
#    (No es imprescindible, pero puede ayudar. Si falla, el script seguirá.)
if command -v windeployqt >/dev/null 2>&1; then
  echo "Ejecutando windeployqt --release --compiler-runtime (puede emitir warnings) ..."
  # Ejecutar en copia temporal para que windeployqt no modifique el proyecto
  TMPDIR="$(mktemp -d)"
  cp "$EXE" "$TMPDIR/"
  (cd "$TMPDIR" && windeployqt --release --compiler-runtime "$EXE") || echo "windeployqt falló o advirtió; continuando con la recolección manual..."
  # copiar lo que haya creado windeployqt (si creó algo)
  if [ -d "$TMPDIR/platforms" ]; then
    cp -r "$TMPDIR/platforms" "$DEPLOY_DIR/" || true
  fi
  # mover dlls que haya creado (Qt DLLs) desde TMPDIR a deploy
  find "$TMPDIR" -maxdepth 1 -type f -iname "*.dll" -exec cp -v {} "$DEPLOY_DIR/" \; || true
  rm -rf "$TMPDIR"
else
  echo "windeployqt no encontrado en PATH. Se hará recolección manual de DLLs."
fi

# 5) Ejecutar ldd y parsear DLLs para copiar (excluye las que apuntan a System32)
echo "Analizando dependencias con ldd..."
LDDFULL=$(ldd "$EXE" || true)

# Extraer rutas absolutos de las DLL listadas por ldd (líneas que contienen '/')
# y filtrar las rutas dentro de /c/WINDOWS o /c/Windows (sistema) - no copiarlas.
echo "$LDDFULL" > /tmp/ldd_output.txt
awk '/=>/ {for(i=1;i<=NF;i++) if ($i ~ /^\//) print $i }' /tmp/ldd_output.txt | sort -u > /tmp/dll_paths.txt

echo "DLL encontradas por ldd:"
cat /tmp/dll_paths.txt

# Copiar cada DLL que no esté en System32
echo
echo "Copiando DLLs no-sistema a deploy/ ..."
while IFS= read -r dllpath; do
  # Normalizar ruta (msys: /c/Users/... or /mingw64/bin/...)
  if [[ "$dllpath" =~ /c/Windows ]] || [[ "$dllpath" =~ /c/WINDOWS ]] || [[ "$dllpath" =~ /C:/Windows ]] ; then
    echo "  - Ignorando DLL del sistema: $dllpath"
    continue
  fi
  # Algunas entradas pueden venir como '/mingw64/bin/lib...'
  if [ -f "$dllpath" ]; then
    cp -v "$dllpath" "$DEPLOY_DIR/"
  else
    echo "  - Advertencia: ruta no existe: $dllpath"
  fi
done < /tmp/dll_paths.txt

# 6) Asegurarnos de que platforms/qwindows.dll esté en deploy/
if [ -d "platforms" ]; then
  if [ ! -d "$DEPLOY_DIR/platforms" ]; then
    echo "Copiando platforms/ al deploy/ (si no existe ya)..."
    cp -r platforms "$DEPLOY_DIR/"
  fi
fi

# 7) Re-check: ldd sobre el exe en deploy/
echo
echo "Verificando dependencias del ejecutable dentro de deploy/ (ldd deploy/EXE) ..."
(cd "$DEPLOY_DIR" && ldd "$EXE") > "$PROJECT_DIR/deploy_ldd_result.txt" || true
echo "Resultado escrito en: deploy_ldd_result.txt (revísalo para detectar faltantes)."

# 8) (Opcional) crear zip con artefacto listo
ZIPNAME="AnalizadorLexicoGUI_deploy.zip"
echo "Creando $ZIPNAME ..."
(cd "$DEPLOY_DIR" && zip -r "../$ZIPNAME" .) >/dev/null 2>&1 || echo "zip no disponible o falló; omitiendo zip."

echo
echo "== FIN: carpeta 'deploy/' lista. Comprueba deploy_ldd_result.txt para dependencias faltantes. =="
echo "Puedes comprimir deploy/ y distribuirlo. Ejecutable: deploy/$EXE"
