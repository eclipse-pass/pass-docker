The "demo" compose file describes an early system meant to demonstrate some new technologies and services in PASS. 

## Running:

Docker compose works as normal, but for the demo you need to specify both correct `yml` file and env file. 

### Run With No Deposit Services
In order to run a local instance **_without_** deposit-service, ftp, and dspace, you can run:
```
docker compose -f docker-compose.yml -f eclipse-pass.local.yml up -d --no-build --quiet-pull --pull always
```

In order to stop a local instance, you can run:
```
docker compose -p pass-docker down -v
```
Note the `-v` to remove the volumes, **this is critical** so on subsequent starts, user data is not duplicated.

### Run With Deposit Services and DSpace
In order to run a local instance **_with_** deposit-service, ftp, dspace, you can run:
```
docker compose -p pass-docker -f docker-compose.yml -f eclipse-pass.local.yml -f docker-compose-deposit.yml -f docker-compose-dspace.yml up -d --no-build --quiet-pull --pull always
```

Run the following to create a test admin user in dspace:
```
docker compose -p pass-docker -f dspace-cli.yml run --rm dspace-cli create-administrator -e test@test.edu -f admin -l user -p admin -c en
```

Run the following to load sample data into dspace:
```
docker compose -p pass-docker -f dspace-cli.yml -f dspace-cli.ingest.yml run --rm dspace-cli
```

### Run With Deposit Services and InvenioRDM
In order to run a local instance **_with_** deposit-service, ftp, InvenioRDM, you can run:

Refer to [invenio-rdm/README](./invenio-rdm/README.md) to ensure the prerequisites are met before running the commands below.

First, start the local test InvenioRDM by running the following command in the `invenio-rdm` directory:

```console
./build.sh
./start.sh
```

After the InvenioRDM service is up and running, run the following commands in the `pass-docker` directory:

```console
docker compose -p pass-docker -f docker-compose.yml -f eclipse-pass.local.yml -f docker-compose-deposit.yml -f docker-compose-deposit-invenio-rdm.yml up -d --no-build --quiet-pull --pull always
```

## Services:

### [`idp`](https://github.com/eclipse-pass/pass-docker/idp)

Repository: https://github.com/eclipse-pass/pass-docker
Package: https://github.com/orgs/eclipse-pass/packages/container/package/idp

Environment variables:
* `IDP_HOST=http://localhost:9080`
* `SP_LOGIN=http://localhost:8080/login/saml2/sso/pass`

Separately there is a non-container environment variable `IDP_INTERNAL_PORT` which is used to set the internal port on the IDP container which 9080 maps to.
The default is 8080. This can be used to make 9080 support https by setting it to 4443 in the docker compose environment. One way to do this is by adding
`IDP_INTERNAL_PORT=4443` to the docker compose command. Note that `-e` should not be used because it is for container environment variables.

### [`pass-core`](https://github.com/eclipse-pass/pass-core)

Repository: https://github.com/eclipse-pass/pass-core
Package: https://github.com/orgs/eclipse-pass/packages/container/package/pass-core-main

Presents a JSON:API window to the backend from behind the authentication layer. Swagger is not yet hooked up so is unreachable. Provides data and web APIs to the application.

Support SAML and HTTP basic authentication.

Environment variables:

* `PASS_CORE_BASE_URL=http://localhost:8080` : Used when generating JSON API relationship links. Needs to be absolute and must change to match deployment environment
* `PASS_CORE_POSTGRES_PORT=5432`
* `PASS_CORE_BACKEND_USER=backend`
* `PASS_CORE_BACKEND_PASSWORD=backend`
* `PASS_CORE_APP_LOCATION=http://pass-ui:81/app/` : Resource location of pass ui resources
* `PASS_CORE_APP_CSP=default-src 'self';` : Content Security Policy header value
* `PASS_CORE_IDP_METADATA=http://idp:8080/idp/shibboleth` : Resource location of IDP metadata
* `PASS_CORE_SP_ID=https://sp.pass/shibboleth` : Identifier of pass-core as an SP
* `PASS_CORE_SP_KEY=file:///path/key`          : Resource location of SP key
* `PASS_CORE_SP_CERT=file:///path/cert`        : Resource location of SP certificate
* `PASS_CORE_LOGOUT_SUCCESS=/app/`             : Location user is redirected after logout
* `PASS_CORE_LOGOUT_DELETE_COOKIES="JSESSIONID /,shib_idp_session /idp"` : Cookies to delete on logout, "name path" separated by commas.
* `POSTGRES_USER=postgres`
* `POSTGRES_PASSWORD=postgres`
* `JDBC_DATABASE_URL=jdbc:postgresql://postgres:5432/pass`
* `JDBC_DATABASE_USERNAME=pass`
* `JDBC_DATABASE_PASSWORD=moo`

