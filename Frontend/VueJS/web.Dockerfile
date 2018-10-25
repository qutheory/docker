# build stage
FROM node:9.11.1-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:1.13.12-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html/
# Uncomment the following line for using a custom nginx template, remember the "nginx.conf" file
#COPY nginx.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-c", "./nginx.conf", "-g", "daemon off;"]
