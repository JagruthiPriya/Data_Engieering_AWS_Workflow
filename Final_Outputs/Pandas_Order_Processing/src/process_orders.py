import pandas as pd

# Read CSV files

customers = pd.read_csv("data/customers.csv")
products = pd.read_csv("data/products.csv")
orders = pd.read_csv("data/orders.csv")

# Display input data

print("CUSTOMERS")
print(customers)

print("\nPRODUCTS")
print(products)

print("\nORDERS")
print(orders)

# Remove duplicate customer records

customers = customers.drop_duplicates()

print("\nCUSTOMERS AFTER REMOVING DUPLICATES")
print(customers)

# Find orders with invalid customer IDs

valid_customer_ids = customers["customer_id"]

invalid_orders = orders[
    ~orders["customer_id"].isin(valid_customer_ids)
]

print("\nINVALID ORDERS")
print(invalid_orders)

# Keep only valid orders

valid_orders = orders[
    orders["customer_id"].isin(valid_customer_ids)
]

# Join orders with customer details

orders_with_customers = valid_orders.merge(
    customers,
    on="customer_id",
    how="inner"
)

# Join with product details

final_orders = orders_with_customers.merge(
    products,
    on="product_id",
    how="inner"
)

# Calculate total amount

final_orders["total_amount"] = (
    final_orders["quantity"] * final_orders["price"]
)

# Select required columns

final_orders = final_orders[
    [
        "order_id",
        "customer_name",
        "city",
        "product_name",
        "quantity",
        "price",
        "status",
        "total_amount"
    ]
]

# Save final CSV

final_orders.to_csv(
    "output/final_orders.csv",
    index=False
)

# Display final result


print("\nFINAL ORDERS")
print(final_orders)

print("\nFinal file created successfully:")
print("output/final_orders.csv")