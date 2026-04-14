from fastapi import FastAPI
import numpy as np
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from fetch_data import fetch_order_lines_data, fetch_customer_data, fetch_sales_transactions_data, fetch_store_data

app = FastAPI()

@app.get("/")
async def info():
    data = jsonable_encoder({'health': 'Healthy', 'version': '1.0.0'})
    return JSONResponse(content=data)

@app.get("/api/orders")
async def get_orders():
    orders = fetch_order_lines_data().replace({np.nan: None}).to_dict(orient='records')
    orders = jsonable_encoder(orders)
    return JSONResponse(content=orders)

@app.get('/api/stores')
async def get_stores():
    stores = fetch_store_data().replace({np.nan: None}).to_dict(orient='records')
    stores = jsonable_encoder(stores)
    return JSONResponse(stores)

@app.get('/api/sales')
async def get_sales():
    sales = fetch_sales_transactions_data().replace({np.nan: None}).to_dict(orient='records')
    sales = jsonable_encoder(sales)
    return JSONResponse(sales)

@app.get('/api/customers')
async def get_customers():
    customers = fetch_customer_data().replace({np.nan: None}).to_dict(orient='records')
    customers = jsonable_encoder(customers)
    return JSONResponse(customers)

