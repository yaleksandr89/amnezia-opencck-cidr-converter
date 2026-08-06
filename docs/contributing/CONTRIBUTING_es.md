# Contribuir al proyecto

## Elija un idioma

| Русский | English | Español | 中文 | Français | Deutsch |
|---|---|---|---|---|---|
| [Русский](../../.github/CONTRIBUTING.md) | [English](./CONTRIBUTING_en.md) | **Seleccionado** | [中文](./CONTRIBUTING_zh.md) | [Français](./CONTRIBUTING_fr.md) | [Deutsch](./CONTRIBUTING_de.md) |

Gracias por su interés en el proyecto.

## Antes de comenzar

- Cree un Issue para un error reproducible.
- Utilice la categoría Q&A de Discussions para preguntas de uso.
- Discuta los cambios grandes antes de implementarlos.

## Implementaciones

El proyecto contiene dos implementaciones nativas del mismo comportamiento:

- `src/convert-opencck-cidr.ps1` — Windows;
- `src/convert-opencck-cidr.sh` — macOS y Linux.

Los cambios en la lógica de conversión deben aplicarse a ambas implementaciones, salvo que una diferencia específica de plataforma esté claramente justificada.

Los mensajes para el usuario admiten ruso e inglés. Actualice ambas localizaciones al añadir o modificar un mensaje.

## Ramas

```text
feature/add-cidr6-support
fix/windows-path-handling
docs/update-linux-guide
```

## Commits

Se recomienda utilizar Conventional Commits:

```text
feat: add local JSON input
fix: preserve CIDR prefix during conversion
docs: clarify platform requirements
test: cover duplicate CIDR entries
chore: update GitHub workflow
```

## Comprobación local

Windows:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\run-tests.ps1
```

macOS y Linux:

```bash
./tests/run-tests.sh
```

## Pull requests

Describa:

- el problema que resuelve el cambio;
- cómo verificar el resultado;
- las plataformas afectadas;
- si ambas implementaciones están sincronizadas;
- si los mensajes en ruso e inglés están sincronizados;
- si es necesario actualizar la documentación.

No añada configuraciones privadas, claves, tokens, direcciones de servidores personales ni listas de rutas generadas.
