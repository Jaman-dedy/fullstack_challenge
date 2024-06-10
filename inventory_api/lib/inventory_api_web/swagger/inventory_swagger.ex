defmodule InventoryApiWeb.InventorySchemas do
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Product: swagger_schema do
        title "Product"
        description "A product in the inventory"
        properties do
          id :integer, "ID of the product"
          product_name :string, "Name of the product"
          mass_kg :float, "Mass of the product in kilograms"
          product_id :string, "Unique identifier of the product"
        end
      end,

      Inventory: swagger_schema do
        title "Inventory"
        description "Inventory details of a product"
        properties do
          id :integer, "ID of the inventory"
          product Schema.ref(:Product), "Product details"
          quantity :integer, "Quantity of the product in inventory"
          created_at :string, "Timestamp of when the inventory was created"
          updated_at :string, "Timestamp of when the inventory was last updated"
        end
      end,

      InitCatalogRequest: swagger_schema do
        title "Init Catalog Request"
        description "Request payload for initializing the product catalog"
        properties do
          product_info Schema.array(:Product), "List of products to initialize the catalog with"
        end
      end,

      InitCatalogResponse: swagger_schema do
        title "Init Catalog Response"
        description "Response payload for a successful catalog initialization"
        properties do
          status :string, "Status of the initialization operation"
          message :string, "Success message"
          catalog Schema.array(:Product), "Initialized product catalog"
        end
      end,

      GetCatalogResponse: swagger_schema do
        title "Get Catalog Response"
        description "Response payload for retrieving the product catalog"
        properties do
          status :string, "Status of the operation"
          catalog Schema.array(:Product), "Product catalog"
        end
      end,

      ReInitCatalogResponse: swagger_schema do
        title "Re-Init Catalog Response"
        description "Response payload for resetting the product catalog"
        properties do
          message :string, "Success message"
        end
      end,

      RestockRequest: swagger_schema do
        title "Restock Request"
        description "Request payload for restocking inventory"
        properties do
          _json Schema.array(:RestockItem), "List of items to restock"
        end
      end,

      RestockItem: swagger_schema do
        title "Restock Item"
        description "An item to restock in the inventory"
        properties do
          product_id :string, "ID of the product to restock"
          quantity :integer, "Quantity to add to the inventory"
        end
      end,

      RestockResponse: swagger_schema do
        title "Restock Response"
        description "Response payload for a successful restock"
        properties do
          status :string, "Status of the restock operation"
          message :string, "Success message"
          inventories Schema.array(:Inventory), "Updated inventory details"
        end
      end,

      GetInventoriesResponse: swagger_schema do
        title "Get Inventories Response"
        description "Response payload for retrieving inventories"
        properties do
          status :string, "Status of the operation"
          inventories Schema.array(:Inventory), "List of inventories"
        end
      end,

      ErrorResponse: swagger_schema do
        title "Error Response"
        description "Response payload for an error"
        properties do
          status :string, "Status of the error"
          message :string, "Error message"
        end
      end
    }
  end
end
