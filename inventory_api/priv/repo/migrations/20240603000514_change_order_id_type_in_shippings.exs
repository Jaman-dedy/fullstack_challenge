defmodule InventoryApi.Repo.Migrations.ChangeOrderIdTypeInShippings do
  use Ecto.Migration

  def change do
    alter table(:shippings) do
      modify :order_id, :integer
    end
  end
end
