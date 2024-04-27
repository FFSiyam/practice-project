FROM node:21-alpine3.18 AS builder
WORKDIR /react-app
COPY ./package*.json /react-app
RUN npm install --verbose
COPY . .
RUN npm run build


FROM nginx:1.25.5-alpine
COPY --from=builder /react-app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon-off;"]