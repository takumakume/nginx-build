# nginx-build

build RPMs of multiple types of nginx.

## usage

### Build a role with updates REVISION or NGINX_VERSION

  ```
  rake build
  ```

### Show hanged role with updates REVISION or NGINX_VERSION

  ```
  rake changed_roles
  ```

### Build a specific role

  ```
  rake build_{role_name}
  ```

### Output destination of the build RPMs

  ```
  rpms/{role_name}/*.rpm
  ```

## Add roles

### `docker-compose.yml`

  ```yaml
  role_name:
    <<: *base
    dockerfile: roles/role_name/Dockerfile
    environment:
      ROLE_NAME: role_name
      NGINX_VERSION: 1.13.8-1
      NGINX_SRPM_URL: http://nginx.org/packages/mainline/centos/7/SRPMS/nginx-1.13.8-1.el7_4.ngx.src.rpm
      REVISION: 1
      OPENSSL_VERSION: 1.0.2      # option
      HEADERS_MORE_VERSION: 0.33  # option
  ```

  - Require
    - ROLE_NAME
    - NGINX_VERSION
    - NGINX_SRPM_URL
    - REVISION
  - Add version of the module to be embedded
    - Add module setup to `roles/role_name/build.sh`
      ```sh
      [[ -z "${OPENSSL_VERSION}" ]] || setup_module "openssl" "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}-latest.tar.gz"
      ```
    - Add module test to `roles/role_name/test.sh`

### `roles/role_name/Dockerfile`

  - Describe construction of build environment

### `roles/role_name/nginx.spec.patch` (option)

  -　Create if necessary
