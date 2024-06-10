defmodule InventoryApiWeb.OrderSchemas do
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
      OrderItem: swagger_schema do
        title "Order Item"
        description "An item in an order"
        properties do
          product_id :string, "ID of the product"
          quantity :integer, "Quantity of the product"
        end
      end,

      OrderItemResponse: swagger_schema do
        title "Order Item Response"
        description "Response details of an order item"
        properties do
          id :integer, "ID of the order item"
          product Schema.ref(:Product), "Product details"
          quantity :integer, "Quantity of the product"
          status :string, "Status of the order item"
          inserted_at :string, "Timestamp of when the order item was created"
          updated_at :string, "Timestamp of when the order item was last updated"
        end
      end,

      ProcessOrderResponse: swagger_schema do
        title "Process Order Response"
        description "Response payload for processing an order"
        properties do
          status :string, "Status of the order processing"
          message :string, "Success or error message"
          order_items Schema.array(:OrderItemResponse), "List of processed order items"
        end
      end,

      GetOrderResponse: swagger_schema do
        title "Get Order Response"
        description "Response payload for retrieving an order"
        properties do
          status :string, "Status of the operation"
          order Schema.ref(:Order), "Order details"
        end
      end,

      Order: swagger_schema do
        title "Order"
        description "Details of an order"
        properties do
          order_id :string, "ID of the order"
          items Schema.array(:OrderItemResponse), "List of items in the order"
        end
      end
    }
  end
end
