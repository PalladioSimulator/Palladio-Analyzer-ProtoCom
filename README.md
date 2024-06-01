# Palladio-Analyzer-ProtoCom
ProtoCom is a model-driven approach to generate performance prototypes and code stubs from PCM instances. Such performance prototypes mimic demands to different types of hardware resources to evaluate their performance in a realistic environment.

ProtoCom comes with a framework (e.g., for load generation and calibration) as well as extensible model-to-text transformations. Currently, only Java SE is fully supported. For Java EE (EJBs and Servlets), reference implementations and initial concepts exist. 
## Documentation
ProtoCom is a model-driven approach to generate performance prototypes and code stubs from PCM instances. Such performance prototypes mimic demands to different types of hardware resources to evaluate their performance in a realistic environment.

ProtoCom comes with a framework (e.g., for load generation and calibration) as well as extensible model-to-text transformations. Currently, only Java SE is fully supported. For Java EE (EJBs and Servlets), reference implementations and initial concepts exist.

## History and References
In 2008, Becker described ProtoCom's main concepts [[Becker2008c](http://dx.doi.org/10.1007/978-3-540-69814-2_7)]. In 2011, Lehrig and Zolynski provide a ProtoCom ("ProtoCom 2") that fully supports Java SE and additional usability features [[LZ11](http://www.cs.uni-paderborn.de/fachgebiete/fachgebiet-softwaretechnik/veroeffentlichungen/gesamt.html?tx_sibibtex_pi1%5BshowUid%5D=4241&cHash=82fd4881673ae92e8942b5f7fa50a142)] (the paper also describes a case study in a virtualised environment). With Palladio 3.5.0, ProtoCom 2 has been replaced by ProtoCom 3 that is a complete rewrite of ProtoCom 2 on the basis of Xtend2. Besides supporting the full feature set of ProtoCom 2, ProtoCom 3 provides some minor bugfixes, additional sensors for each operation, a faster prototype generation, eases the addition of custom model-to-text transformation, e.g., for supporting new target platforms like cloud computing environments, and provides an extensible interceptor mechanisms at provided and required ports.

## Features
The following list gives an overview about currently supported features of ProtoCom.
* Partial prototype automation: Source code is generated automatically, however, users have to deploy and run it on the respective servers.
* Stub generation: Source code stubs are generated, serving as a starting point
* Java SE support: for Java SE, the prototype can run on different servers and communicate with its other instances via RMI. This enables the realistic simulation of distributed allocations.
* HDD/CPU Calibration: The prototype calibrates itself with respect to HDD and CPU on every system it is executed. This ensures the correct simulation of HDD/CPU processing rates specified within the model.
* Sensor support: ProtoCom supports the sensors for the Usage Scenario as well as all operations within a system.
* Modeling support: ProtoCom supports most of the features used within modeling. Among these are the support for open- and closed-workloads, simulation of both active and passive resources like HDD, CPU, Network, and Delay resources, and the support for composite components.
* Fast and extensible Xtend 2 transformation: ProtoCom uses Xtend 2 for its model-to-text transformation and provides extension points for custom transformations that can refine, reuse, and replace existing transformations, e.g., an interceptor mechanisms at provided and required ports

## Installation
The ProtoCom feature is selectable from the normal Palladio update site. Internally, the Palladio nightly update sites gets a recent ProtoCom version from https://sdqweb.ipd.kit.edu/eclipse/palladio/analyzer/protocom/nightly/.

## Execution
The following describes the creation, deployment, and measurement of a prototype on a single server.

### Creation
You need to have the "ProtoCom CBSE Prototype" feature installed to use ProtoCom. A default PCM installation should have this feature activated. Then, the prototype can be created via an M2T transformation as follows.

1. Open the run configurations dialog. Eclipse with the above feature installed provides a launch configuration entry called Protocom Generator.
1. Create a new Protocom Generator launch configuration.
1. In the Architecture Model(s) tab, choose the Allocation File and Usage File depending on your model.
1. Run the launch configuration.

