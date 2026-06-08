# 📖 Manual de Funcionalidades — Windows Terminal

> Archivo de respaldo: [settings.json.bak](file:///c:/Users/steranf/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json.bak)
> Archivo activo: [settings.json](file:///c:/Users/steranf/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json)

> [!NOTE]
> Windows Terminal aplica los cambios de `settings.json` **en tiempo real**. No necesitas reiniciar la aplicación. Si algo no funciona, cierra y vuelve a abrir la terminal.

---

## 1. 🗂️ Gestión de Pestañas

### ¿Qué es?
Puedes abrir múltiples shells en pestañas separadas dentro de la misma ventana, cambiar entre ellas rápidamente por posición, duplicarlas y renombrarlas.

### Atajos de teclado

| Acción | Atajo | Descripción |
|--------|-------|-------------|
| **Nueva pestaña** | `Ctrl + Shift + T` | Abre una nueva pestaña con tu perfil predeterminado (PowerShell) |
| **Cerrar pestaña/panel** | `Ctrl + Shift + W` | Cierra el panel activo. Si es el último, cierra la pestaña entera |
| **Siguiente pestaña** | `Ctrl + Tab` | Cambia a la siguiente pestaña (orden MRU — más reciente primero) |
| **Pestaña anterior** | `Ctrl + Shift + Tab` | Cambia a la pestaña anterior |
| **Ir a pestaña 1** | `Ctrl + 1` | Salta directamente a la primera pestaña |
| **Ir a pestaña 2** | `Ctrl + 2` | Salta directamente a la segunda pestaña |
| **Ir a pestaña 3** | `Ctrl + 3` | Salta directamente a la tercera pestaña |
| **Ir a pestaña 4** | `Ctrl + 4` | Salta directamente a la cuarta pestaña |
| **Ir a pestaña 5** | `Ctrl + 5` | Salta directamente a la quinta pestaña |
| **Duplicar pestaña** | `Ctrl + Shift + D` | Duplica la pestaña actual con el mismo perfil y directorio |
| **Renombrar pestaña** | `Ctrl + Shift + R` | Abre un campo de texto para renombrar la pestaña activa |

### Cómo usarlo

1. **Abrir varias shells**: Presiona `Ctrl+Shift+T` varias veces. Verás las pestañas arriba.
2. **Saltar a una pestaña específica**: Si tienes 4 pestañas abiertas, `Ctrl+3` te lleva a la tercera.
3. **Tab Switcher (MRU)**: Al presionar `Ctrl+Tab` aparece un menú flotante mostrando las pestañas ordenadas por uso reciente. Mantén `Ctrl` presionado y usa `Tab` para navegar.
4. **Duplicar**: `Ctrl+Shift+D` clona tu pestaña actual — útil cuando ya estás en un directorio específico y quieres otra shell ahí.
5. **Renombrar**: `Ctrl+Shift+R` te deja escribir un nombre personalizado. Presiona `Enter` para confirmar o `Escape` para cancelar.

### Nota sobre Tab Switcher MRU
La configuración `"tabSwitcherMode": "mru"` hace que `Ctrl+Tab` muestre las pestañas por **orden de uso más reciente**, no por posición. Si prefieres orden secuencial, cambia a `"inOrder"`.

---

## 2. 📐 Paneles Divididos (Split Panes)

### ¿Qué es?
Divide tu pestaña actual en múltiples paneles, cada uno con su propia shell. Funciona como tmux pero integrado en la terminal.

### Atajos de teclado

| Acción | Atajo | Descripción |
|--------|-------|-------------|
| **Dividir horizontal** | `Ctrl + Shift + -` (o Numpad `-`) | Divide la pestaña con un panel **debajo** |
| **Dividir vertical** | `Ctrl + Shift + +` (o Numpad `+`) | Divide la pestaña con un panel a la **derecha** |
| **Auto-split (duplicar panel)** | `Alt + Shift + D` | Divide automáticamente en la dirección más larga |
| **Mover foco ←** | `Alt + ←` | Mueve el cursor al panel de la izquierda |
| **Mover foco →** | `Alt + →` | Mueve el cursor al panel de la derecha |
| **Mover foco ↑** | `Alt + ↑` | Mueve el cursor al panel de arriba |
| **Mover foco ↓** | `Alt + ↓` | Mueve el cursor al panel de abajo |
| **Redimensionar ←** | `Ctrl + Alt + ←` | Hace más pequeño el panel desde la izquierda |
| **Redimensionar →** | `Ctrl + Alt + →` | Hace más grande el panel hacia la derecha |
| **Redimensionar ↑** | `Ctrl + Alt + ↑` | Hace más alto el panel |
| **Redimensionar ↓** | `Ctrl + Alt + ↓` | Hace más bajo el panel |

| **Cerrar panel** | `Ctrl + Shift + W` | Cierra únicamente el panel seleccionado |

### ¿Cómo sé cuál es el panel activo (marco)?

Windows Terminal **no tiene un ajuste para ponerle un "marco de color" al panel activo**. Sin embargo, acabo de aplicarte un truco mucho mejor: 

**Los paneles inactivos se oscurecen (transparencia al 40%)**, mientras que el panel activo se mantiene iluminado (transparencia al 90%). ¡Esto hace que sea súper fácil saber dónde estás trabajando sin necesidad de un marco!

### Cómo usarlo paso a paso

1. **Crea tu primer split**: Estando en una pestaña, presiona `Ctrl+Shift+-` para dividir horizontalmente. Ahora tienes dos paneles uno sobre el otro.
2. **Agrega un split vertical**: Con el foco en uno de los paneles, presiona `Ctrl+Shift++` para dividir verticalmente.
3. **Auto-split rápido**: `Alt+Shift+D` divide automáticamente en la dirección que tenga más espacio.
4. **Navega entre paneles**: Usa `Alt + flechas` para moverte entre ellos. El panel activo tiene un borde resaltado.
5. **Redimensiona**: Usa `Ctrl+Alt + flechas` para ajustar el tamaño. Cada pulsación mueve el borde unos píxeles.
6. **Cerrar un panel**: Usa `Ctrl + Shift + W` para cerrar el panel activo, o escribe `exit` en su shell. El espacio se redistribuye automáticamente.

### Ejemplo de layout útil para desarrollo

```
┌──────────────────┬──────────────┐
│                  │              │
│   Editor/Código  │  Git Bash    │
│   (PowerShell)   │              │
│                  │              │
├──────────────────┴──────────────┤
│                                 │
│   Logs / Tests (Ubuntu WSL)     │
│                                 │
└─────────────────────────────────┘
```

Para crear este layout:
1. Abre una pestaña (PowerShell)
2. `Ctrl+Shift+-` → divide horizontal (ahora tienes arriba/abajo)
3. En el panel de arriba, `Ctrl+Shift++` → divide vertical (ahora tienes 3 paneles)
4. Usa `Alt+flechas` para navegar a cada panel

---

## 3. 🎨 Esquemas de Color por Perfil

### ¿Qué es?
Cada shell tiene un esquema de color diferente para que puedas identificar visualmente en qué entorno estás. Además, cada pestaña tiene un color de acento en la barra superior.

### Esquemas instalados

| Esquema | Usado en | Color de Pestaña | Estilo |
|---------|----------|-------------------|--------|
| **Tokyo Night** | Windows PowerShell | 🔵 `#7AA2F7` | Azul oscuro elegante con toques de rosa y amarillo |
| **Dracula** | Git Bash | 🩷 `#FF79C6` | Fondo púrpura oscuro con colores vibrantes |
| **Catppuccin Mocha** | Ubuntu, AlmaLinux, y default | 🟢 `#A6E3A1` / 🔴 `#F38BA8` | Fondo muy oscuro con colores pasteles suaves |

### Cómo identificar cada shell

Cuando abras la terminal, fíjate en:
- **El color de la pestaña** en la barra superior: cada shell tiene un color único
- **El fondo de la terminal**: cada esquema tiene un fondo ligeramente diferente
  - Tokyo Night: `#1A1B26` (azul muy oscuro)
  - Dracula: `#282A36` (gris-púrpura oscuro)  
  - Catppuccin Mocha: `#1E1E2E` (azul-gris muy oscuro)

### Cómo cambiar el esquema de un perfil

Edita el archivo `settings.json` y cambia `"colorScheme"` en el perfil deseado:
```json
{
    "name": "Git Bash",
    "colorScheme": "Tokyo Night"  // Cambia de Dracula a Tokyo Night
}
```

### Cómo cambiar el esquema predeterminado

Modifica en `profiles.defaults`:
```json
"defaults": {
    "colorScheme": "Dracula"  // Ahora todos los perfiles sin esquema propio usarán Dracula
}
```

---

## 4. 📋 Menú de Nueva Pestaña Organizado

### ¿Qué es?
Al hacer clic en el botón `+` o en la flecha `˅` junto a él, en vez de una lista plana de perfiles, ahora verás un menú organizado en carpetas.

### Estructura del menú

```
+ Nueva Pestaña ˅
├── 🐧 Linux
│   ├── Ubuntu
│   └── AlmaLinux-9
├── 🪟 Windows
│   ├── Windows PowerShell
│   └── Símbolo del sistema
├── 🛠️ Dev Tools
│   ├── Git Bash
│   ├── Developer Command Prompt for VS 18
│   └── Developer PowerShell for VS 18
├── ────────────── (separador)
└── Azure Cloud Shell
```

### Cómo usarlo

1. **Haz clic en la flecha `˅`** junto al botón `+` en la barra de pestañas
2. **Navega las carpetas** — haz clic en una carpeta para expandirla
3. **Selecciona un perfil** — haz clic en el perfil deseado para abrir una nueva pestaña con esa shell

### Cómo personalizar

Para agregar un nuevo perfil a una carpeta, edita la sección `newTabMenu` en `settings.json`:
```json
{
    "type": "folder",
    "name": "🐧 Linux",
    "entries": [
        { "type": "profile", "profile": "Ubuntu" },
        { "type": "profile", "profile": "AlmaLinux-9" },
        { "type": "profile", "profile": "Debian" }  // ← Nuevo perfil
    ]
}
```

---

## 5. 🔍 Paleta de Comandos

### ¿Qué es?
Un buscador de comandos estilo VS Code que te permite ejecutar cualquier acción de la terminal buscando por nombre.

### Atajo

| Acción | Atajo |
|--------|-------|
| **Abrir paleta** | `Ctrl + Shift + Espacio` |

### Cómo usarlo

1. Presiona `Ctrl + Shift + Espacio`
2. Aparece un campo de búsqueda en la parte superior de la terminal
3. Escribe lo que quieres hacer, por ejemplo:
   - `"new tab"` → crear nueva pestaña
   - `"split"` → ver opciones de dividir paneles
   - `"font"` → ajustar tamaño de fuente
   - `"color"` → cambiar esquema de colores
   - `"close"` → cerrar pestaña/panel
   - `"focus"` → entrar en modo focus
   - `"full"` → pantalla completa
4. Usa las flechas `↑↓` para navegar y `Enter` para ejecutar

> [!TIP]
> La paleta de comandos es la forma más rápida de descubrir funcionalidades. Si no recuerdas un atajo, simplemente búscalo aquí.

---

## 6. 🔎 Búsqueda de Texto

### ¿Qué es?
Busca texto dentro del buffer de la terminal (el historial visible y el scrollback).

### Atajo

| Acción | Atajo |
|--------|-------|
| **Buscar texto** | `Ctrl + Shift + F` |

### Cómo usarlo

1. Presiona `Ctrl + Shift + F`
2. Aparece una barra de búsqueda en la parte superior del panel
3. Escribe el texto que buscas
4. Las coincidencias se resaltan en el buffer
5. Usa las flechas en la barra de búsqueda para navegar entre coincidencias
6. Presiona `Escape` para cerrar la búsqueda

### Uso práctico
- Buscar un error específico en la salida de un `build`
- Encontrar una IP o URL en un log largo
- Localizar un commit hash en la salida de `git log`

---

## 7. 🔠 Zoom de Fuente

### ¿Qué es?
Ajusta el tamaño de la fuente en tiempo real sin editar la configuración.

### Atajos

| Acción | Atajo |
|--------|-------|
| **Aumentar fuente** | `Ctrl + +` (o Numpad `+`) |
| **Disminuir fuente** | `Ctrl + -` (o Numpad `-`) |
| **Restablecer tamaño** | `Ctrl + 0` |

### Cómo usarlo

- **Para presentaciones o pair programming**: `Ctrl + +` varias veces para agrandar
- **Para ver más contenido**: `Ctrl + -` para hacer más pequeña la fuente
- **Para volver al tamaño configurado** (12pt): `Ctrl + 0`

> [!NOTE]
> El cambio de zoom es **temporal** — solo afecta la sesión actual. Al abrir una nueva pestaña, vuelve al tamaño configurado (12).

---

## 8. 🖥️ Modos de Pantalla

### Pantalla Completa

| Acción | Atajo |
|--------|-------|
| **Alternar pantalla completa** | `Alt + Enter` |

- Oculta la barra de título, la barra de pestañas y la barra de tareas de Windows
- La terminal ocupa toda la pantalla
- Presiona `Alt + Enter` de nuevo para salir

### Modo Focus

| Acción | Atajo |
|--------|-------|
| **Alternar modo focus** | `Ctrl + Shift + P` |

- Oculta solo la barra de pestañas y el título
- La barra de tareas de Windows sigue visible
- Ideal para concentrarte en una sola tarea sin distracciones
- Presiona `Ctrl + Shift + P` de nuevo para salir

### Diferencia entre ambos

| Característica | Pantalla Completa | Modo Focus |
|----------------|-------------------|------------|
| Barra de pestañas | ❌ Oculta | ❌ Oculta |
| Barra de título | ❌ Oculta | ❌ Oculta |
| Barra de tareas Windows | ❌ Oculta | ✅ Visible |
| Uso típico | Trabajo inmersivo | Reducir distracciones |

---

## 9. 📋 Copiar y Pegar Inteligente

### Configuración aplicada

| Setting | Valor | Qué hace |
|---------|-------|----------|
| `copyOnSelect` | `true` | Al seleccionar texto con el mouse, se copia automáticamente al portapapeles |
| `copyFormatting` | `"none"` | Copia solo texto plano, sin colores ni formato (ideal para código) |
| `singleLine: false` | en acción `copy` | Al copiar, respeta los saltos de línea del texto seleccionado |

### Atajos

| Acción | Atajo |
|--------|-------|
| **Copiar** | `Ctrl + C` (o simplemente seleccionar con mouse) |
| **Pegar** | `Ctrl + V` |

### Cómo funciona

1. **Copiar con mouse**: Selecciona texto arrastrando el mouse → se copia automáticamente
2. **Copiar con teclado**: Selecciona texto y presiona `Ctrl + C`
3. **Pegar**: `Ctrl + V` en cualquier momento

> [!IMPORTANT]
> `Ctrl+C` tiene doble función: si hay texto seleccionado, **copia**. Si no hay texto seleccionado, **envía la señal de interrupción** (SIGINT) al proceso, como siempre.

---

## 10. 📜 Scroll Mejorado

### Configuración aplicada

| Setting | Valor | Qué hace |
|---------|-------|----------|
| `historySize` | `9999` | Guarda las últimas 9,999 líneas de salida (antes era ~9000 por defecto) |
| `snapOnInput` | `true` | Al escribir algo, el scroll salta automáticamente al final |
| `scrollbarState` | `"visible"` | La barra de scroll siempre es visible |

### Atajos de Scroll

| Acción | Atajo |
|--------|-------|
| **Scroll página arriba** | `Ctrl + Shift + Page Up` |
| **Scroll página abajo** | `Ctrl + Shift + Page Down` |

### También puedes
- **Rueda del mouse** para scroll suave
- **Click en la barra de scroll** para saltar rápidamente

---

## 11. 🎛️ Configuración Visual Global

### Valores aplicados

| Setting | Valor | Efecto |
|---------|-------|--------|
| `centerOnLaunch` | `true` | La ventana se centra en la pantalla al abrir |
| `theme` | `"dark"` | Interfaz de la terminal (barra de título, menús) en modo oscuro |
| `initialCols` | `120` | La ventana inicia con 120 columnas de ancho |
| `initialRows` | `30` | La ventana inicia con 30 filas de alto |
| `tabWidthMode` | `"equal"` | Todas las pestañas tienen el mismo ancho |
| `confirmCloseAllTabs` | `true` | Pide confirmación si cierras la ventana con múltiples pestañas abiertas |
| `bellStyle` | `"none"` | Sin sonido de campana (sin beeps molestos) |
| `opacity` | `90` | Transparencia del 10% (90 = 90% opaco) |
| `useAcrylic` | `false` | Usa transparencia nativa (Mica) en vez de Acrílico |
| `cursorShape` | `"bar"` | Cursor delgado tipo barra vertical (como VS Code) |
| `padding` | `"8, 8, 8, 8"` | 8px de margen interno en todos los lados |

### Opciones alternativas que puedes cambiar

**Cursor** — Cambia `cursorShape` a:
- `"bar"` → Línea vertical delgada (actual) `|`
- `"vintage"` → Bloque inferior `▃`
- `"underscore"` → Guión bajo `_`
- `"filledBox"` → Bloque completo `█`
- `"emptyBox"` → Bloque vacío `▯`

**Opacidad** — Cambia `opacity` (0-100):
- `100` → Totalmente opaco
- `90` → Ligeramente transparente (actual)
- `70` → Bastante transparente
- `50` → Muy transparente

**Tabs** — Cambia `tabWidthMode` a:
- `"equal"` → Mismo ancho para todas (actual)
- `"titleLength"` → Ancho según el largo del título
- `"compact"` → Pestañas muy pequeñas, solo muestran el ícono

---

## 12. 🔧 Profile Defaults vs. Perfiles Individuales

### ¿Cómo funciona la herencia?

```
profiles.defaults (configuración base)
    ↓ heredan todos los perfiles
    ↓
profiles.list[n] (puede sobreescribir valores específicos)
```

**Ejemplo**: `defaults` define `colorScheme: "Catppuccin Mocha"`, pero el perfil de PowerShell lo sobreescribe con `colorScheme: "Tokyo Night"`.

| Perfil | Esquema de Color | ¿Hereda de defaults? |
|--------|-----------------|----------------------|
| Windows PowerShell | Tokyo Night | ❌ Sobreescrito |
| Símbolo del sistema | Catppuccin Mocha | ✅ Hereda |
| Git Bash | Dracula | ❌ Sobreescrito |
| AlmaLinux-9 | Catppuccin Mocha | ❌ Explícito pero igual |
| Ubuntu | Catppuccin Mocha | ❌ Explícito pero igual |
| Azure Cloud Shell | Catppuccin Mocha | ✅ Hereda |
| Dev Command Prompt | Catppuccin Mocha | ✅ Hereda |
| Dev PowerShell | Catppuccin Mocha | ✅ Hereda |

---

## 13. 🎨 Prompt Visual (Oh My Posh)

### ¿Qué es?
Reemplaza el texto predeterminado de tu consola con una interfaz visual avanzada. Se configuró para cargar automáticamente al abrir PowerShell 7 usando el tema `catppuccin_mocha` para combinar con tu terminal.

### Funcionalidades
- Muestra el directorio actual con iconos.
- En repositorios de **Git**, te muestra la rama en la que estás y el estado (modificados, nuevos, etc.).
- Muestra la duración del último comando si tomó más de 2 segundos.
- Muestra indicadores de error (código de salida) en rojo si un comando falla.

---

## 14. 🧠 Autocompletado Predictivo (PSReadLine)

### ¿Qué es?
Mientras escribes en PowerShell, la consola buscará en tu historial de comandos y te sugerirá el comando completo en color gris oscuro.

### Atajos

| Acción | Atajo |
|--------|-------|
| **Aceptar sugerencia** | `Flecha Derecha (→)` |
| **Aceptar sugerencia palabra por palabra** | `Ctrl + Flecha Derecha` |

### Cómo usarlo
Si necesitas conectarte a un servidor por SSH, y comienzas a escribir `ssh`, verás que el resto de la dirección IP que usaste ayer aparece en gris oscuro. Solo presiona `→` y presiona `Enter`. ¡Magia!

---

## 15. ⚡ Modo Quake (Terminal Global Desplegable)

### ¿Qué es?
El "Quake Mode" te permite abrir una ventana de terminal instantánea en la parte superior de tu pantalla, sin importar qué aplicación estés usando (estilo ventana desplegable de videojuegos).

### Atajo Global

| Acción | Atajo |
|--------|-------|
| **Invocar/Ocultar Modo Quake** | `Ctrl + Win + T` |

### Cómo usarlo
1. Estás navegando en Chrome leyendo un tutorial.
2. Presionas `Ctrl + Win + T`.
3. Baja una terminal desde el borde superior de tu monitor.
4. Escribes tu comando (`ping google.com`, por ejemplo).
5. Vuelves a presionar `Ctrl + Win + T` (o haces clic en tu navegador) y la terminal se esconde, lista para cuando la vuelvas a necesitar en ese mismo estado.

---

## 16. 📂 Iconos en Archivos y Carpetas (Terminal-Icons)

### ¿Qué es?
Un módulo que intercepta el comando `ls` (Get-ChildItem) para dibujar iconos de colores a un lado de cada archivo o carpeta. Depende de la fuente "Nerd Font" que ya instalamos.

### Cómo usarlo
¡No tienes que hacer nada nuevo! Solo escribe `ls` o `dir` en cualquier carpeta que tenga archivos (como código, imágenes, zips) y verás cómo mágicamente cada tipo de archivo tiene su propio ícono y color.

---

## 17. 🔍 Buscador de Historial y Archivos (FZF)

### ¿Qué es?
`fzf` es un buscador súper rápido ("Fuzzy Finder") integrado a tu terminal. Te permite buscar comandos viejos o archivos interactuando con un menú visual en vez de presionar la flecha hacia arriba cientos de veces.

### Atajos

| Acción | Atajo |
|--------|-------|
| **Buscar en el Historial de Comandos** | `Ctrl + R` |
| **Buscar Archivos en la carpeta actual** | `Ctrl + T` |

### Cómo usarlo
1. **Historial (`Ctrl + R`)**: Presiónalo y escribe cualquier fragmento de un comando viejo (ej. `dock log`). Te mostrará al instante todos los comandos de `docker logs` que hayas corrido hace días. Muévete con las flechas y presiona `Enter` para usarlo.
2. **Archivos (`Ctrl + T`)**: Presiónalo y busca un archivo. Cuando lo selecciones, su ruta se pegará automáticamente en la línea de comandos actual.

---

## 🏷️ Referencia Rápida — Todos los Atajos

### Pestañas
| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+T` | Nueva pestaña |
| `Ctrl+Shift+W` | Cerrar panel / pestaña |
| `Ctrl+Tab` | Siguiente pestaña (MRU) |
| `Ctrl+Shift+Tab` | Pestaña anterior |
| `Ctrl+1` a `Ctrl+5` | Ir a pestaña N |
| `Ctrl+Shift+D` | Duplicar pestaña |
| `Ctrl+Shift+R` | Renombrar pestaña |

### Paneles
| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+-` | Split horizontal |
| `Ctrl+Shift++` | Split vertical |
| `Alt+Shift+D` | Auto-split (duplicar panel) |
| `Alt+←→↑↓` | Mover foco entre paneles |
| `Ctrl+Alt+←→↑↓` | Redimensionar panel |

### General
| Atajo | Acción |
|-------|--------|
| `Ctrl+Shift+Space` | Paleta de comandos |
| `Ctrl+Shift+F` | Buscar texto |
| `Ctrl+C` | Copiar (o interrumpir) |
| `Ctrl+V` | Pegar |
| `Ctrl++` | Zoom in |
| `Ctrl+-` | Zoom out |
| `Ctrl+0` | Reset zoom |
| `Alt+Enter` | Pantalla completa |
| `Ctrl+Shift+P` | Modo focus |
| `Ctrl+Shift+PgUp` | Scroll página arriba |
| `Ctrl+Shift+PgDn` | Scroll página abajo |
| `Ctrl+Win+T` | Mostrar/Ocultar Modo Quake |
| `Ctrl+R` | (FZF) Buscar en el historial de comandos |
| `Ctrl+T` | (FZF) Buscar archivo y pegar su ruta |

---

## 🔄 Cómo Restaurar la Configuración Anterior

Si necesitas volver a tu configuración original:

```powershell
copy settings.json.bak settings.json
```

Ruta completa:
```
C:\Users\steranf\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\
```

> [!TIP]
> Windows Terminal detecta los cambios en `settings.json` automáticamente. Al restaurar el respaldo, la terminal se actualiza sin necesidad de reiniciar.
