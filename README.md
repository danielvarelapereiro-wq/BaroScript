# *BaroScript*
Una aplicacion para buceo profesional.

## Tecnologías necesarias para prueba:
### Software necesario:
- IntelliJ
- Android Studio
- Docker

Actualmente la app unicamente tiene integrada la base de datos de la api, con lo que solo puede probarse mediante PhpMyAdmin.


## Como preparar el proyecto para su ejecución:

### Dentro del repositorio de BaroScript
- Darle a code/Download Zip
- Descomprimir el contenido del Zip en una carpeta
- Dentro de esa carpeta se descomprimiran dos carpetas, BaroScript_Api y BaroScript_App
- BaroScript_Api, proyecto de IntelliJ
- BaroScript_App, proyecto de Android
- Actualmente(15/04/2026), montar solo BaroScript_Api, dado que BaroScript_App, solo tiene Hello Word!
### Una vez cargado el proyecto en IntelliJ
- Las dependencias necesarias, están integradas en el proyecto
- El archivo .env.example de la carpeta raiz, contiene las contraseñas para el profesorado
- Eliminar de el archivo .env.example, el .example
- Para poder utilizar de forma adecuada el archivo .env:
  - Instala el Plugin "EnvFile" en IntelliJ
    - Ve a Settings (o Preferences en Mac) -> Plugins.
    - Busca e instala "EnvFile".
    - Reinicia IntelliJ.
  - Configura tu aplicación para leer el .env:
    - En la parte superior de IntelliJ, haz clic en el desplegable donde aparece el nombre de tu aplicación y selecciona Edit Configurations....
    - Selecciona tu aplicación de Spring Boot a la izquierda.
    - Verás una nueva pestaña llamada EnvFile.
    - Haz clic en Enable EnvFile.
    - Pulsa el botón + (plus), selecciona .env file y busca tu archivo .env en la raíz del proyecto.
    - Dale a Apply y OK.

- Una vez configurado IntelliJ para el archivo .env, ponga en la terminal de IntelliJ el comando: docker-compose up --build
- Acceda a un explorador de internet.
- Ponla en la URL http://localhost:8081/
- Desde ahí, podrá comprobar la base de datos de la API, que actualmente <15/04/2026>, es lo único que se puede realizar con la app.


