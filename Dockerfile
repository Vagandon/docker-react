# Step 1: we base our "build" on the node:alpine image and tag it as "builder"
# Note: the result from the build process is in a directory <WORKDIR>/build
#       that's what we want out of this step
# replaced this: FROM node:alpine as builder
FROM node:alpine

WORKDIR '/app'
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

# Step 2: run phase
# Note: we do not have to explicitly tell that we start a new phase
#       the FROM statement implies this!
FROM nginx
EXPOSE 80

# In the next line:
# - --from identifies from which previously created temporary container we copy
# - the target directory is taken from the nginx documentation on dockerhub
# replaced this, because builder has been removed from "FROM" COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=0 /app/build /usr/share/nginx/html

# No need to start nginx; that's the default command of the image