FROM node:22-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npx ng build

FROM nginx:stable-alpine AS runtime

ARG NGINX_PORT=80
ENV NGINX_PORT=$NGINX_PORT

COPY --from=build /app/dist/agent_framework_web/browser /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN sed -i "s/{{NGINX_PORT}}/$NGINX_PORT/g" /etc/nginx/nginx.conf \
  && chmod +x /docker-entrypoint.sh

EXPOSE $NGINX_PORT

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/docker-entrypoint.sh"]
