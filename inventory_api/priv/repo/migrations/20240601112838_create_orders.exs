defmodule InventoryApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :requested, {:array, :map}

      timestamps(type: :utc_datetime)
    end
  end
end
