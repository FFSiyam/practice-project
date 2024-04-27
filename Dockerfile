FROM node:21-alpine3.18
WORKDIR /react-app
COPY ./package*.json /react-app
RUN npm install --verbose
COPY . .
EXPOSE 3000
RUN npm run build
CMD ["npm" , "start"]
