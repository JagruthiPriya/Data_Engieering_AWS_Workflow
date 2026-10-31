# Pandas Order Processing

## Overview

This project demonstrates how Python and Pandas can be used to process order data stored in CSV files.

The pipeline reads customer, order, and product data, performs data-quality validation, joins the datasets, calculates order totals, and generates a final CSV file containing valid order details.

## Use Case

The system performs the following operations:

1. Read customer, order, and product CSV files.
2. Remove duplicate customer records.
3. Identify orders with invalid customer IDs.
4. Filter out invalid orders.
5. Join orders with customer information.
6. Join orders with product information.
7. Calculate `total_amount` using:

```text
total_amount = quantity × price
```

8. Save the processed data into `final_orders.csv`.

## Project Architecture

```text
customers.csv ───────┐
                     │
orders.csv ──────────┼──> Pandas Processing ──> final_orders.csv
                     │
products.csv ────────┘
```

## Project Structure

```text
Pandas_Order_Processing/
│
├── data/
│   ├── customers.csv
│   ├── orders.csv
│   └── products.csv
│
├── output/
│   └── final_orders.csv
│
├── src/
│   └── process_orders.py
│
├── README.md
└── requirements.txt
```

## Input Data

### Customers

Contains:

- `customer_id`
- `customer_name`
- `city`

The input contains a duplicate customer record to demonstrate duplicate removal.

### Orders

Contains:

- `order_id`
- `customer_id`
- `product_id`
- `quantity`
- `status`

One order contains an invalid customer ID to demonstrate data validation.

### Products

Contains:

- `product_id`
- `product_name`
- `price`

## Data Processing

### 1. Remove Duplicate Customers

Duplicate customer records are removed using the customer ID.

```python
customers = customers.drop_duplicates(
    subset=["customer_id"]
)
```

### 2. Identify Invalid Orders

Orders are checked against the valid customer IDs.

```python
valid_customer_ids = set(customers["customer_id"])

invalid_orders = orders[
    ~orders["customer_id"].isin(valid_customer_ids)
]
```

Orders with customer IDs that do not exist in the customer dataset are treated as invalid.

### 3. Join Customer Details

Valid orders are joined with customer information.

```python
orders_customers = valid_orders.merge(
    customers,
    on="customer_id",
    how="inner"
)
```

### 4. Join Product Details

The customer-enriched orders are then joined with product information.

```python
final_orders = orders_customers.merge(
    products,
    on="product_id",
    how="inner"
)
```

### 5. Calculate Order Total

The total amount is calculated using quantity and product price.

```python
final_orders["total_amount"] = (
    final_orders["quantity"] *
    final_orders["price"]
)
```

## Output

The final output contains:

- `order_id`
- `customer_name`
- `city`
- `product_name`
- `quantity`
- `price`
- `status`
- `total_amount`

The output is saved as:

```text
output/final_orders.csv
```

## Example Output

```text
order_id,customer_name,city,product_name,quantity,price,status,total_amount
O101,Rahul,Hyderabad,Laptop,1,50000,Delivered,50000
O102,Priya,Bangalore,Mobile,2,20000,Delivered,40000
O103,Amit,Chennai,Headphones,1,2000,Pending,2000
O104,Rahul,Hyderabad,Mobile,1,20000,Delivered,20000
```

## Technologies

- Python
- Pandas
- CSV
- Git
- GitHub
- VS Code

## How to Run

Create and activate a Python virtual environment:

```powershell
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\.venv\Scripts\Activate.ps1
```

Install dependencies:

```powershell
pip install -r requirements.txt
```

Run the processing script:

```powershell
python src\process_orders.py
```

The processed file will be generated at:

```text
output/final_orders.csv
```

## Result

The project successfully demonstrates a basic batch data-processing workflow using Pandas, including data cleaning, validation, joining datasets, calculation, and CSV output generation.