defmodule InventoryApi.Repo.Migrations.CreateShippings do
  use Ecto.Migration

  def change do
    create table(:shippings) do
      add :shipped, {:array, :map}
      add :order_id, references(:orders, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:shippings, [:order_id])
  end
end
