# Micro Ads app

## Create local db:

    createdb -U username -h localhost db_name_development
    createdb -U username -h localhost db_name_test

## Start migrations

    bin/rake db:migrate

## Start the server

    bin/puma

## Open the console

    bin/console

## Start specs

    bin/rspec
