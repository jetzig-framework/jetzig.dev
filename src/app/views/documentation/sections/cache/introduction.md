# Cache

_Jetzig_ provides a cache interface identical to the _Store_. Refer to the _Store_ documentation for usage instructions.

The _Cache_ is available in all view functions as `request.cache`.

Separating the _Store_ and _Cache_ allows configuring different _JetKV_ backends for each. For example, you may want to use _JetKV_'s file-based storage for persisting the key-value store between server restarts and use an in-memory store for transient cache data.

The default backend for the Cache is the `memory` backend.
