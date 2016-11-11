#!/bin/sh

SETTINGS=""

usage(){
    echo ""
    echo "./reset_migrations.sh"
    echo "\t-h --help"
    echo "\t--settings=<your settings file>"
    echo ""
}

error_exit() {
	echo "$1" 1>&2
	exit 1
}


while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --settings)
            SETTINGS=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
done

if [ -z $SETTINGS ]
   then
       usage
       exit 1
   fi

echo "Starting ..."

export DJANGO_SETTINGS_MODULE=$SETTINGS

echo ">> Deleting database migrations..."
sudo -u postgres psql -c "DELETE FROM django_migrations;" -d new_test_database || error_exit "Cannot delete database migrations! Aborting"
echo ">> Done"

echo ">> Erase all migrations..."
find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc"  -delete
echo ">> Done"

echo ">> Making migrations..."
python manage.py makemigrations || error_exit "Cannot make migrations! Aborting"
echo ">> Done"

echo ">> Resetting the migrations for the 'built-in' apps..."
python manage.py migrate --fake || error_exit "Cannot reset migrations! Aborting"
echo ">> Done"

echo ">> Migrating contenttypes..."
python manage.py migrate contenttypes || error_exit "Cannot make migrations! Aborting"
echo ">> Done"

echo ">> Faking migrations..."
# replace --fake-initial with --fake to make it work for Django 1.9
python manage.py migrate --fake-initial || error_exit "Cannot fake migrations! Aborting"
echo ">> Done"

echo ">> Migrating..."
python manage.py migrate || error_exit "Almost done... or not :("
echo ">> Done"

echo "All done!"
