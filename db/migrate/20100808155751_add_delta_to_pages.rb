class AddDeltaToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :delta, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :delta
  end
end
