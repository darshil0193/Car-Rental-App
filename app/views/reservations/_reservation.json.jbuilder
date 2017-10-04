json.extract! reservation, :id, :checkout_time, :return_time, :checked_out, :reserved, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
