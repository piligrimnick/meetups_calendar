class OperationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_operation_files
    template "operation.rb", File.join("app/operations", class_path, "#{file_name}.rb")
  end

  private

  def interface
    <<~RUBY
      def call
        step_result = yield step
        operation_result = yield next_step(step_result)

        Success(operation_result)
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
