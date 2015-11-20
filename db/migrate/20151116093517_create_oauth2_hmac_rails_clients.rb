class CreateOauth2HmacRailsClients < ActiveRecord::Migration
  def change
    create_table :oauth2_hmac_rails_clients, id: false do |t|
      t.column      :id, 'CHAR(32)'
      t.text        :encrypted_mac_key, null: false
      t.string      :mac_algorithm, default: 'hmac-sha-256'
      t.integer     :mac_request_expires_in, default: 3
      t.text        :settings
      t.timestamps null: false
    end
    add_index :oauth2_hmac_rails_clients, :id, unique: true, using: :btree
  end
end
