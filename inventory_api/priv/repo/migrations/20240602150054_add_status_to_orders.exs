defmodule InventoryApi.Repo.Migrations.AddStatusToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :status, :string, default: "init"
    end
  end
end