### `postgres`

Pretty much an out-of-the-box PostgreSQL server. Only interacts with the [`pass-core`](https://github.com/eclipse-pass/pass-core) service.

### [`pass-ui`](https://github.com/eclipse-pass/pass-ui)

Repository: https://github.com/eclipse-pass/pass-ui
Package: https://github.com/orgs/eclipse-pass/packages/container/package/pass-ui

User interface for the PASS application. Currently does not handle environment variables nicely - they are baked into images at build time due. The environment variables in the demo environment should not need to be adjusted between different deployment environments.

Environment variables:

* `PASS_UI_PORT=81`
* `PASS_API_NAMESPACE=data`
* `PASS_UI_ROOT_URL=/app`
* `STATIC_CONFIG_URL=/app/config.json`
* `DOI_SERVICE_URL=/doiservice/journal`
* `MANUSCRIPT_SERVICE_LOOKUP_URL=/downloadservice/lookup`
* `MANUSCRIPT_SERVICE_DOWNLOAD_URL=/downloadservice/download`
* `POLICY_SERVICE_POLICY_ENDPOINT=/policyservice/policies`
* `POLICY_SERVICE_REPOSITORY_ENDPOINT=/policyservice/repositories`
* `SCHEMA_SERVICE_URL=/schemaservice`
* `USER_SERVICE_URL=/pass-user-service/whoami`


### `loader`

A basic Docker image where we can run a `curl` command to bootstrap the environment with data from `demo_data.json`

### `idp`, `ldap`

Other related images that work together with `pass-auth` to handle authentication. Based on services of the same name in the older `docker-compose` environment.

Environment variables:

* `MAIL_SMTP=11025`
* `MAIL_IMAPS=11993`
* `MAIL_MSP=11587`
* `OVERRIDE_HOSTNAME=mail.jhu.edu`
* `ENABLE_SPAMASSASSIN=0`
* `ENABLE_CLAMAV=0`
* `ENABLE_FAIL2BAN=0`
* `ENABLE_POSTGREY=0`
* `SMTP_ONLY=0`
* `ONE_DIR=1`
* `DMS_DEBUG=0`
* `ENABLE_LDAP=1`
* `TLS_LEVEL=intermediate`
* `LDAP_SERVER_HOST=ldap`
* `LDAP_SEARCH_BASE=ou=People,dc=pass`
* `LDAP_BIND_DN=cn=admin,dc=pass`
* `LDAP_BIND_PW=password`
* `LDAP_QUERY_FILTER_USER=(&(objectClass=posixAccount)(mail=%s))`
* `LDAP_QUERY_FILTER_GROUP=(&(objectClass=posixAccount)(mailGroupMember=%s))`
* `LDAP_QUERY_FILTER_ALIAS=(&(objectClass=posixAccount)(mailAlias=%s))`
* `LDAP_QUERY_FILTER_DOMAIN=(|(mail=*@%s)(mailalias=*@%s)(mailGroupMember=*@%s))`
* `ENABLE_SASLAUTHD=0`
* `POSTMASTER_ADDRESS=root`
* `SSL_TYPE=manual`
* `SSL_CERT_PATH=/tmp/docker-mailserver/cert.pem`
* `SSL_KEY_PATH=/tmp/docker-mailserver/key.rsa`

## Running Acceptance Tests

Repository: https://github.com/eclipse-pass/pass-acceptance-testing

There is a small set of end-to-end smoke tests that we can run against this environment for some validation of changes. These tests run automatically for new PRs that are opened against `main`, but can also be run locally. In order to do this, you'll first need to clone the repository with the tests.

Once you have the repository, wait for the Docker Compose environment to start up and initialize then run the tests directly. From the `pass-acceptance-testing` local repo, run:

``` sh
yarn            # Installs project dependencies
yarn run test   # Runs tests
```

