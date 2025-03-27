# Banco
 Proyecto de banco con MVC

## Requisitos del sistema

### 1. Java JDK instalado y configurado (JAVA_HOME y PATH)

### 2. Git

### 3. MySQL o MariaDB

## Como ejecutar el proyecto

En primer lugar es necesario disponer de un archivo JAR o WAR (si fuera una aplicación web) que usualmente estará alojado en la carpeta target del proyecto. 

Para ejecutar el proyecto, nos ubicamos donde está el archivo JAR, y lo ejecutamos con java y la opción -jar seguido del nombre del archivo.

```bash
cd target
java -jar banco-jar-with-dependencies.jar
```
También está disponible la opción de ejecución con el plugin de maven a traves del siguiente comando
```bash
maven exec:exec
```

# IMPORTANTE
Para que la aplicación se ejecute correctamente es necesario que la carpeta *'cfg'* (que contiene los archivos de configuracion) se encuentre en la misma carpeta que el archivo JAR.
Ademas debe estar en ejecución la base de datos.
