
# 🌐 Flutter Web - Interfaz de Autenticación y Gestión

Este proyecto Flutter Web es la interfaz de usuario para autenticar usuarios, gestionar empleados y consumir publicaciones desde una API. Compatible con cualquier navegador moderno.

## 🧰 Requisitos

- Flutter 3.x o superior
- Navegador moderno (Chrome, Firefox, Edge)
- Backend corriendo localmente o en servidor

## 🧪 Funcionalidades implementadas

✅ Registro y login de usuarios

✅ Validación de RFC y contraseñas

✅ Cambio de contraseña

✅ CRUD de empleados con búsqueda y edición

✅ Consumo de servicios externos (jsonplaceholder.typicode.com)

✅ Diseño responsivo básico

## 🌍 Configuración del backend

Asegúrate de que las URLs en auth_service.dart, empleado_service.dart, y post_service.dart apunten correctamente a tu servidor:

final url = Uri.parse('http://localhost:3000/api/auth/login');

## Ejecucion del proyecto

flutter run -d chrome



## 🔧 Instalación

```bash
git clone https://github.com/JoeVieyra/flutter_web
cd flutter_web
flutter pub get


![alt text](<Captura desde 2025-05-04 13-57-38.png>)