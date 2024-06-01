defmodule InventoryApi.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias InventoryApi.Repo

  alias InventoryApi.Inventory.Inventories

  @doc """
  Returns the list of inventories.

  ## Examples

      iex> list_inventories()
      [%Inventories{}, ...]

  """
  def list_inventories do
    Repo.all(Inventories)
  end

  @doc """
  Gets a single inventories.

  Raises `Ecto.NoResultsError` if the Inventories does not exist.

  ## Examples

      iex> get_inventories!(123)
      %Inventories{}

      iex> get_inventories!(456)
      ** (Ecto.NoResultsError)

  """
  def get_inventories!(id), do: Repo.get!(Inventories, id)

  @doc """
  Creates a inventories.

  ## Examples

      iex> create_inventories(%{field: value})
      {:ok, %Inventories{}}

      iex> create_inventories(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventories(attrs \\ %{}) do
    %Inventories{}
    |> Inventories.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a inventories.

  ## Examples

      iex> update_inventories(inventories, %{field: new_value})
      {:ok, %Inventories{}}

      iex> update_inventories(inventories, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventories(%Inventories{} = inventories, attrs) do
    inventories
    |> Inventories.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a inventories.

  ## Examples

      iex> delete_inventories(inventories)
      {:ok, %Inventories{}}

      iex> delete_inventories(inventories)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventories(%Inventories{} = inventories) do
    Repo.delete(inventories)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventories changes.

  ## Examples

      iex> change_inventories(inventories)
      %Ecto.Changeset{data: %Inventories{}}

  """
  def change_inventories(%Inventories{} = inventories, attrs \\ %{}) do
    Inventories.changeset(inventories, attrs)
  end
end
