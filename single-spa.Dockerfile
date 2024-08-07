FROM node:20-slim AS builder
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /code
COPY . .
RUN --mount=type=cache,target=/pnpm/store,sharing=locked \
  pnpm install --frozen-lockfile && pnpm build

FROM busybox:1.36
WORKDIR /dist
COPY --from=builder /code/dist .
EXPOSE 3000
CMD ["busybox", "httpd", "-f", "-p", "3000"]
