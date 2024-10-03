FROM node:20-slim AS builder
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /code
COPY . .
RUN --mount=type=cache,target=/pnpm/store,sharing=locked \
  --mount=type=cache,target=/code/.svelte-kit,sharing=locked \
  --mount=type=secret,id=npmrc,target=/root/.npmrc \
  pnpm install --frozen-lockfile && pnpm build

FROM busybox:1.36
WORKDIR /runtime
COPY --from=builder /code/build .
EXPOSE 3000
CMD ["busybox", "httpd", "-f", "-p", "3000"]
