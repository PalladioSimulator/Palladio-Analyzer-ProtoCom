# Einleitung
Ziel des Praktikums war, Protocom so zu erweitern, das es als Microservices genutzt werden kann. Eine Implementierung wurde hierfür in Eclipse Microprofile erstellt.
# Was es bisher gibt
Protocom ist ein Addon für Palladio. Es ermöglicht Prototypen und Code Stubs aus einem Palladio Modell zu generieren. Um solche Prototypen zu erstellen, nutzt Protocom Xtext zur Modell zu Text Transformation.
Dazu werden u. a. verschiedene Hardwareanforderungen in Java generiert, um eine verwendete Hardwareumgebung unterschiedlich auszulasten (z. B. verschiedene Auslastungsarten der CPU).
Maßgeblich sind dabei die sogenannten SEFF (Service Effect Specifications). Hierfür werden im Code einzelne Java Methoden angelegt, die diese SEFF umsetzen.
Die Komponenten aus dem Palladio Modell werden als Java Klassen generiert und enthalten die jeweiligen Java Methoden.
Um zwischen den Komponenten kommunizieren zu können, gibt es in Protocom mehrere Implementierungen. Die erste funktionsfähige Implementierung in Java SE nutzt als Technologie Java RMI (Remote Method Invocation). Dies ermöglicht Aufrufe auf Methoden von Java Objekten, die sich in einer anderen Java Virtual Machine befinden können.
Die zweite Implementierung wurde in Java EE umgesetzt. Hier werden die gleichen Methoden wie in Java SE generiert. Die Klassen werden als Enterprise JavaBeans erstellt. Dadurch ist ebenfalls ein mehrschichtiges verteiltes Softwaresystem möglich.
# Idee des Praktikums
Das Praktikum wurde mit dem Ziel gestartet, die verwendete Technik in Protocom zu aktualisieren. Das übergeordnete Ziel ist, moderne Deployments in (Docker) Container als Microservice zu ermöglichen. Dies ist bisher nicht möglich gewesen.
Um dieses Ziel zu erreichen, wurde in dem Praktikum Eclipse Microprofile als Zielplattform verwendet. Diese nutzt nicht RMI oder JavaBeans als Kommunikation zwischen Komponenten, sondern REST.
# Grundlagen
Umgesetzt wurde das Praktikum mit Open Liberty. Das ist eine Implementierung des Eclipse Microprofile Standard.
Open Liberty umfasst sämtliche Schnittstellen, die im Microprofile Standard definiert sind: Dazu gehören unter anderem:
* JAX-RS
* Context and Dependency Injection (CDI)
* JSON-B
* OpenAPI
* RestClient
## JAX-RS
Die "Java API for RESTful Web Services" (JAX-RS) ist eine Java Schnittstelle, die das verwenden des Architekturstils REST in einem Java Projekt für Webservices ermöglicht. Im vorliegenden Code wird es bei den Annotationen verwendet. So kann darüber der Pfad einer Ressource generiert werden.
 
## Context and Dependency Injection
Context and Dependency Injection beschreibt einen Java-Standard, der es ermöglicht, Abhängigkeiten zwischen verschiedenen Modulen durch Injektion aufzulösen.
Dazu muss einem Modul die Ressource bekannt gemacht werden. Diese wird dann automatisch an den benötigten Stellen im Programm injiziert. In Open Liberty werden die Module über die jvm.options Datei bekannt gegeben. Anschließend wird über die Inject Annotation das Modul an der entsprechenden Stelle eingefügt.

## JSON-B
JSON-B ist eine Java Schnittstelle, die Java Objekte auf JSON Nachrichten abbildet. Dadurch ist es möglich, JSON Nachrichten als eine Sicht auf Java Objekte zu verwenden. Im Code wird JSON-B implizit für die Instanzen der Java Klasse StackContext und SimulatedStackFrame verwendet. Dadurch können diese im JSON Format übertragen werden.

## OpenAPI
OpenAPI ist eine Java Schnittstelle zur Veröffentlichung einer Dokumentation der bereitgestellten Schnittstelle. Diese wird im Praktikum dazu verwendet, um eine Übersicht über die generierten Schnittstellen zu bekommen. Als grafische Oberfläche wird Swagger verwendet. Nachdem Open Liberty gestartet wurde ist diese unter http://localhost:9080/openapi/ui/ erreichbar.

# Code
In diesem Abschnitt werden die konkreten technischen Aspekte des Praktikums beschrieben.

