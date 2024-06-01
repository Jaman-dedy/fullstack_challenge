defmodule InventoryApi.Repo.Migrations.CreateRestocks do
  use Ecto.Migration

  def change do
    create table(:restocks) do
      add :quantity, :integer
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:restocks, [:product_id])
  end
end
