defmodule InventoryApi.Repo.Migrations.UpdateOrdersTable do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      remove :requested
      add :order_id, :integer
      add :product_id, :integer
      add :quantity, :integer
    end
  end
end
