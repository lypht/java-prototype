# java-prototype

Owner: Kris Nova

Author: Kris Nova [Github][6]


# Overview

`java-prototype` simulates a troublesome monolithic Java application that is designed to be hard to orchestrate in containers.

# Install

Installing with [maven][5]

```bash
mvn clean package
```

Also for a quick development run the following command to build and run the application.

```bash
make dev
```

# Configuring

### MySQL

There are three environmental variables that need to be defined in order to authenticate with a MySQL server.

```bash
export JAVAPROTOTYPE_MYSQL_CONNECTION_STRING="jdbc:mysql://my.server.url/database"
export JAVAPROTOTYPE_MYSQL_CONNECTION_USER="user"
export JAVAPROTOTYPE_MYSQL_CONNECTION_PASS="password"
```

# Cloud Deployment
1. GCP: Create a build trigger using `cloudbuild.yaml` linking your clone or fork of this repo.
1. AWS: Include `buildspec.yaml` in a CodeBuild object linking your clone or fork of this repo. 
    1. _NOTE_ The remaining instructions are GCP-centric.  Modify accordingly if not using GCP.

There are two containers to build, a frontend (the java app) and a backend (the mysql database). _NOTE_ This is not a secure database image, and therefore should not be used in production.

This deployment strategy requires [helm](https://helm.sh/), with a tiller installation that has appropriate RBAC roles and rolebindings.  
Optionally, it is recommended to install `ahmetb`'s [kubectx and kubens](https://github.com/ahmetb/kubectx) and the `Farmotive` cloud-native dev tools:[kex](https://github.com/farmotive/kex), [kpoof](https://github.com/farmotive/kpoof), [klog](https://github.com/farmotive/klog), and [kud](https://github.com/farmotive/kud).  
If on a Mac, install these with Homebrew:
```bash
brew tap farmotive/k8s
brew install kpoof klog kex kud
```

### Deployment One: the mysql database container
Set environment variables in order to install the mysql chart using helm:
```bash
export NAMESPACE=java-prototype
export DEPLOY_NAME=java-prototype-mysql
export JAVAPROTOTYPE_MYSQL_CONNECTION_PASS="password" #alter this if exposing this deployment externally
export JAVAPROTOTYPE_MYSQL_CONNECTION_USER="java-prototype"
export SIZE=1Gi #If cost is not a concern, increase this to a desired capacity, or omit ",persistence.size=$SIZE" below to use the default 10Gi allocation.
```

Install the backend deployment:

```bash
kubectl create namespace java-prototype
kubens java-prototype
helm install --namespace $NAMESPACE \
--name=$DEPLOY_NAME \
--set mysqlUser=$JAVAPROTOTYPE_MYSQL_CONNECTION_USER,mysqlPassword=$JAVAPROTOTYPE_MYSQL_CONNECTION_PASS,mysqlDatabase=java-prototype,persistence.size=$SIZE \
stable/mysql
```

Once the deployment is successful, obtain the randomly generated root password from the secret for MYSQL_ROOT_PASSWORD: 
```bash
kubectl get secret --namespace $NAMESPACE java-prototype-mysql-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo
```

Then connect to the mysql instance ([kpoof](https://github.com/farmotive/kpoof), [Sequel Pro](www.sequelpro.com), `mysql client`, etc) and import `java-prototype.sql`

```bash
mysql -u root -p java-prototype < java-prototype.sql
```
When prompted, use the password echoed above.

### Deployment Two: the java application

Modify the image name in `java-prototype/values.yaml image.name` to match the image generated by `cloudbuild.yaml`.  It will resemble `gcr.io/$PROJECT_ID/java-prototype`.
Modify the password in `java-prototype/values.yaml env.pass` to match the `JAVAPROTOTYPE_MYSQL_CONNECTION_PASS` export (if `JAVAPROTOTYPE_MYSQL_CONNECTION_PASS` was altered).

```bash
helm install java-prototype/ --namespace java-prototype --name java
```

Once the output of the `NOTES.txt` displays, run `kubectl get pods -w` to see the java deployment succeed.  Use `ctrl-C` to regain a prompt.

### Manipulating the application
_NOTE_ The following activities require multiple terminal sessions.

1. Create a local connection for the database 
```bash
kpoof
```
Select the mysql pod.  Port 3306 will be forwarded.  Connect using the database manager of your choosing with `127.0.0.1` as the host, `java-prototype` as the user, and the value for `$JAVAPROTOTYPE_MYSQL_CONNECTION_PASS` as the password.  Choose `java-prototype` as the schema and `getrequests` as the table.  You should see column headers of `id`, `timestamp`, and `hash` with an empty row set.

1. In a new terminal session, create a local connection for the application
```bash
kpoof
```
Select the java app pod.  Port 8080 will be forwarded.  Connect using the browser of your choosing to `localhost:8080`.  Once resolved, `Success!` will appear.

1. In a new terminal session run the following infinite loop to create entries in the database:
```bash
while true; do curl localhost:8080; done
```

1.  Optional:

In a new terminal session:
```bash
klog -f
```
Select the java pod.  It is likely that the application will log `outOfMemory` errors.  Additionally, logs will contain the writes to the database as well as free memory (if any).
1. Review each terminal window.  The terminal for logs will update with a crash or a new write statement with a random hash.  For each successful `curl`, the terminal for port-forwarding the app will show a valid connection to 8080.  The database manager, when refreshed, will show database rows for each successful connection.

### Challenge Round
Uncomment the liveness and readiness probes in `java-prototype/templates/deployment.yaml` and modify the values, iterating through upgrades of the java app deployment until the pod shows `ready`.

### Cleanup
```bash
helm delete --purge java java-prototype-mysql
kubectl delete namespace java-prototype
```



# Troubleshooting

If you encounter any problems that the documentation does not address, [file an issue][3] or talk to us on the [Kubernetes Slack team][4] channel `#monolith`.

# Contributing

Thanks for taking the time to join our community and start contributing!

Feedback and discussion is available on [the mailing list][2].

* Please familiarize yourself with the [Code of Conduct][0] before contributing.
* See [CONTRIBUTING.md][1] for instructions on the developer certificate of origin that we require.


# Changelog

[0]: https://github.com/heptio/java-prototype/CODE-OF-CONDUCT.md
[1]: https://github.com/heptio/java-prototype/CONTRIBUTING.md
[2]: https://groups.google.com/forum/#!forum/monolithic-apps-to-k8s
[3]: https://github.com/heptio/java-prototype/issues
[4]: http://slack.kubernetes.io/
[5]: https://maven.apache.org/install.html
[6]: https://github.com/kris-nova/
