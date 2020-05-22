NOTE: the content of this directory is currently not used to generate (content
for the) html pages of the hprins.com website.

## Getting started
Installation command:

    pip3 install -U -r requirements.txt --user && ./create-db.sql


Command to run datasette:

    datasette .data/data.db --port 3000 --cors --config default_cache_ttl:0


## Configuring full-text search
Datasette supports SQLite full-text search. You can configure it for a table
using the `sqlite-utils` command-line tool.

Command to show the tables and columns in your database:

    sqlite-utils tables path/to/your/file.db --table --columns


Command to make the `example` table searchable by `headline` and `body`:

    sqlite-utils enable-fts path/to/your/file.db example headline body --fts4

Now Datasette will display a search box for the specified columns.

## Misc
Uncomment lines in `requirements.txt` to install extra plugins.

