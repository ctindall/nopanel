=NoPanel: multitenant hosting without the bloat=

Sometimes a shared webserver makes sense, but you still want to save your sanity. NoPanel is a solution to this need. It provides a minimal framework for organizing many Apache docroots on the same server, separating user accounts from one another, and performing other basic tasks like backups and site setup.

More important, is what NoPanel doesnt do:

* It does not provide a web user interface for administration.
* It does not require a database for administration.
* It eschews magic files and other ersatz-databases wherever applicable.
* It doesn't use a 4,000 line Perl script when 8 lines of bash will do.

I use this simple setup on my own servers, and thought it would be nice to share it with the community.
