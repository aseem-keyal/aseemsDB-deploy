# aseemsDB-deploy

## Steps to run and work on aseemsDB in development
1. Clone the aseemsDB repo at https://github.com/aseem-keyal/aseemsDB
2. Make an empty directory to store the recoll configuration and index
3. Edit dev.yml to mount the following directories as volumes: 
    1. the app folder inside the aseemsDB repo you cloned
    2. the packet archive you want to index using aseemsDB
    3. the empty recoll configuration you created
4. Run `docker-compose -f dev.yml up`
5. Run `docker exec -it aseemsdb recollindex` in order to run the initial recoll index operation. Once this completes, you can CTRL+D or `exit` out of the container
6. Open `localhost:8080` in your browser and the app folder inside your cloned aseemsDB repo in your text editor/IDE of choice
7. Edits to the aseemsDB source code should auto-reload the uvicorn server and be reflected

## Steps to run aseemsDB in production (with nginx serving static files, metrics, and S3 backups)
1. Clone this repo on your server
2. Register the domain for aseemsDB and the following subdomains: `traefik.yourdomainhere` , `grafana.yourdomainhere`, and `prometheus.yourdomainhere` 
3. Follow the guide at https://dockerswarm.rocks/  to set up Docker Swarm. 
4. Follow the first three steps of the guide at https://dockerswarm.rocks/traefik/ to set up traefik
5. Edit the `prod.sh` file and then run `source prod.sh` to set the relevant environment variables
6. Edit the prometheus data source in `grafana/provisioning/datasources/datasource.yml` to point to the prometheus endpoint you're exposing (prometheus.yourdomain:8082)
7. Set the `ACCESS_KEY` and `SECRET_KEY` environment variables for your S3 bucket (if you don't want to backup to S3 you can remove the backup service from `docker-compose.yml`)
8. Run `docker stack deploy -c docker-compose.yml aseemsdb` to create all the services
9. Give the services a minute or two to start up and then you should be able to go to your domain and see the aseemsDB UI
