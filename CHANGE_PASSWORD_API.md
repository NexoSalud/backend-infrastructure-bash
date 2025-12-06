# 🔐 Endpoint de Cambio de Contraseña

## **POST** `/api/v1/auth/change-password/{token}`

Este endpoint permite a los usuarios cambiar su contraseña utilizando un token JWT válido.

### **Proceso de Validación:**

1. **Extracción del token**: Se extrae el `employee_id` del token JWT proporcionado en la URL
2. **Validación del token**: Se verifica que el token sea válido y no haya expirado
3. **Comparación de IDs**: Se compara el `employee_id` del token con el enviado en el payload
4. **Actualización**: Si todo es válido, se envía una petición PATCH al módulo de empleados

### **Payload Requerido:**

```json
{
  "employee_id": "string",
  "new_password": "string"
}
```

### **Flujo de Validación:**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Cliente       │    │    Gateway       │    │   Employees     │
│                 │    │                  │    │                 │
│ POST /change-   │───▶│ 1. Validar token │    │                 │
│ password/{token}│    │ 2. Extraer       │    │                 │
│                 │    │    employee_id   │    │                 │
│ {employee_id,   │    │ 3. Comparar IDs  │    │                 │
│  new_password}  │    │ 4. Si válido:    │───▶│ PATCH /employees│
│                 │    │                  │    │ /{id}/password  │
│                 │    │                  │    │                 │
│ ◀───────────────│────│ 5. Respuesta     │◀───│ Password updated│
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### **Respuestas Posibles:**

#### **✅ Éxito (200 OK):**
```json
"Contraseña actualizada exitosamente"
```

#### **❌ Token inválido (401 Unauthorized):**
```json
"Token inválido"
```

#### **❌ Sin employee_id en token (401 Unauthorized):**
```json
"Token no contiene employee_id"
```

#### **❌ IDs no coinciden (403 Forbidden):**
```json
"El employee_id del token no coincide con el de la solicitud"
```

#### **❌ Error comunicación (500 Internal Server Error):**
```json
"Error de comunicación con el servicio de empleados"
```

### **Ejemplo de Uso:**

```bash
# Ejemplo con curl
curl -X POST "http://localhost:8080/api/v1/auth/change-password/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "employee_id": "12345",
    "new_password": "nuevaPassword123!"
  }'
```

### **Notas Importantes:**

- 🔒 **Seguridad**: El token debe contener el `employee_id` válido
- 🔍 **Validación**: Se verifica que el employee_id del token coincida con el del payload
- 🔐 **Encriptación**: La nueva contraseña se encripta automáticamente con BCrypt
- 🌐 **Comunicación**: El gateway se comunica con el módulo employees en puerto 8082
- ⚡ **Sin autenticación JWT**: Este endpoint está excluido del filtro JWT (el token se valida manualmente)