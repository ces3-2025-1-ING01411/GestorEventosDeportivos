# GestorEventosDeportivos

Este proyecto es una aplicación web desarrollada en Java que utiliza Servlets y JSP para consumir APIs REST.

## 📁 Estructura del Proyecto

```
GestorEventosDeportivos/
│── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── co/
│   │   │   │   ├── edu/
│   │   │   │   │   ├── poli/
│   │   │   │   │   │   ├── ces3/
│   │   │   │   │   │   │   ├── gestoreventosdeportivos/
│   │   │   │   │   │   │   │   ├── dao/                # Clases de acceso a datos (Data Access Object)
│   │   │   │   │   │   │   │   ├── controllers/        # Servlets para manejar las peticiones HTTP
│   │   │   │   │   │   │   │   ├── services/           # Lógica de negocio y consumo de APIs REST
│   │   │   │   │   │   │   │   ├── utils/              # Utilidades para manejo de peticiones y respuestas
│   │   ├── webapp/
│   │   │   ├── WEB-INF/
│   │   │   │   ├── web.xml          # Configuración de la aplicación web
│   │   │   ├── views/
│   │   │   │   ├── equipos.jsp        # Página para mostrar equipos
│   │   │   │   ├── eventos.jsp        # Página para mostrar eventos
│   │   │   │   ├── index.jsp          # Página principal de la aplicación, con calculos de los datos de las clases
│   │   │   │   ├── jugadores.jsp      # para mostrar jugadores
│── pom.xml 
│── README.md

```

## Configuración y Ejecución

### Requisitos
- JDK 11 o superior
- Apache Tomcat 9 o superior
- Maven o Gradle (según el gestor de dependencias que uses)

###  Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/ces3-2025-1-ING01411/GestorEventosDeportivos.git
   cd mi-proyecto
   ```

2. Si usas Maven, ejecuta:
   ```bash
   mvn clean install
   ```
   Si usas Gradle:
   ```bash
   gradle build
   ```

###  Ejecución

1. Inicia el servidor Tomcat y despliega la aplicación en `webapps/`.
2. Accede desde tu navegador:
   ```
   http://localhost:8081/gestor-eventos-deportivos/index.jsp
   ```

### 4️⃣ Uso de APIs REST en los Servlets

Los Servlets consumen las APIs REST mediante peticiones HTTP usando `HttpURLConnection` o `HttpClient`. Un ejemplo de uso dentro de un Servlet sería:
```java
URL url = new URL("https://api.example.com/data");
HttpURLConnection con = (HttpURLConnection) url.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
```

## 🛠 Tecnologías Usadas
- Java EE
- Servlets y JSP
- Tomcat
- Maven/Gradle

# Imagenes página

## Estadisticas
![image](https://github.com/user-attachments/assets/67086c65-aa3d-4d41-8058-d35e21a40ecd)


