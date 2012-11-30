require "cequel-migrations-rails/version"

module Cequel
  module Migrations
    module Rails
      class Railtie < ::Rails::Railtie
        rake_tasks do
          load "cequel-migrations-rails/tasks/migrations.rake"
        end
      end
    end
  end
end
