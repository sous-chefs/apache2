# apache2_mod_actions

[Back to resource list](../README.md#resources)

Manages the Apache `mod_actions` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

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

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_actions 'default' do
  action :delete
end
```
