Reset Django migrations script
==========

You work on Django project? You always wanted 'reset_migrations' manage command? Your migrations always f\*cked up? You work with bunch of people and get tired of merging f\*cking migrations? You have a lot of f\*cking migrations and tired of waiting till they all will be applied?

**This script is for you and your team!**

Clean up migrations with just one press.


* You do not need to restore schema or data from database.
* This script is written on pure Bourne shell
* It is simple
* Database independent - script not using any db specific commands

##### Usage
```bash
    ./reset_migrations --settings=project_settings
```

```bash
    ./reset_migrations.sh --help

    ./reset_migrations.sh
    	-h --help
    	--settings=<your settings file>
        --makemigrations, if you need to create migrations 

```
