# default_site

Controls the default site.

```ruby
apache2_default_site '' do
  default_site_name String
  site_action       [String, Symbol]
  port              String
  cookbook          String
  server_admin      String
  log_level         String
end
```

## Actions

`:enable`
`:disable`


## Properties

### `default_site_name`

| --              | --                    |
| --------------- | --------------------- |
| **Ruby type**   | `String`              |
| **default**     | `default_site`        |
| **description** | The default site name |

### `site_action`

| --                 | --                                                                         |
| ------------------ | -------------------------------------------------------------------------- |
| **Ruby type**      | [String, Symbol]                                                           |
| **default**        | `:enable`                                                                  |
| **description**    | Allows you to place all the configuration on disk but not enable the site. |
| **allowed vaules** | :enable, :disable                                                          |

### `port`

| --              | --                |
| --------------- | ----------------- |
| **Ruby type**   | `String`          |
| **default**     | `80`              |
| **description** | Port to listen on |

### `cookbook`

| --              | --                                   |
| --------------- | ------------------------------------ |
| **Ruby type**   | `String`                             |
| **default**     | `apache2`                            |
| **description** | Cookbook to source the template from |

### `server_admin`

| --              | --                        |
| --------------- | ------------------------- |
| **Ruby type**   | `String`                  |
| **default**     | `admin@server`            |
| **description** | Default site contact name |

### `log_level`

| --              | --                    |
| --------------- | --------------------- |
| **Ruby type**   | `String`              |
| **default**     | `warn`                |
| **description** | log level for apache2 |
