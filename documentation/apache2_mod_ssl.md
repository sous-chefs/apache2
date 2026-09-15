# apache2_mod_ssl

[Back to resource list](../README.md#resources)

Manages the Apache `mod_ssl` configuration file and package.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Creates or updates the managed configuration. Default action. |
| `:delete` | Removes owned artifacts; see Removal below. |

## Properties

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| mod_ssl_pkg | String | `'mod_ssl'` | Package name for mod_ssl (used on RHEL-family platforms). |
| pass_phrase_dialog | String | platform-specific | PassPhraseDialog directive. |
| session_cache | String | `'shmcb:/var/cache/mod_ssl/scache(512000)'` | SSLSessionCache directive. |
| session_cache_timeout | Integer | `300` | SSLSessionCacheTimeout in seconds. |
| mutex | String | `'default'` | SSLMutex directive. |
| random_seed_startup | String | `'file:/dev/urandom 256'` | SSLRandomSeed for startup. |
| random_seed_connect | String | `'builtin'` | SSLRandomSeed for connect. |
| cipher_suite | String | platform-specific | SSLCipherSuite directive. |
| protocol | Array | `['-ALL', '+TLSv1.2']` | Enabled SSL/TLS protocols. |
| honor_cipher_order | String | `'on'` | SSLHonorCipherOrder directive. |
| compression | String | `'off'` | SSLCompression directive. |
| insecure_renegotiation | String | `'off'` | SSLInsecureRenegotiation directive. |
| strict_sni_vhost_check | String | `'on'` | SSLStrictSNIVHostCheck directive. |

## Examples

```ruby
apache2_mod_ssl 'default' do
  protocol ['-ALL', '+TLSv1.2', '+TLSv1.3']
end
```

## Removal

`:delete`: Removes SSL configuration, the socache_shmcb module configuration and links, and the separately installed SSL package on RHEL-family, Fedora and Amazon platforms.

```ruby
apache2_mod_ssl 'default' do
  action :delete
end
```

## Additional properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `use_stapling` | String | `'Off'` | SSLUseStapling. |
| `stapling_responder_timeout` | String | `'5'` | SSLStaplingResponderTimeout in seconds. |
| `stapling_return_responder_errors` | String | `'Off'` | SSLStaplingReturnResponderErrors. |
| `stapling_cache` | String | `'shmcb:/var/run/ocsp(128000)'` | SSLStaplingCache. |
| `directives` | Hash | `unset` | Additional SSL directives. |
