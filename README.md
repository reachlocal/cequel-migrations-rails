# Cequel Migrations Rails Plugin

This Rails plugin basically provides a migration setup very similar to the
standard ActiveRecord based migration system that normally exists in rails.
The BIG difference is that it is designed to support specifically migrations
for Cassandra data stores using Cequel.

## Installation

Add this line to your application's Gemfile:

    gem 'cequel-migrations-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cequel-migrations-rails

## Usage

For information on how to use this gem in your rails app please refer to the
following. Note: You need to have the cequel gem setup and configured already
in your Rails app before using this gem.

### Initial Setup

Before you can start using this gem you need to create the initial directory
structure in your Rails app for it. You can do this using the following
command:

```
rails g cequel:migrations:install
```

This creates the directory structure `cequel/migrate/` at the root of your
Rails application as the place to store your migration scripts.

### Generate Migration File

To write a migration you first need to generate a migration file. This is done
with the following command where `<migration_name>` is replaced with the name
of the migration.

```
rails g cequel:migration <migration_name>
```

An example of the above command with a migration name would look as follows:

```
rails g cequel:migration CreateUserColumnFamily
```

### Create Database

To create the database specified in your `config/cequel.yml` and create a
column family in it called `schema_migrations` run the following command:

```
rake cequel:create
```

### Drop Database

If you have already created the database and you want to drop it to start from
scratch or something you can do so by running the following command:

```
rake cequel:drop
```

### Migrate Database

If you database exists with a `schema_migrations` column family already
because you followed the directions above in the "Create Database" section you
can migrate the database with the following command:

```
rake cequel:migrate
```

### Rollback Migrations

If you need to rollback a migration you do so with the following command:

```
rake cequel:rollback
```

If you need to rollback multiple migrations you can do so as follows, where 5
is the number of steps I wanted to rollback.

```
STEPS=5 rake cequel:rollback
```

## Writing Migrations

When you generate a migration you may know that it sets up the migration class
with a base class of `Cequel::Migration`.

The `Cequel::Migration` class provides the `execute` method to be used inside
of your migrations `up` and `down` methods. The `execute` method takes a
string of CQL.

At the moment we currently only provide the `execute` method. However, we plan
to provide other helper functions like, `create_column_family`,
`drop_column_family`, etc.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
