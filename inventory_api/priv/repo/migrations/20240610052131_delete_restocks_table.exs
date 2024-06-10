defmodule InventoryApi.Repo.Migrations.DeleteRestocksTable do
  use Ecto.Migration

  def change do
    drop table(:restocks)
  end
end
