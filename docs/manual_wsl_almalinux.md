# 🐧 Manual de Entorno Avanzado: WSL2 (AlmaLinux 9)

Este documento contiene la referencia rápida y el funcionamiento de todas las herramientas de productividad que fueron configuradas en tu entorno Linux bajo Windows Subsystem for Linux (WSL).

> [!NOTE]
> Aunque tu terminal gráfica es Windows Terminal (la aplicación que muestra los colores y tipografías), el "cerebro" o shell que está corriendo por debajo en WSL cambió de `Bash` a **`Zsh`**. Zsh es mucho más potente y permite ecosistemas enteros de plugins.

---

## 1. 🐚 Tu Nuevo Shell: Zsh + Oh My Zsh

### ¿Qué es?
**Zsh** es tu nuevo intérprete de comandos por defecto. Se ha potenciado con **Oh My Zsh**, el framework de configuración más popular del mundo Linux, diseñado para facilitarte la vida.

- **Para recargar tu configuración**: Si editas tu archivo `~/.zshrc`, solo escribe `source ~/.zshrc` (o cierra y abre la pestaña) para aplicar los cambios.
- **Directorio de configuración**: Toda la magia de Zsh ocurre en `~/.zshrc`.

---

## 2. 🎨 Prompt Visual y Temas (Oh My Posh)

Tu terminal Linux utiliza exactamente el mismo motor visual que tu entorno de Windows: **Oh My Posh**. 
Carga el tema *Catppuccin Mocha* y está configurado para mostrar:
1. El directorio actual con iconos.
2. La rama de Git en la que te encuentras (y si tienes archivos modificados, agregados, etc.).
3. El tiempo de ejecución del último comando (si demoró más de 2 segundos).
4. El estado de éxito o error del comando anterior.

---

## 3. 🧠 Autocompletado Predictivo y Resaltado

Al igual que en Windows, tu entorno Linux ahora puede leer tu mente (y tu historial):

- **zsh-autosuggestions**: Mientras escribes, te sugerirá en color gris el resto de un comando que hayas utilizado antes. 
  - **Atajo**: Presiona la **`Flecha Derecha (→)`** para aceptar la sugerencia completa.
- **zsh-syntax-highlighting**: Si el comando que estás escribiendo existe (ej. `grep`, `docker`), se pintará de **verde**. Si el comando no existe o lo escribiste mal, se pintará de **rojo**. Esto evita errores antes de presionar Enter.

---

## 4. 📂 Listados Hermosos y con Iconos (`eza`)

En el mundo de Linux tradicional, para listar archivos usas `ls`. Nosotros reemplazamos `ls` internamente por **`eza`**, una herramienta moderna escrita en Rust que incluye soporte para iconos (Nerd Fonts) y una mejor legibilidad de colores.

### Comandos que puedes usar:

| Comando | Acción (Alias interno de eza) |
|---------|-------------------------------|
| `ls` | Lista archivos/carpetas en columnas, ordenado, con iconos. |
| `ll` | Lista con formato largo (muestra dueños, permisos, tamaño). |
| `la` | Lista con formato largo incluyendo archivos ocultos. |

> [!TIP]
> Atrévete a probar `eza --tree`. Te mostrará todo el árbol de directorios hacia abajo como si fuera un mapa visual.

---

## 5. ⚡ Navegación Telepática (`zoxide`)

Reemplazo inteligente del clásico comando `cd`. Zoxide aprende de tus hábitos de navegación y recuerda qué carpetas visitas más.

- Si sueles visitar `/home/innova/proyectos/mi_app/backend`, ya no necesitas escribir la ruta completa.
- **Solo escribe:** `z back` o `z mi_app` y presiona Enter. Zoxide te teletransportará instantáneamente a la carpeta correcta.

---

## 6. 🔍 Buscador de Historial y Archivos Mágico (FZF)

`fzf` ("Fuzzy Finder") revoluciona la forma en que buscas en tu historial.

### Atajos Clave

| Acción | Atajo |
|--------|-------|
| **Buscar en tu Historial de Comandos** | **`Ctrl + R`** |
| **Buscar Archivo en la carpeta actual** | **`Ctrl + T`** |

### Cómo funciona `Ctrl + R`:
1. Presiona `Ctrl + R`.
2. Se abrirá una pequeña interfaz interactiva en la parte inferior.
3. Escribe cualquier palabra, fragmento o parámetro de un comando que usaste hace días.
4. Usa las flechas del teclado arriba/abajo para navegar entre los resultados que coinciden.
5. Presiona `Enter` para cargar el comando en la línea actual y ejecutarlo.

---

## 🏷️ Resumen Rápido de Comandos Diarios

| Tarea | Lo que escribías antes | Lo que debes hacer AHORA |
|-------|-----------------------|--------------------------|
| Ver lista de archivos | `ls -la` | Solo **`la`** o **`ll`** (Muestra iconos y colores bonitos). |
| Ir a una carpeta | `cd /var/www/html/` | **`z html`** (Navegación inteligente). |
| Buscar comando viejo | Flecha arriba 100 veces | **`Ctrl + R`** y escribe lo que buscas. |
| Autocompletar largo | Volver a escribir todo | **`Flecha Derecha`** al ver la sugerencia gris. |

> [!IMPORTANT]
> A diferencia de Windows, en WSL/Linux **todo es sensible a mayúsculas y minúsculas**. Sin embargo, Zsh ha sido configurado con *Oh My Zsh* para ofrecerte autocompletado inteligente con la tecla `TAB`, que ignora mayúsculas si no hay ambigüedad. ¡Úsala frecuentemente!