## Herunterladen/Ausführen
Bevor das Projekt bearbeitet werden kann, wird Java als Laufzeitumgebung benötigt.
Da das Projekt selber und einige Teile von Palladio mit Java Version 11 entwickelt wurden, empfiehlt es sich, diese Version zu installieren und unter Windows in den Umgebungsvariablen einzutragen. Für das Praktikum wurde **AdoptOpenJDK 11.0.7.10 Hotspot** verwendet.
Um das Projekt weiter entwickeln zu können, wird die Entwicklungsumgebung Eclipse mit den Palladio Plug-Ins benötigt. 
Diese kann automatisch mit dem Oomph Installer erstellt werden.  
Dazu sind folgende Schritte notwendig:
1. Eclipse Installer unter https://www.eclipse.org/downloads/ herunterladen (verwendete Eclipse Version 2020-06 R)
2. Installer ausführen
3. Auf dem Startbildschirm rechts oben die drei Querbalken anklicken und "Advanced Mode" auswählen
4. Einen Speicherort für den Eclipse Installer festlegen und eventuell die Checkboxen für die Shortcuts an- oder abwählen
5. Das anschließende Fenster schließen und den Speicherort des Installer aufrufen
6. Die dortige eclipse-inst.ini um folgende Einträge erweitern: 
	> -Doomph.redirection.palladio_products=index:/redirectable.products.setup->https://updatesite.palladio-simulator.com/palladio-bench-oomph/nightly/plain/setups/redirectable.products.setup  
	-Doomph.redirection.palladio_projects=index:/redirectable.projects.setup->https://updatesite.palladio-simulator.com/palladio-bench-oomph/nightly/plain/setups/redirectable.projects.setup

7. Anschließend kann der Installer gestartet werden.
8. Falls der PalladioSimulator nicht angezeigt wird, rechts oben im Eck den Ordner ausklappen und den Haken bei PalladioSimulator aktivieren
9. Die Palladio Bench unter dem Ordner PalladioSimulator auswählen
10. Mit Next durch die nächsten Schritte springen. Hier kann bei Bedarf der Speicherort geändert werden.
11. Zum Abschluss auf Finish klicken
12. Nach dem Start der Eclipse überprüfen, ob XText installiert ist. Falls dies nicht der Fall ist, kann dies über den Eclipse Marketplace nachinstalliert werden.
13. Danach kann der Quellcode des Praktikums aus dem Repository heruntergeladen werden.

Um den Code auszuführen, muss eine Eclipse Application gestartet werden. Dazu sind folgende Schritte notwendig:
1. Neue Eclipse Application in Run Configurations anlegen
2. Unter Main -> Program to Run -> Run an application -> org.eclipse.ui.ide.workbench auswählen
3. Mit Run kann die Eclipse Application gestartet werden.

In der gestarteten Eclipse kann jetzt der Microprofile Code generiert werden. Folgende Schritte sind dazu notwendig:
1. Ein Palladio Modell Projekt importieren über File -> Open Projects from File System..
2. Das Projekt auswählen und öffnen
3. Run -> Run Configurations öffnen
4. Einen neuen Protocom Generator anlegen
5. Im Reiter Architecture Modell das Allocation File und das Usage File des Palladio Projekts auswählen
6. In der Analysis Configuration einen Speicherort festlegen. Als Transformation Target "Java SE RMI Code Stubs" auswählen. (Eigentlich müsste hier noch eine weitere Auswahlmöglichkeit für Microprofile stehen. Dies wurde im Rahmen des Praktikums nicht umgesetzt.)
7. Anschließend wird mit einem Klick auf Run der Code generiert.

Um den generierten Code auszuführen, muss Maven/Open Liberty mit dem Ziel 
> mvn liberty:dev

oder 
> mvn liberty:run 

ausgeführt werden.

## Erklärung einzelner Pakete/Klassen
In diesem Abschnitt wird der Quellcode des Praktikums beschrieben. Dieser besteht aus dem Generator. Im zweiten Abschnitt wird erklärt, wie der generierte Code aussieht.
### Generator
Der Quellcode, welche die Codegeneratoren bereitstellt, besteht aus drei Teilen:

Im Paket org.palladiosimulator.protocom.lang.java befinden sich die Schablonenvorlagen für eine Microprofile Klasse und ein Microprofile Interface. Alle generierten Java Klassen und Iterfaces nutzen diese als Vorlage. 

