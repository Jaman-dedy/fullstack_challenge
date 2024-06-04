defmodule InventoryApi.Repo.Migrations.AddStatusToShippings do
  use Ecto.Migration

  def change do
    alter table(:shippings) do
      add :status, :string, default: "in_progress"
    end
  end
end
