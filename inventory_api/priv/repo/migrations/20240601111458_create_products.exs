defmodule InventoryApi.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :product_name, :string
      add :mass_kg, :float

      timestamps(type: :utc_datetime)
    end
  end
end
