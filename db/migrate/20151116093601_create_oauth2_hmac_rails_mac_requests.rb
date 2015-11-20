class CreateOauth2HmacRailsMacRequests < ActiveRecord::Migration
  def change
    create_table :oauth2_hmac_rails_mac_requests, id: false do |t|
      t.string      :id, 'CHAR(32)' # uuid
      t.column      :client_id, 'CHAR(32)' # uuid
      t.string      :ip, limit: 64 # client ip
      t.string      :method, limit: 8 # get, post, put, etc...
      t.string      :uri # request path
      t.string      :host, limit: 128 # hostname
      t.string      :port, limit: 8 # port
      t.string      :ts, null: false, limit: 10 # timestamp
      t.string      :nonce, null: false # timestamp + random str
      t.string      :ext, default: '', null: false # generally md5(request_body)
      t.string      :mac, null: false # mac signature
      t.string      :uts, null: false, limit: 10 # created at in unixtime format
      t.string      :status, null: true 
    end

    add_index :oauth2_hmac_rails_mac_requests, :id, unique: true, using: :btree
    add_index :oauth2_hmac_rails_mac_requests, :client_id
    add_index :oauth2_hmac_rails_mac_requests, [ :mac, :nonce, :ext ], unique: true
  end
end