Die konkreten Ausführungen für einzelne Bestandteile des generierten Codes befinden sich im Paket org.palladiosimulator.protocom.tech.rest. Hier liegen die speziellen Klassen mit den unterschiedlichen Funktionalitäten. Im aktuellen Quellcode sind das mehr, als tatsächlich benötigt werden, da aufgrund von alten Abhängigkeiten nicht alles gelöscht werden kann.

Die Instanziierung einer konkreten Java Klasse erfolgt im Paket org.palladiosimulator.protocom.traverse.microprofile. Hier sorgt die Klasse MicroprofileConfiguartionModule für eine Kopplung des Palladio Modells an die entsprechenden Klassen in Java. In der Klasse MicroprofileBasicComponent werden die benötigten Java Klassen und Interfaces angelegt. Die Abhängigkeiten und Open Liberty spezifische Dateien werden in der Klasse MicroprofileSystem aufgelöst bzw. angelegt.

### Generiertes Projekt
Das generierte Microprofile Projekt beinhaltet die Plug-in Dependencies aus der Java SE Implementierung. Um Open Liberty verwenden zu können, werden die benötigten Abhängigkeiten per Maven aufgelöst. Dazu wird die benötigte POM.xml generiert. Die weiteren Bestandteile des Open Liberty Servers sind unter src/main/liberty abgelegt. Dazu gehört die server.xml, welche die Portkonfiguration für den Server beinhaltet. Ebenso befindet sich in dem Ordner die jvm.options. Diese beinhaltet die Pfade für CDI.

Die Konfiguration für die Oberfläche des Webservers befindet sich unter src/main/liberty/webapp/WEB-INF.

Die im Palladio Modell angelegten Komponenten und Schnittstellen werden aus dem Assembly Context extrahiert und in Java Klassen bzw. Interfaces umgewandelt. Die Java Klassen bilden die REST Endpoints. Sie werden in den Ordner src/main/java/{Name des Modells}/impl abgelegt. Der Restendpoint wird durch die @Path Annotation eindeutig einer URL zugeordnet.

Die Interfaces werden für CDI genutzt. Sie befinden sich im Paket src/mian/java/interfaces. Die Interfaces beinhalten ebenfalls eine @Path Annotation, die mit den jeweiligen REST Endpoints übereinstimmen. Dadurch ist eine Auflösung der Abhängigkeiten über CDI möglich.
# Fazit / Was noch zu tun ist
Im Rahmen des Praktikums wurde der Code so erweitert, dass das die transformierten Komponenten und Schnittstellen des Palladio Modell den Eclipse Microprofile Standard erfüllen.
Zu einer vollständig lauffähigen Version fehlt noch das Transformieren des Usage Modells aus dem Palladio Modell in Microprofile.

Des Weiteren sind folgende Dinge notwendig:
* Code aufräumen
	- Die Kohärenz zwischen einzelnen Komponenten im Code ist sehr groß. Dies muss gelöst werden, um weitere Erweiterungen zm ermöglichen.
	- Die für das Praktikum verwendeten Java Klassen enthalten viel auskommentierten Code, der entsprechend gelöscht werden muss.
	- Gleiches gilt für die Java Klassen, welche von der Java SE Implementierung übernommen wurden, aber für den Microprofile Standard nicht benötigt werden.
* In der Klasse TransformPCMToCodeXtendJob muss eine entsprechende if Abfrage für das Generieren von Microprofile Code erstellt werden. Da dies gekoppelt mit dem Dropdown Feld in Protocom ist, wird hier bisher die Option der normalen Java SE Implementierung überschrieben.
* Das generierte Projekt wird bisher als OSGI Projekt für Eclipse generiert. Da Open Liberty Maven verwendet, sollte dies umgestellt werden. Problematisch ist hierbei, dass Protocom und die verwendeten Klassen aus dem Simucon Framework bisher nicht in Maven verfügbar sind.
* Die Abhängigkeiten für das generierte Java Projekt müssen bisher von Hand aufgelöst werden. Dies könnte man mit Maven Tycho automatisch generieren.
* Um Context and Dependency Injection nutzen zu können, müssen die entsprechenden Klassen an den Modulen bekannt gemacht werden. Bisher geschieht dies von Hand über die jvm.options Datei.
* Der Open Liberty Server stoppt automatisch nach ein paar Sekunden die REST Endpoints. Dieses Problem könnten verschwinden, wenn die Abhängigkeiten entsprechend aufgelöst wurden.