require "httparty"

class BookingsController < ApplicationController

  # Move to helper
  def dollars_to_cents(dollars)
    (100 * dollars.to_r).to_i
  end


  def list_all
    request_manager = RequestManager.new()
    @transactions = request_manager.get_request("gateways", ENV['GATEWAY_TOKEN'], "transactions.json?order=desc&state=succeeded")['transactions']
  end

  def index
    @bookings = Booking.all
  end

	def new
    @selected_flight = Flight.find(params[:flight_id])
    @booking = Booking.new()
    @booking.flight_id = @selected_flight.id
  end



  def create
    safe_params = params.require(:booking).permit(:flight_id, :amount_charged, :amount_charged, :payment_token, :email, :is_pmd, :is_save_credit_card)
    @booking = Booking.new(safe_params)

    request_manager = RequestManager.new()
    if @booking.is_pmd?
      success_message = 'Successful payment through Expedia'
      purchase_params =  {
        'delivery':{
          'payment_method_token': safe_params[:payment_token],
          'url': 'https://spreedly-echo.herokuapp.com',
          'headers': 'Content-Type: application/json',
          'body': '{ "card_number": "{{credit_card_number}}" }'
        }
      }.to_json

      response = request_manager.post_request("receivers", ENV['RECIEVER_TOKEN'], "deliver.json", purchase_params)
    else

      success_message = 'Successful payment, pack your bags'
      purchase_params ={
        'transaction':{
          'payment_method_token': safe_params[:payment_token],
          'amount': dollars_to_cents(safe_params[:amount_charged]),
          'currency_code': 'USD',
          'retain_on_success': safe_params[:is_save_credit_card]
        }
      }.to_json 

      response = request_manager.post_request("gateways", ENV['GATEWAY_TOKEN'], "purchase.json", purchase_params)
    end


    if response['transaction']['succeeded'] == true
      @booking.save
      flash['success'] = success_message
      redirect_to bookings_path
    else
      if response['transaction']['message'] != ""
          flash_message = response['transaction']['message']
        else
          flash_message = "Something went wrong, danggggg. Try again?"
        end
        flash['alert'] = flash_message
        redirect_to bookings_new_path + '?flight_id=' + safe_params[:flight_id]
     end
  end
end


class RequestManager
  include HTTParty
  base_uri 'https://core.spreedly.com/v1'

  def initialize()
  end

  private def base_options
    {
      headers: {
        'Content-Type' => 'application/json'
      },
      basic_auth: {
        username: ENV['ENV_KEY'],
        password: ENV['API_KEY']
      }
    }
  end

  def get_request(path, token, endpoint)
    final_uri = path + '/' + token + '/' + endpoint
    resp = self.class.get('/' + final_uri, base_options).parsed_response
    return resp
  end

  def post_request(path, token, endpoint, request_body)
    request_options = base_options
    request_options[:body] = request_body

    
    final_uri = path + '/' + token + '/' + endpoint
    self.class.post('/' + final_uri, request_options).parsed_response
  end
end
