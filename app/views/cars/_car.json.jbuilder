json.extract! car, :id, :registration_number, :status, :model, :manufacturer, :rate, :created_at, :updated_at
json.url car_url(car, format: :json)
