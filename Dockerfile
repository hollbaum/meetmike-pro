# Stage 1: Install dependencies and build the application
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and yarn.lock to install dependencies from the 'app' directory
COPY app/package.json app/yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application code from the 'app' directory
COPY app/ .

# Build the Next.js application
RUN yarn build

# Stage 2: Serve the application with a smaller runtime image
FROM node:18-alpine AS runner

WORKDIR /app

# Set production environment
ENV NODE_ENV production

# Copy necessary files from the builder stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/public ./public

# Expose the port Next.js listens on
EXPOSE 3000

# Command to run the application
CMD ["yarn", "start"]