defmodule InventoryApi.Repo.Migrations.AddProductIdToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :product_id, :integer
    end

    create unique_index(:products, [:product_id])
  end
end
