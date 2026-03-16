# apache2_mod_actions

[Back to resource list](../README.md#resources)

Manages the Apache `mod_actions` configuration file.

## Actions

| Action  | Description               |
|---------|---------------------------|
| :create | Create the configuration. |

## Properties

| Name    | Type | Default | Description                                                                                                                        |
|---------|------|---------|------------------------------------------------------------------------------------------------------------------------------------|
| actions | Hash | `{}`    | A hash of actions where key is the action-type and value is the cgi-script, e.g. `{ news-handler: '"/cgi-bin/news.cgi" virtual' }` |

## Examples

```ruby
apache2_mod_actions '' do
  actions({ 'image/gif' => '/cgi-bin/image.cgi' })
end
```
