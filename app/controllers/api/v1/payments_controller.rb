class Api::V1::PaymentsController < ApplicationController

  def index
    random = Random.new
    randomnumber = random.rand(0..1000).to_s
  	time = DateTime.now.strftime('%Y%m%d%H%M%S')
  	hashCode = 'A3EFDFABA8653DF2342E8DAC29B51AF0'
  	urlHash = 'vpc_AccessCode=D67342C2&vpc_Amount='+params[:amount]+'00&vpc_Command=pay&vpc_Currency=VND&vpc_Customer_Email=support@onepay.vn&vpc_Customer_Id=thanhvt&vpc_Customer_Phone=840904280949&vpc_Locale=vn&vpc_MerchTxnRef='+time+randomnumber+'&vpc_Merchant=ONEPAY&vpc_OrderInfo=JSECURETEST01&vpc_ReturnURL=http://localhost:3000/payment_process&vpc_SHIP_City=Ha Noi&vpc_SHIP_Country=Viet Nam&vpc_SHIP_Provice=Hoan Kiem&vpc_SHIP_Street01=39A Ngo Quyen&vpc_TicketNo=::1&vpc_Version=2'
  	url = 'vpc_AccessCode=D67342C2&vpc_Amount='+params[:amount]+'00&vpc_Command=pay&vpc_Currency=VND&vpc_Customer_Email=support%40onepay.vn&vpc_Customer_Id=thanhvt&vpc_Customer_Phone=840904280949&vpc_Locale=vn&vpc_MerchTxnRef='+time+randomnumber+'&vpc_Merchant=ONEPAY&vpc_OrderInfo=JSECURETEST01&vpc_ReturnURL=http%3A%2F%2Flocalhost%3A3000%2Fpayment_process&vpc_SHIP_City=Ha+Noi&vpc_SHIP_Country=Viet+Nam&vpc_SHIP_Provice=Hoan+Kiem&vpc_SHIP_Street01=39A+Ngo+Quyen&vpc_TicketNo=%3A%3A1&vpc_Version=2'
  	hmac = OpenSSL::HMAC.hexdigest('SHA256', [hashCode].pack('H*'), urlHash) 
  	url = 'https://mtf.onepay.vn/onecomm-pay/vpc.op?Title=VPC+3-Party&' +url +'&vpc_SecureHash=' + hmac.upcase
    
    payment = Payment.new
    payment.uid = params[:uid]
    payment.refcode = time + randomnumber
    payment.done = false
    payment.amount = (params[:amount].to_i)*100
    payment.save

   	render json: {
   		url: url
    }, status: :ok
  end

end