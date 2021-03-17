# Micro Ads app

## Create local db:

    psql -U username -d postgres
    create database db_name

## Start migrations

    bundle exec sequel -m db/migrations postgres://user:password@localhost/db_name
