# 📧 Endpoint de Reset de Contraseña

## **POST** `/api/v1/employees/{employee_id}/reset-password`

Este endpoint permite generar un token JWT de recuperación de contraseña y enviarlo por email al empleado.

### **Funcionalidad:**

1. **Validación**: Verifica que el empleado existe en la base de datos
2. **Búsqueda de Email**: Busca el email del empleado en sus atributos personalizados
3. **Generación de Token**: Crea un JWT con vigencia de 1 hora que contiene:
   - `employee_id`: ID del empleado
   - `purpose`: "password_reset"
   - `exp`: Fecha de expiración (1 hora)
4. **Envío de Email**: Envía un email con el enlace de recuperación

### **Parámetros:**

- **Path Parameter**: `employee_id` (Integer) - ID del empleado

### **Respuestas Posibles:**

#### **✅ Éxito (200 OK):**
```json
"Password reset email sent successfully"
```

#### **❌ Empleado no encontrado (404 Not Found):**
```json
"Employee not found"
```

#### **❌ Email no encontrado (400 Bad Request):**
```json
"Employee email not found"
```

#### **❌ Error envío email (500 Internal Server Error):**
```json
"Failed to send password reset email"
```

### **Configuración de Email:**

Las configuraciones se manejan mediante variables de entorno:

#### **📧 Configuración SMTP:**
```bash
# Servidor SMTP
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USERNAME=tu-email@gmail.com
EMAIL_PASSWORD=tu-app-password

# Configuración del remitente
EMAIL_FROM=no-reply@nexosalud.com
```

#### **📝 Configuración del Mensaje:**
```bash
# Asunto del email
EMAIL_RESET_PASSWORD_SUBJECT="Recuperación de Contraseña - Nexo Salud"

# Texto del cuerpo del email
EMAIL_RESET_PASSWORD_TEXT="Estimado usuario, para recuperar su contraseña haga clic en el siguiente enlace:"

# URL del sitio web para reset
EMAIL_RESET_PASSWORD_WEBSITE="https://nexosalud.com/reset-password"
```

### **Formato del Email Enviado:**

```
Asunto: Recuperación de Contraseña - Nexo Salud

Cuerpo:
Estimado usuario, para recuperar su contraseña haga clic en el siguiente enlace:

https://nexosalud.com/reset-password?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

Este enlace expirará en 1 hora.
Si no solicitó este cambio, ignore este mensaje.

Atentamente,
Equipo Nexo Salud
```

### **Token JWT Generado:**

```json
{
  "employee_id": "123",
  "purpose": "password_reset",
  "iat": 1701234567,
  "exp": 1701238167
}
```

### **Ejemplo de Uso:**

```bash
# Solicitar reset de contraseña
curl -X POST "http://localhost:8082/api/v1/employees/123/reset-password"

# Respuesta exitosa
HTTP/1.1 200 OK
Content-Type: text/plain
"Password reset email sent successfully"
```

### **Flujo Completo:**

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Cliente       │    │   Employees      │    │   Email Server  │
│                 │    │                  │    │                 │
│ POST /employees │───▶│ 1. Validar       │    │                 │
│ /123/reset-     │    │    employee_id   │    │                 │
│ password        │    │ 2. Buscar email  │    │                 │
│                 │    │ 3. Generar JWT   │    │                 │
│                 │    │ 4. Enviar email  │───▶│ Email con token │
│ ◀───────────────│────│ 5. Respuesta     │    │                 │
│ "Email sent     │    │                  │    │                 │
│ successfully"   │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### **Seguridad:**

- 🔐 **Token JWT**: Firmado con clave secreta configurable
- ⏰ **Expiración**: 1 hora de vigencia
- 🎯 **Propósito específico**: Token solo válido para reset de contraseña
- 📧 **Email verificado**: Solo se envía a emails registrados en atributos del empleado

### **Variables de Entorno de Desarrollo:**

```bash
# Para testing local
EMAIL_HOST=localhost
EMAIL_PORT=1025
EMAIL_USERNAME=test
EMAIL_PASSWORD=test
EMAIL_FROM=test@nexosalud.com
EMAIL_RESET_PASSWORD_WEBSITE=http://localhost:3000/reset-password
```

### **Notas Importantes:**

- ⚡ El empleado debe tener un atributo "email" configurado
- 📧 Configurar correctamente el servidor SMTP antes de usar en producción  
- 🔑 Para Gmail, usar "App Password" en lugar de contraseña normal
- 🏥 El módulo se ejecuta en puerto 8082
- 💾 Usar la base de datos `employeesdb` con PostgreSQL