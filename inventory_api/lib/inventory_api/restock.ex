# defmodule InventoryApi.Restock do
#   @moduledoc """
#   The Restock context.
#   """

#   import Ecto.Query, warn: false
#   alias InventoryApi.Repo

#   alias InventoryApi.Restock.Restocks

#   @doc """
#   Returns the list of restocks.

#   ## Examples

#       iex> list_restocks()
#       [%Restocks{}, ...]

#   """
#   def list_restocks do
#     Repo.all(Restocks)
#   end

#   @doc """
#   Gets a single restocks.

#   Raises `Ecto.NoResultsError` if the Restocks does not exist.

#   ## Examples

#       iex> get_restocks!(123)
#       %Restocks{}

#       iex> get_restocks!(456)
#       ** (Ecto.NoResultsError)

#   """
#   def get_restocks!(id), do: Repo.get!(Restocks, id)

#   @doc """
#   Creates a restocks.

#   ## Examples

#       iex> create_restocks(%{field: value})
#       {:ok, %Restocks{}}

#       iex> create_restocks(%{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def create_restocks(attrs \\ %{}) do
#     %Restocks{}
#     |> Restocks.changeset(attrs)
#     |> Repo.insert()
#   end

#   @doc """
#   Updates a restocks.

#   ## Examples

#       iex> update_restocks(restocks, %{field: new_value})
#       {:ok, %Restocks{}}

#       iex> update_restocks(restocks, %{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def update_restocks(%Restocks{} = restocks, attrs) do
#     restocks
#     |> Restocks.changeset(attrs)
#     |> Repo.update()
#   end

#   @doc """
#   Deletes a restocks.

#   ## Examples

#       iex> delete_restocks(restocks)
#       {:ok, %Restocks{}}

#       iex> delete_restocks(restocks)
#       {:error, %Ecto.Changeset{}}

#   """
#   def delete_restocks(%Restocks{} = restocks) do
#     Repo.delete(restocks)
#   end

#   @doc """
#   Returns an `%Ecto.Changeset{}` for tracking restocks changes.

#   ## Examples

#       iex> change_restocks(restocks)
#       %Ecto.Changeset{data: %Restocks{}}

#   """
#   def change_restocks(%Restocks{} = restocks, attrs \\ %{}) do
#     Restocks.changeset(restocks, attrs)
#   end
# end
