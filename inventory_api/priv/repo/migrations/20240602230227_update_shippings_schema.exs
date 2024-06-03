defmodule InventoryApi.Repo.Migrations.UpdateShippingsSchema do
  use Ecto.Migration

  def change do
    alter table(:shippings) do
      remove :shipped
      add :quantity, :integer, null: false
      add :product_id, references(:products, on_delete: :nothing), null: false
    end

    create index(:shippings, [:product_id])
  end
end
