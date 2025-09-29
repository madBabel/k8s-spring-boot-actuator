#  Traffic Generator Script

Este script en **Bash** envía solicitudes HTTP de manera periódica a una URL objetivo, mostrando la respuesta junto con la marca de tiempo en la que fue recibida.

## 📋 Uso

```bash
./script.sh <target> <interval-in-seconds>
```

- `<target>` → URL o endpoint al que se enviarán las solicitudes.  
- `<interval-in-seconds>` → Intervalo en segundos entre cada solicitud.  

Si no se proporcionan ambos parámetros, el script mostrará un mensaje de uso y se detendrá.

## 🔧 Ejemplo

```bash
./script.sh https://example.com 5
```

Esto enviará una solicitud a `https://example.com` cada **5 segundos**, imprimiendo en consola la fecha, hora y el contenido de la respuesta.

## 📤 Salida esperada

```text
Sending requests to https://example.com every 5 seconds.
[2025-09-29 14:23:01] <contenido de la respuesta>
[2025-09-29 14:23:06] <contenido de la respuesta>
[2025-09-29 14:23:11] <contenido de la respuesta>
...
```

## ⚠️ Notas

- El script usa `curl`, por lo que debe estar instalado en tu sistema.  
- Se ejecuta en bucle infinito hasta que lo detengas manualmente (ej. `Ctrl+C`).  
- Útil para monitorear la disponibilidad de un servicio o hacer pruebas de endpoints.  


