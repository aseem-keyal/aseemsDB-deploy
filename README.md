# aseemsDB-deploy

## Steps to run and work on aseemsDB in development
1. Clone the aseemsDB repo at https://github.com/aseem-keyal/aseemsDB
2. Make an empty directory to store the recoll configuration and index
3. Edit dev.yml to mount the following directories as volumes: 
    1. the app folder inside the aseemsDB repo you cloned (skip this if you don't want to make any changes to the app and just run it as is)
    2. the packet archive you want to index using aseemsDB
    3. the empty recoll configuration you created
4. Run `docker-compose -f dev.yml up`
5. Run `docker exec -it aseemsdb recollindex` in order to run the initial recoll index operation. Once this completes, you can CTRL+D or `exit` out of the container
6. Open `localhost:8080` in your browser and the app folder inside your cloned aseemsDB repo in your text editor/IDE of choice

Edits to the aseemsDB source code should auto-reload the uvicorn server and be reflected in the running app.

## Steps to run aseemsDB in production (with nginx serving static files, metrics, and S3 backups)
1. Clone this repo on your server into your home directory
2. Create an empty `recollconf` directory and a populated `packet_archive` directory in your home directory
3. Register the domain for aseemsDB and the following subdomains: `traefik.yourdomainhere` , `grafana.yourdomainhere`, and `prometheus.yourdomainhere` 
4. Follow the guide at https://dockerswarm.rocks/  to set up Docker Swarm. 
5. Follow the first three steps of the guide at https://dockerswarm.rocks/traefik/ to set up a docker network and node for traefik
6. Edit the `prod.sh` file and then run `source prod.sh` to set the relevant environment variables
7. Edit the prometheus data source in `grafana/provisioning/datasources/datasource.yml` to point to the prometheus endpoint you're exposing (`prometheus.yourdomain:8082`)
8. Set the `ACCESS_KEY` and `SECRET_KEY` environment variables for your S3 bucket (if you don't want to backup to S3 you can remove the backup service from `docker-compose.yml`)
9. Run `docker network create --driver=overlay inbound` to create another docker network
10. Run `docker stack deploy -c docker-compose.yml aseemsdb` to create all the services
11. Give the services a minute or two to start up and then you should be able to go to your domain and see the aseemsDB UI
12. Run `docker exec -it [aseemsdb container name here] bash` to enter the aseemsdb container and then run `recollindex` to start indexing

You now have a deployed instance of aseemsDB with metrics, logging, and automated backups that can be scaled by adding more docker swarm nodes to your cluster.
