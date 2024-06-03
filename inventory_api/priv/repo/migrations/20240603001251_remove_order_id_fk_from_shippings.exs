defmodule InventoryApi.Repo.Migrations.RemoveOrderIdFkFromShippings do
  use Ecto.Migration

  def change do
    alter table(:shippings) do
      remove :order_id
      add :order_id, :integer
    end
  end
end