## Deployment
To use the generated prototype, it is recommended to export it as jar. Right-click on the project and choose *Export -> Java -> Runnable Jar File*. Use *Extract required libraries into generated JAR* to include all dependencies. Finally, store the jar file on each test server

### Calibration
Protocom needs to measure your system in order to adjust the resource demands to the CPU and HDD speed. Calibration is automatically done during the first test run. Calibration measurements are stored at the calibration path (see Command Line Parameters). Thus, it can be reused for later runs. If you want to change the resources, you have to delete the measurements to enforce recalibration.

### Measurement
We recommend to create a file run.properties which specifies the set of Command Line Parameters of your choice. Start measurements using *java -jar <file.jar> -f <run.properties>*. The prototype writes the measured results into the sensorframework, so that you can view the results with the PCM result view. The results are written to a file data source at the data directory specified by the Command Line Parameters.

As an example, the figures on the right show measured results of ProtoCom compared to SimuCom. They were created for the Media Store case study and show values as a histogram and as a cumulative distribution function, respectively.

## Command Line Parameters
| Command | Long | Required | Argument | Description |
|---|---|---|---|---|
| -h | -help | No | | Shows this help. |
| -f| -propFile| No| Path to property file| Property file used to set default commandline parameters. Defaults can be overwritten by additional parameters. |
| -d | -dataDir | Yes | Path to data directory | Data directory used by the FileStorage Sensor DAO to store the measured times. |
| -n | -name | Yes | Name | Name of the experiment for use in the stored data. |
| -c | -threadcount | No | Number of use | Override usage scenario population (only for closed workloads). |
| -m | -maxmeasurements | Yes | Number of measurements | Maximum measurements to take. |
| -u | -warmup | No | Number of warmup cycles | Warmup runs before measuring (default: 1000). |
| -s | -storeCalPath | No | Path to directory | Path to the directory where the calibration is stored (default: ../ProtoComCalibration/). |
| -R | -remoteAddr | No | Network address | Remote address of the RMI registry (default: localhost). |
| -O | -remotePort | No | Registry Port | IP port of the RMI registry (default: 1099). |
| -E | -randomGenerator | No | Seed | Seed for the StoEx random generator. |
| -D | -debug | No |  | Print debug information. Turn off for real experiments! |
| -P | -passive | No |  | Make server passive, no load drivers are started. No warmup runs are executed, either. |
| -W | | No |  | Execute a number of runs equal to the warmup runs configuration. Depending on configuration, the inner times might be measured. |
| -p | -cpuStrategy | No | Name of strategy | CPU calibration strategy: primes, count_numbers, fft, fibonacci, mandelbrot, sortarray, void, wait (default: Fibonacci). |
| -H | -hddStrategy | No | Name of strategy | HDD calibration strategy: largeChunks (default: LargeChunks). |
| -a | -accuracy | No | Accuracy of calibration | Accuracy of CPU and HDD calibration as determined by the number of iterations a calibration strategy executes to determine the "n" for a given resource demand: LOW, MEDIUM, or HIGH (default: MEDIUM). For example, to determine a 1-second CPU resource demand using the fibonacci strategy, a calibration would systematically try to determine the "n" parameter of the fibonacci algorithm that takes the algorithm 1 second. A high accuracy would use a high number of repetitions of this determination and use the average of the results for the final "averaged n". |

All command line parameters can be stored in a config file and provided using the `-f` parameter.

Example config file (e.g. run.properties):

```
name=MediaStoreProtoComBlade
dataDir=Data
storeCalPath=../Calibration
remoteAddr=192.168.0.1
warmup=100
maxmeasurement=1000
accuracy=MEDIUM
```

## Support
For support
* visit our [issue tracking system](https://palladio-simulator.com/jira)
* contact us via our [mailing list](https://lists.ira.uni-karlsruhe.de/mailman/listinfo/palladio-dev)

For professional support, please fill in our [contact form](http://www.palladio-simulator.com/about_palladio/support/).
