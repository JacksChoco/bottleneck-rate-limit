
FROM node:8.4.0
WORKDIR /app
ADD    ./package.json         /app/
RUN    npm install

ADD    ./src/                 /app/src/

CMD ["npm", "run", "start"]