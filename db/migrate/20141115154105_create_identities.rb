class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :name
      t.string :email
      t.string :subdomain
      t.string :password_digest
      t.timestamps
    end
  end
end
