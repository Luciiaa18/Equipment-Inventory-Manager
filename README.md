# README - Gestió d'Inventari de Màquines i Sistemes

## Descripció del Projecte

Aquest projecte, desenvolupat en Eclipse IDE, utilitza una combinació de tecnologies com Java, JavaScript, CSS i JSP per proporcionar una eina eficient i fàcil d'usar per a la gestió i visualització de l'inventari. L'aplicació permet als usuaris interactuar amb una base de dades per realitzar operacions essencials com afegir, modificar, eliminar i consultar registres d'inventari. 

## Estructura del Projecte

### Directori Principal

- **`src/`**: Conté el codi font Java.
  - **`main/java/`**: Conté les classes Java.
  - **`main/resources/`**: Arxius de configuració i recursos.
- **`webapp/`**: Conté els fitxers JSP, CSS, i JavaScript.
  - **`WEB-INF/`**: Configuració de la web i arxius de configuració.
- **`lib/`**: Dependències de Java (fitxers JAR).
- **`build/`**: Fitxers generats pel sistema de construcció.

### Requisits del Sistema

- **Eclipse IDE for Java Developers** (versió recomanada: 2023-03 o superior)
- **Java Development Kit (JDK)** (versió recomanada: 8 o superior)
- **Apache Tomcat** (versió recomanada: 8.0 o superior)
- **MySQL Server** (versió recomanada: 5.7 o superior)
- **Driver JDBC per a MySQL**

### Configuració de la Base de Dades

1. **Configuració del Connector JDBC:**
   - Incloure el fitxer JAR del connector JDBC en el projecte (directori `lib/`).

2. **Configuració del Servidor de Base de Dades:**
   - URL: `jdbc:mysql://172.22.1.61:3306/INVENTARI`
   - Usuari: `user`
   - Contrasenya: `root`

3. **Classe de Connexió:**
   - `DatabaseConnector`: Gestiona la connexió automàtica a la base de dades. Verifiqueu que les credencials són correctes i que el servidor està en funcionament.

### Dependències

Assegureu-vos que les següents dependències estan incloses en el projecte:

- **JDBC Driver** per a MySQL.
- **Biblioteques** necessàries per al funcionament d’Apache Tomcat i les operacions AJAX.

### Configuració de Tomcat

1. **Desplegament:**
   - Configurar Apache Tomcat per desplegar l’aplicació. Assegureu-vos que el fitxer WAR es desplaça correctament al directori de desplegament.

2. **Port i URL:**
   - Assegureu-vos que Tomcat està configurat per escoltar al port 8080 (o el port configurat).

### Construcció i Executable

- **Construcció del Projecte:**
  - Utilitzeu Eclipse per compilar i construir el projecte. Assegureu-vos que no hi hagi errors de compilació.

- **Execució:**
  - Després de la construcció, executeu l'aplicació (index.jsp) des de Tomcat per assegurar-vos que tot el sistema està operatiu.

### Maneig d'Errors

- **Errors de Connexió:** Comproveu els missatges a la consola de Tomcat.
- **Errors AJAX:** Els errors es mostraran a la consola del navegador per a diagnòstic.

### Documentació Addicional

Per a informació addicional sobre la configuració, desenvolupament, i desplegament, consulteu els fitxers de configuració en el directori `WEB-INF/` i les classes Java en `src/main/java/`.

### Contacte

Aquest projecte ha estat creat per Lucia Plasencia Ortega. Per a qualsevol dubte o consulta, podeu contactar a l'email: lucia.plasencia01@estudiant.upf.edu
