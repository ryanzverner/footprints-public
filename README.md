# Footprints

This program is an applicant tracking tool that allows users to manage the employee hiring process from start to finish.

1. Install Docker for Mac (or whatever)
1. Run the following commands:

  ```
  docker-compose build
  docker-compose up
  docker ps -a # see the container running
  docker exec -it footprints /bin/bash # get into the container
  ```

#### Note

Footprints requires anybody who logs in to also be a crafter. You will have to manually add a person to the system as a crafter in order to log into Footprints.
