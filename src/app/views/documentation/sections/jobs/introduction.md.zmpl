# Jobs

_Jetzig_ provides a framework for scheduling background/asynchronous jobs. _Jobs_ are executed by a number of background worker threads and can be scheduled from a _View_.

Use _Jobs_ for any heavy-lifting that needs to be done after a request has completed. For example, _Jetzig_'s _Mailer_ framework has an internal _Job_ used for sending emails from a _View_ function.

By default, the _Jobs_ queue is stored in memory, but this can be configured to use persistent disk storage if required (see _Configuration_ for more information).
