package org.palladiosimulator.protocom.lang.xml.impl

import org.palladiosimulator.protocom.lang.GeneratedFile
import org.palladiosimulator.protocom.lang.xml.IMicroprofilePom

class MicroprofilePOM extends GeneratedFile<IMicroprofilePom> implements IMicroprofilePom{
	
	override generate() {
			'''
		«header»
		«body»
		'''
	}
	
	def header() {
		'''<?xml version='1.0' encoding='utf-8'?>'''
	}
	
	def body() {
		'''<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		    <modelVersion>4.0.0</modelVersion>
		
		    <groupId>«groupID»</groupId>
		    <artifactId>«artifactName»</artifactId>
		    <version>1.0-SNAPSHOT</version>
		    <packaging>war</packaging>
		
		    <properties>
		        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
		        <maven.compiler.source>1.8</maven.compiler.source>
		        <maven.compiler.target>1.8</maven.compiler.target>
		        <!-- Liberty configuration -->
		        <liberty.var.default.http.port>9080</liberty.var.default.http.port>
		        <liberty.var.default.https.port>9443</liberty.var.default.https.port>
		    </properties>
		
		    <dependencies>
		         <!-- Provided dependencies -->
		        <dependency>
		            <groupId>jakarta.platform</groupId>
		            <artifactId>jakarta.jakartaee-api</artifactId>
		            <version>8.0.0</version>
		            <scope>provided</scope>
		        </dependency>
		        <dependency>
		            <groupId>org.eclipse.microprofile</groupId>
		            <artifactId>microprofile</artifactId>
		            <version>3.3</version>
		            <type>pom</type>
		            <scope>provided</scope>
		        </dependency>
		        <!-- For tests -->
		        <dependency>
		            <groupId>org.junit.jupiter</groupId>
		            <artifactId>junit-jupiter</artifactId>
		            <version>5.6.2</version>
		            <scope>test</scope>
		        </dependency>
		        <dependency>
		            <groupId>org.apache.cxf</groupId>
		            <artifactId>cxf-rt-rs-client</artifactId>
		            <version>3.3.6</version>
		            <scope>test</scope>
		        </dependency>
		        <dependency>
		            <groupId>org.apache.cxf</groupId>
		            <artifactId>cxf-rt-rs-extension-providers</artifactId>
		            <version>3.3.6</version>
		            <scope>test</scope>
		        </dependency>
		        <dependency>
		            <groupId>org.glassfish</groupId>
		            <artifactId>javax.json</artifactId>
		            <version>1.1.4</version>
		            <scope>test</scope>
		        </dependency>
		        <!-- Java utility classes -->
		        <dependency>
		            <groupId>org.apache.commons</groupId>
		            <artifactId>commons-lang3</artifactId>
		            <version>3.10</version>
		        </dependency>
		        <!-- Support for JDK 9 and above -->
		        <dependency>
		            <groupId>javax.xml.bind</groupId>
		            <artifactId>jaxb-api</artifactId>
		            <version>2.3.1</version>
		            <scope>provided</scope>
		        </dependency>
		        <dependency>
		            <groupId>javax.servlet</groupId>
		            <artifactId>javax.servlet-api</artifactId>
		            <version>4.0.1</version>
		            <scope>provided</scope>
		        </dependency>
		    </dependencies>
		
		    <build>
		        <finalName>${project.artifactId}</finalName>
		        <plugins>
		            <plugin>
		                <groupId>org.apache.maven.plugins</groupId>
		                <artifactId>maven-war-plugin</artifactId>
		                <version>3.2.3</version>
		            </plugin>
		            <!-- Plugin to run unit tests -->
		            <plugin>
		                <groupId>org.apache.maven.plugins</groupId>
		                <artifactId>maven-surefire-plugin</artifactId>
		                <version>2.22.2</version>
		            </plugin>
		            <plugin>
		                <groupId>io.openliberty.tools</groupId>
		                <artifactId>liberty-maven-plugin</artifactId>
		                <version>3.2</version>
		            </plugin>
		            <!-- Plugin to run functional tests -->
		            <plugin>
		                <groupId>org.apache.maven.plugins</groupId>
		                <artifactId>maven-failsafe-plugin</artifactId>
		                <version>2.22.2</version>
		                <configuration>
		                    <systemPropertyVariables>
		                        <http.port>${liberty.var.default.http.port}</http.port>
		                    </systemPropertyVariables>
		                </configuration>
		            </plugin>
		        </plugins>
		    </build>
		</project>'''
	}
	
	override artifactName() {
		provider.artifactName;
	}
	
	override groupID() {
		provider.groupID;
	}
	
}