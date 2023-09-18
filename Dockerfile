FROM ruby:3.2.1

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app/docker-entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
