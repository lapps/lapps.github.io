# Maven

A Nexus Maven repository has been setup at http://149.165.157.51:8100 that is used to deploy artifacts in anticipation of a CI/CD server. Configuring a Nexus server is straight-forward and involves the following steps:

1. Run the Nexus Docker container.
1. Login to Nexus and change the *admin* password.
1. Set up snapshot and release repositories.
1. Configure your projects to use the Nexus server.

Each step is discussed in more detail below.

## Nexus Setup

We create a [Docker Volume](https://docs.docker.com/storage/volumes/) for storing persistent data.  The volume will be mounted in the Nexus container and used by Nexus for local storage.

```
$> docker volume create --name nexus-data [1]
$> docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3 [2]
```

1. The first command creates a Docker Volume named *nexus-data*.
1. The second command starts the Nexus container and mounts the volume (-v) *nexus-data* as the directory */nexus-data* inside the container.

Then follow the instructions at [https://hub.docker.com/r/sonatype/nexus3/](https://hub.docker.com/r/sonatype/nexus3/) to login as the *admin* user and set up a *snapshot* repository and a *release* repository. 

**WARNING** Change the *admin* user's password!

To make use of the repositories you will need to add the following to one of:

1. The project's pom.xml file.
1. The project's parent pom.xml file, if it has one, or,
1. Your ~/.m2/settings.xml file

```xml
<repositoryies>
    <repository>
        <id>cdc-releases</id>
        <url>http://149.165.157.51:8100/repository/cdc-releases/</url>
        <releases><enabled>true</enabled></releases>
        <snapshots><enabled>false</enabled></snapshots>
    </repository>
    <repository>
        <id>cdc-snapshots</id>
        <url>http://149.165.157.51:8100/repository/cdc-snapshots/</url>
        <releases><enabled>false</enabled></releases>
        <snapshots><enabled>true</enabled></snapshots>
    </repository>
</repositoryies>
```

To deploy artifacts to the Nexus repository you will need to add the following to your ~/.m2/settings.xml file:

```xml
<servers>
    <server>
    	<id>cdc-releases</id>
    	<username>username</username>
    	<password>password</password>
    </server>
    <server>
    	<id>cdc-snapshots</id>
    	<username>username</username>
    	<password>password</password>
    </server>
</servers>
```
Use the repository names and username/password you configured on the Nexus server.

The project's *pom.xml* or the parent's *pom.xml* must also define the Nexus server in the `</distributionManagement/>` section.

```xml
<distributionManagement>
    <repository>
        <id>cdc-releases</id>
        <url>http://149.165.157.51:8100/repository/cdc-releases/</url>
    </repository>
    <snapshotRepository>
        <id>cdc-snapshots</id>
        <url>http://149.165.157.51:8100/repository/cdc-snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```