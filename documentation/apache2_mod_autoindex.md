# apache2_mod_autoindex

[Back to resource list](../README.md#resources)

Manages the Apache `mod_autoindex` configuration file.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name                 | Type   | Default                                                                  | Description                                                                                                              |
|----------------------|--------|--------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| index_options        | Array  | `['FancyIndexing', 'VersionSort', 'HTMLTable', ...]`                     | Array of directory indexing options. See <https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#indexoptions>         |
| readme_name          | String | `'README.html'`                                                          | File inserted at the end of the index listing. See <https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#readmename> |
| header_name          | String | `'HEADER.html'`                                                          | File inserted at the top of the index listing. See <https://httpd.apache.org/docs/2.4/mod/mod_autoindex.html#headername> |
| index_ignore         | Array  | `['.??*', '*~', '*#', 'HEADER*', 'README*', 'RCS', 'CVS', '*,v', '*,t']` | Files to exclude from directory listings.                                                                                |
| add_icon_by_type     | Array  | platform-specific                                                        | List of icon directives by type.                                                                                         |
| add_icon_by_encoding | Array  | `['(CMP,/icons/compressed.gif) x-compress x-gzip x-bzip2']`              | Icon directives by encoding.                                                                                             |
| add_icon             | Array  | platform-specific                                                        | Icon directives by file name or extension.                                                                               |
| default_icon         | String | `'/icons/unknown.gif'`                                                   | Default icon for unrecognised file types.                                                                                |
| add_description      | Array  | platform-specific                                                        | Description strings for file types.                                                                                      |

## Examples

```ruby
apache2_mod_autoindex ''
```

## Removal

`:delete`: Removes the generated module configuration file and its enabled configuration link. The module binary and load configuration are retained.

```ruby
apache2_mod_autoindex 'default' do
  action :delete
end
```
