## Directory structure

```
.
├── assets # General purpose directory for assets, such as images used in README
├── inventories
│   ├── prod                    # inventory directory for `prod`
│   └── virtualbox              # inventory directory for `virtualbox`
├── playbooks                   # playbooks
│   └── group_vars              # group_vars goes here
├── roles                       # local roles for the project go here
├── roles.galaxy                # roles from galaxy go here
├── ruby                        # ruby lib directory for internal use
└── spec
    └── serverspec              # sub-directories for spec files, grouped by inventory group
        └── shared_examples
```
