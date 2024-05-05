# KV Store

_Jetzig_ provides a key-value store (powered by [JetKV](https://github.com/jetzig-framework/jetkv)) for storing `*jetzig.data.Value`. See the _Data_ section for more information on this type.

All values are automatically serialized and deserialized when they are added to/fetched from the store.

The _Store_ is available in all _View_ functions as `request.store` and in all _Jobs_ as `env.store`.

Two backends are provided for the _Store_ (as well as the _Job Queue_ and _Cache_):

* `memory` - an in-memory store.
* `file` - a file-based store providing persistent storage.

See _Configuration_ for more details.
