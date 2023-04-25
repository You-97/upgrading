
FROM node:10.9.0 As builder

WORKDIR /usr/src/app
COPY / ./
COPY package*.json  ./

RUN npm install -g @angular/cli@8.2.3 && \
    npm install && \
    ng build --prod
COPY . .

FROM nginx:1.17.1-alpine
WORKDIR /usr/src/app
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
ENTRYPOINT ["nginx", "-g", "daemon off;"]
EXPOSE 80

#FROM node:14.17.3 AS build
#ARG ENV=production
#WORKDIR /usr/src/app
#COPY package.json package-lock.json ./
#RUN npm install --only=development
#COPY . .
#RUN npm run build --configuration=$ENV
#
#
#FROM node:14.17.3
#WORKDIR /usr/src/app
#COPY package*.json ./
#RUN npm install --only=production
#COPY . .
#COPY --from=build /usr/src/app/frontend-kerburos ./dist
#EXPOSE 80
#CMD ["node", "dist/main"]

# ****

# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
#FROM node:14.17.3 as build-stage
#WORKDIR /app
#COPY package*.json /app/
#RUN npm install
#COPY ./ /app/
#
#CMD ng build --prod
#RUN npm run build
#--output-path=./dist --configuration $configuration
# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
#FROM nginx:1.15
#COPY --from=build-stage /app/dist/ /usr/share/nginx/html
# Copy the default nginx.conf provided by tiangolo/node-frontend
#COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf

#-------------------------------------------
# Stage 1: Compile and Build angular codebase
#
## Use official node image as the base image
#FROM node:14.17.3 as build
#
## Set the working directory
#WORKDIR /usr/src/app
#
## Add the source code to app
#COPY package*.json ./
#
#COPY . .
#
#EXPOSE 4200
#
#CMD [ "npm", "start" ]

#----------------------------------
# Stage 1
#FROM node:14.17.3 as build-step
#
#RUN mkdir /usr/src/app
#
#WORKDIR /usr/src/app
#
#CMD npm clean install
#
#COPY . /usr/src/app
#
#EXPOSE 4200
#
#RUN npm start

