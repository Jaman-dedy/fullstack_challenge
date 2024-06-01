defmodule InventoryApi.Shipping do
  @moduledoc """
  The Shipping context.
  """

  import Ecto.Query, warn: false
  alias InventoryApi.Repo

  alias InventoryApi.Shipping.Shippings

  @doc """
  Returns the list of shippings.

  ## Examples

      iex> list_shippings()
      [%Shippings{}, ...]

  """
  def list_shippings do
    Repo.all(Shippings)
  end

  @doc """
  Gets a single shippings.

  Raises `Ecto.NoResultsError` if the Shippings does not exist.

  ## Examples

      iex> get_shippings!(123)
      %Shippings{}

      iex> get_shippings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shippings!(id), do: Repo.get!(Shippings, id)

  @doc """
  Creates a shippings.

  ## Examples

      iex> create_shippings(%{field: value})
      {:ok, %Shippings{}}

      iex> create_shippings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shippings(attrs \\ %{}) do
    %Shippings{}
    |> Shippings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shippings.

  ## Examples

      iex> update_shippings(shippings, %{field: new_value})
      {:ok, %Shippings{}}

      iex> update_shippings(shippings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shippings(%Shippings{} = shippings, attrs) do
    shippings
    |> Shippings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shippings.

  ## Examples

      iex> delete_shippings(shippings)
      {:ok, %Shippings{}}

      iex> delete_shippings(shippings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shippings(%Shippings{} = shippings) do
    Repo.delete(shippings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shippings changes.

  ## Examples

      iex> change_shippings(shippings)
      %Ecto.Changeset{data: %Shippings{}}

  """
  def change_shippings(%Shippings{} = shippings, attrs \\ %{}) do
    Shippings.changeset(shippings, attrs)
  end
end
