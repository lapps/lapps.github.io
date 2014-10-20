---
layout: slate_numbered
title: Securing Tomcat
---

# {{ page.title }}

Before we can claim to run a secure grid all services **must** use https rather than 
http.  Moving the services to https (SSL/TLS) is easy, updating existing clients to use 
the new URLs is also easy, but will take more time.

<div class="note">
<p>
<span class="red">NOTE</span> the web services themselves do not need to be updated; only 
clients that call the services need to be updated to use the new URLs.
</p>
<p>
<strong>Work Item</strong> Investigate redirects so access to the unsecured service port is 
automatically redirected to the secure service port.
</p>
</div>

<div class="note">
<span class="red">NOTE:</span> If you already have a security certificate for your server 
you can use that instead of generating a new one. In that case, create the Java keystore, skip
the section on creating a CSR (Certificate Signing Request) and jump to the section on
installing your certificate.  You will only have to install your existing certificate rather 
than the three listed below.
</div>

## Tomcat

To serve requests over https Tomcat needs a private key and public key (certificate) that 
it can use to sign and encode/decode messages.  These keys are stored in a *"keystore"* 
which is created with the Java <tt>keytool</tt> program.

### Create a keystore.  

The following instructions assume the <tt>keytool</tt> program is on your $PATH, 
otherwise the full path is <tt>$JAVA_HOME/bin/keytool</tt>. 

```bash
keytool -genkey -keysize 2048 -alias tomcat -keyalg RSA -keystore /path/to/keystore
```

The <tt>/path/to/keystore</tt> is the keystore file that will be generated.

<div class="note">
<span class="red">NOTE:</span> as a matter of policy, always select a 2048 bit key size
any time you are given the option.
</div>

The <tt>keytool</tt> program will ask for the following information:

1. **What is your first and last name?** Enter the domain name that will be secured with
this keystore.  You can protect multiple subdomains by using a wildcard domain, e.g. <tt>*.anc.org</tt>.
1. **What is the name of your organizational unit?** (Optional) Put the name of your
institution here.
1. **What is the name of your organization?** This **must** be *Language Application Grid*
or I will not be able to sign your certificate.
1. Fill in appropriate values for the remaining questions (City, State, Country).

You will also be asked to generate two passwords;
these passwords **must** be the same or Tomcat will have problems.

#### Generate a Certificate Signing Request (CSR)

This step is optional if you already have a security certificate for you server (and if 
you serve anything over https you do).

This step is only needed if your server does not already have a security certificate, or if
you want your Tomcat instance to use a separate certificate.  If you already have a security
certificate skip this step and move directly to the *Installing the Certificate* step.

```bash
keytool -certreq -keyalg RSA -alias tomcat -file server-name.csr -keystore /path/to/keystore
```

Replace <tt>server-name.csr</tt> with your appropriate server name; e.g. *grid.anc.org.csr*.

Email the CSR to me and I will send you three certificates in return:

1. Your signed security certificate for your server. This will be server-name.crt where
<tt>server-name</tt> is the server name used by the CSR.
1. The security certificate for the Signing Authority: lapps-sa.crt
1. The security certificate for the Certificate Authority: lapps-ca.crt

All three certificates need to be installed into the Java keystore we created above.

#### Installing the Certificate

If you are using your existing security certificate you only need to perform the last command,
substituting the filename of you existing certificate for <tt>server-name.crt</tt>.

```bash
keytool -import -alias root -keystore /path/to/keystore -trustcacerts -file lapps-ca.crt
keytool -import -alias signer -keystore /path/to/keystore -trustcacerts -file lapps-sa.crt
bin/keytool -import -alias tomcat -keystore /path/to/keystore -trustcacerts -file server-name.crt
```

### Configure Tomcat. 

Edit <tt>$CATALINE_HOME/conf/server.xml</tt> and uncomment the Connector for port 8443. 

```xml
<Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
		   maxThreads="150" scheme="https" secure="true"
		   clientAuth="false" sslProtocol="TLS" />
```

Add two attributes to the Connector:

```
keystoreFile="/path/to/keystore"
keystorePass="password"/>
```

The final XML should look like:

```xml
<Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
		   maxThreads="150" scheme="https" secure="true"
		   clientAuth="false" sslProtocol="TLS" 
		   keystoreFile="/path/to/keystore"
		   keystorePass="password"/>
```

You can change the port number to any port not already in use on your system.  For example grid.anc.org runs
two Tomcat instances; one on port 8443 that hosts the service manager and another on port
9443 that hosts the services. Both Tomcat instances are configured to use the same keystore.

<div class="note">
<p><span class="red">NOTE:</span> Make sure that the <tt>redirectPort</tt> for the other
Connectors uses the same port number used for the HTTPS Conntector. For example, if you decide
to have Tomcat listen for HTTPS connections on port 1234 then the other Connectors (if any)
should use 1234 as their <tt>redirectPort</tt>.</p>

<p>
<span class="red">NOTE:</span> All Tomcat instances involved in running LAPPS services <strong>must</strong> be
configured to use HTTPS.  That is, you can not configure the services to use HTTPS but continue
to run the Service Manager over HTTP.  Similarly, you can not just configure the Service
Manager to use HTTPS and continue to use HTTP for the services.  It has to be HTTPS from end 
to end.
</p>
</div>

Restart you Tomcat instance(s) and try to connect via https: e.g.
* https://grid.anc.org:8443/service_manager

### Secure Access Only

After a month or so the Connector for port 8080 should be commented out of the `server.xml`
file.  This will restrict access to the secure port only.
