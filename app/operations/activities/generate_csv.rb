require 'csv'

module Activities
  class GenerateCsv < BaseOperation
    param :activities

    option :fields, default: -> { %i[title author short_description start_at end_at] }

    def call
      bytes = yield generate_csv

      Success(bytes)
    end

    private

    def generate_csv
      Try[StandardError] do
        CSV.generate(headers: true) do |csv|
          csv << fields

          activities.each do |a|
            csv << fields.map { |f| a.public_send(f) }
          end
        end
      end
    end
  end
end
