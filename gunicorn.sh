#!/usr/bin/env bash
NAME="application"
VENV_NAME='venv'
CODE_PATH=/code/application
DJANGODIR=$CODE_PATH
VIRTUALENV=$CODE_PATH/$VENV_NAME
USER=www-data
GROUP=www-data
NUM_WORKERS=4
NUM_THREADS=5
NUM_WORKER_CONNECTIONS=1000
WORKER_CLASS="gevent"
BIND=0.0.0.0:8000
DJANGO_WSGI_MODULE=application.wsgi
echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source $VIRTUALENV/bin/activate
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
export DB_NAME=*****
export DB_USER=*****
export DB_PASSWORD=****
export ENVIRONMENT=PROD
export DB_HOST="127.0.0.1"

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
WORKER_TMP_DIR=/code/tmp
mkdir -p $WORKER_TMP_DIR
sudo chown -R $USER:$GROUP $CODE_PATH
sudo chmod -R 755 $CODE_PATH

exec $VIRTUALENV/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --threads $NUM_THREADS \
  --worker-connections $NUM_WORKER_CONNECTIONS \
  --worker-class $WORKER_CLASS \
  --user $USER \
  --group $GROUP \
  --bind $BIND \
  --log-level=debug \
  --access-logfile $WORKER_TMP_DIR/gunicorn_access.log \
  --error-logfile $WORKER_TMP_DIR/gunicorn_error.log \
  --worker-tmp-dir $WORKER_TMP_DIR
