require 'rails/generators'
module Generators
  module Service
    class ServiceGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_service_files
        template "service.rb", File.join("app/services", class_path, "#{file_name}.rb")
      end

      private

      def interface
        <<~RUBY
          def call
            step_result = yield step
            service_result = yield next_step(step_result)

            Success(service_result)
          end

          private

          def step
            Try[StandardError] do
              # your code
            end
          end

          def next_step(param)
            # your code
          end
        RUBY
      end
    end
  end
end
