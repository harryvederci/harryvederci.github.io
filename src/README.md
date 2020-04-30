# hprins.com

## Development workflow
**NOTE**: The ansible deploy setup is currently broken, due to a quickfix I had
to do to make the https config (kind of) work.

To build a new version, run the following command from
the project root directory:
    (cd src/ansible && ansible-playbook playbook.yml)
