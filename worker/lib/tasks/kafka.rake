namespace :kafka do
  desc 'Consume source from Kafka and write into DB'
  task consume: :environment do
    puts "Ready to consume Kafka"
    consumer = kafka.consumer(group_id: 'connect-couchbase-source')
    consumer.subscribe(ENV['CONNECT_COUCHBASE_SOURCE_TOPIC'], start_from_beginning: false)

    consumer.each_message do |message|
      payload = JSON.parse(message.value).with_indifferent_access
      content = JSON.parse(Base64::decode64(payload[:content])).with_indifferent_access rescue {}
      perform_update(content) do |c|
        puts "Simulate model updated and trigger callback from model to couchbase [_id=#{c[:_id]}]"
      end
    end
  end

  desc 'Produce message to Kafka and write into couchbase by sink connector'
  task produce: :environment do
    puts "Produce sample update to kafka"

    send_once(sample_order)
  end

  def perform_update(content)
    sync_digest = content.extract!(:sync_digest).values.first
    if content[:_id].present? && sync_digest == Digest::MD5.hexdigest(content.to_json)
      puts "Prevented loopback from model #{content[:_id]}"
    elsif content[:_id].present?
      yield(content)

      # here simulate loopback from model callback
      content[:sync_digest] = Digest::MD5.hexdigest(content.to_json)
      send_once(content)
    end
  end

  def kafka
    @kafka ||= Kafka.new(Array.wrap(ENV['CONNECT_BOOTSTRAP_SERVERS']),
      ssl_ca_cert: File.read('/src/certificate.pem'), # self-signed cert here as SSL is required by sasl authenticator
      sasl_plain_username: ENV['CONNECT_API_KEY'],
      sasl_plain_password: ENV['CONNECT_API_SECRET']
    )
  end

  def send_once(payload, topic: ENV['CONNECT_COUCHBASE_SINK_TOPIC'])
    producer = kafka.producer
    producer.produce(payload.to_json, topic: topic)
    producer.deliver_messages
  end

  def sample_order
    JSON.parse('{"_id":"53e6e98afb8089cb98000001","admin_authorization_token":"M39-VKEMu-4iM8GcLWZx7Q","affiliate_data":{},"auth_token_expired_at":null,"authorization_token":"zBmTxfavlO2scM0ldjMi_g","cancelled_at":null,"cart_attributes":null,"confirmed_at":null,"coupon_ids":[],"created_at":"2014-08-10T03:39:54.556Z","created_by":null,"created_by_channel_id":null,"currency_iso":"HKD","custom_fields":{},"custom_fields_translations":[],"customer_email":"tony+246@shoplineapp.com","customer_id":"53e5d438fb80896a77000003","customer_info":{},"customer_name":"Tony Wong","customer_phone":"0912345678","customer_phone_country_code":null,"customer_type":"Merchant","delivery_address":null,"delivery_data":{"_id":"5b95fb9b9791de57c196b930","delivery_type":null,"hk_sfp_home_region":null,"location_code":null,"location_name":null,"name_translations":null,"recipient_name":null,"recipient_phone":null,"recipient_phone_country_code":null,"scheduled_delivery_date":null,"shipment_number":null,"sn_id":null,"store_address":null,"time_slot":null,"time_slot_key":null,"tracking_number":null,"url":null},"delivery_option_id":"53513098fb80893070000001","edited_at":null,"expired_at":null,"fb_tracked_at":null,"first_mail_sent_at":null,"ga_tracked":false,"invoice_last_exported_at":null,"item_ids":["53e6e98afb8089cb98000002"],"label_last_printed_at":null,"language_code":"en","last_cancelled_at":null,"last_confirmed_at":null,"last_fulfilled_at":null,"membership_tier_data":null,"order_delivery_id":"57be5d7669702d4aa1000000","order_number":"101408401255","order_payment_id":"53e6e98afb8089cb98000004","order_remarks":"","parent_order_id":null,"payment_method_id":"53e296cc148f87e84c37bb0c","performer_id":null,"product_subscription_id":null,"product_subscription_period":null,"ref_data":{"subscription_id":"53e6e98bfb8089cb98000005","type":"master","payment_response":{"successcode":"0","Ref":"53e6e98bfb8089cb98000005","PayRef":"1617757","Amt":"156.0","Cur":"344","prc":"0","src":"0","Ord":"12345678","Holder":"testing card","AuthId":"617757","TxTime":"2014-08-10 11:39:57.0","errMsg":"Transaction completed\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n"}},"ref_order_id":null,"removed_at":null,"seller_id":"53503a11fb8089acfe000011","seller_type":"Merchant","skip_fulfillment":false,"split_at":null,"status":"completed","stock_picking_last_exported_at":null,"subscription_id":"53e6e98bfb8089cb98000005","subtotal":{"cents":15600,"currency_symbol":"HK$","currency_iso":"HKD","label":"HK$156.00","dollars":156.0},"total":{"cents":15600,"currency_symbol":"HK$","currency_iso":"HKD","label":"HK$156.00","dollars":156.0},"track_data":{"referral_action":"Plans"},"updated_at":"2018-06-19T09:46:37.390Z","utm_data":{},"validation_errors":null}').with_indifferent_access.tap do |data|
      data[:updated_at] = DateTime.now
    end
  end
end
