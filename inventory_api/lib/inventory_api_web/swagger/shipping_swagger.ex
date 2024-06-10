defmodule InventoryApiWeb.ShippingSchemas do
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
      ShippedItem: swagger_schema do
        title "Shipped Item"
        description "An item in a shipped package"
        properties do
          product_id :string, "ID of the product"
          quantity :integer, "Quantity of the product"
        end
      end,

      ShippedPackage: swagger_schema do
        title "Shipped Package"
        description "Details of a shipped package"
        properties do
          id :integer, "ID of the shipped package"
          order_id :string, "ID of the associated order"
          quantity :integer, "Quantity of the product in the package"
          product Schema.ref(:Product), "Product details"
          status :string, "Status of the shipped package"
          inserted_at :string, "Timestamp of when the package was shipped"
          updated_at :string, "Timestamp of when the package was last updated"
        end
      end,

      ShipPackageResponse: swagger_schema do
        title "Ship Package Response"
        description "Response payload for shipping a package"
        properties do
          status :string, "Status of the shipping operation"
          message :string, "Success or error message"
          shipped_package_itinerary Schema.array(:ShippedPackage), "Itinerary of the shipped packages"
        end
      end,

      ShippingResponse: swagger_schema do
        title "Shipping Response"
        description "Response payload for retrieving a shipping"
        properties do
          shipping Schema.ref(:Shipping), "Shipping details"
        end
      end,

      Shipping: swagger_schema do
        title "Shipping"
        description "Details of a shipping"
        properties do
          id :integer, "ID of the shipping"
          order_id :string, "ID of the associated order"
          status :string, "Status of the shipping"
          inserted_at :string, "Timestamp of when the shipping was created"
          updated_at :string, "Timestamp of when the shipping was last updated"
        end
      end,

      GetShippedPackagesResponse: swagger_schema do
        title "Get Shipped Packages Response"
        description "Response payload for retrieving shipped packages"
        properties do
          status :string, "Status of the operation"
          shipped_packages Schema.array(:ShippedPackage), "List of shipped packages"
        end
      end
    }
  end
end
