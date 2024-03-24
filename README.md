# Introduction

This project is just a showcase for a chat system that is intended to work as a microservice in between multiple services.

## Environment

* Ruby 3.1.2
* Rails (API only) 7.0.3
* Mysql
* Redis server 7.0.4
* Elasticsearch
* Sidekiq

## Getting started

1. Install `docker` which includes docker-compose from <https://docs.docker.com/engine/install/> (if not installed)
2. Clone the project's main branch:

    ```bash
    git@github.com:abdulashref333/Instabug-Task.git
    ```

3. Head to the project root directory `cd Instabug-Task`
4. > **_NOTE:_**  For Windows users you will need to convert `docker/entrypoint.sh` file line break type from CRLF to LF.
5. Copy `.env.example` to `.env`.

    ```bash
    cp docker/.env.example .env
    ```

6. Replace `APP_USER_ID` value in `.env` with your `user ID`

    ```bash
    sed  -i "/APP_USER_ID=/c\APP_USER_ID=$(id -u)" .env
    ```

7. Create project docker network

    ```bash
    docker network create ebooster_private_network
    ```

8. Run `docker compose up`

You can now visit `http://localhost:3000/`

## API-Endpoints

* **root path**: /api/v1

| Method | Endpoint                                                     | Description                                | Request Body                     |
|--------|--------------------------------------------------------------|--------------------------------------------|----------------------------------|
| POST   | /applications                                                | Create new application                     | {"name": "application #1"}       |
| GET    | /applications/:token                                         | Get application data                       |                                  |
| PATCH  | /applications/:token                                         | Update application name                    | {"name": "application #2"}       |
|--------|--------------------------------------------------------------|--------------------------------------------|----------------------------------|
| POST   | /applications/:token/chats                                   | Create new chat                            | {}                               |
| GET    | /applications/:token/chats                                   | Get List of chats for specific application |                                  |
| GET    | /applications/:token/chats/:number                           | Get chat data                              |                                  |
|--------|--------------------------------------------------------------|--------------------------------------------|----------------------------------|
| POST   | /applications/:token/chats/:number/messages                  | Add new message to specific chat           | {"body": "test message body #2"} |
| GET    | /applications/:token/chats/:number/messages                  | Get List of messages for specific chat     |                                  |
| GET    | /applications/:token/chats/:number/messages/search           | Search in chat message                     |                                  |
| GET    | /applications/:token/chats/:number/messages/:message_number  | Get message data                           |                                  |
| PATCH  | /applications/:token/chats/:number/messages/:message_number  | Update message data(body)                  | {"body": "test message body #3"} |

* Example of a full endpoint: `POST: http://localhost:3000/api/v1/applications`
