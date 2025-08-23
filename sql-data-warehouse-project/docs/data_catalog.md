<h1>Overview</h1>
<p>
  The Gold Layer represents the business-level data, 
  which is structured to support analytical and reporting use cases. 
  It consists of <strong>dimension tables</strong> and <strong>fact tables</strong>.
</p>
<hr/>
<ol>
  <li>
    <h3>Gold.dim_customers</h3>
    <ul>
      <li><strong>Purpose</strong>: Stores customer details enriched with demographic and geographic data.</li>
      <li>
        <strong>Columns</strong>:
        <table>
          <thead>
            <tr style="text-align: center;">
              <td>Column Name</td>
              <td>Data Type</td>
              <td>Description</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>customer_key</td>
              <td>INT</td>
              <td>Surrogate key uniquely identifying each customer record in the dimension table.</td>
            </tr>
            <tr>
              <td>customer_id</td>
              <td>INT</td>
              <td>Unique numerical identifier assigned to each customer.</td>
            </tr>
            <tr>
              <td>customer_number</td>
              <td>NVARCHAR(50)</td>
              <td>Alphanumeric identifier representing the customer.</td>
            </tr>
            <tr>
              <td>first_name</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the customer's first name.</td>
            </tr>
            <tr>
              <td>last_name</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the customer's last name.</td>
            </tr>
            <tr>
              <td>country</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the country of residence for the customer.</td>
            </tr>
            <tr>
              <td>marital_status</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the customer's marital status.</td>
            </tr>
            <tr>
              <td>gender</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the customer's gender.</td>
            </tr>
            <tr>
              <td>birtdate</td>
              <td>DATE</td>
              <td>Represents the customer's date of birth.</td>
            </tr>
            <tr>
              <td>create_date</td>
              <td>DATE</td>
              <td>Represents the date and time when the customer record was created in the system.</td>
            </tr>
          </tbody>
        </table>
      </li>
    </ul>
  </li>

  <li>
    <h3>Gold.dim_products</h3>
    <ul>
      <li><strong>Purpose</strong>: Stores product details enriched with category and subcategory data.</li>
      <li>
        <strong>Columns</strong>:
        <table>
          <thead>
            <tr style="text-align: center;">
              <td>Column Name</td>
              <td>Data Type</td>
              <td>Description</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>product_key</td>
              <td>INT</td>
              <td>Surrogate key uniquely identifying each product record in the dimension table.</td>
            </tr>
            <tr>
              <td>product_id</td>
              <td>INT</td>
              <td>Unique numerical identifier assigned to each product.</td>
            </tr>
            <tr>
              <td>product_number</td>
              <td>NVARCHAR(50)</td>
              <td>A structured alphanumeric code representing the product.</td>
            </tr>
            <tr>
              <td>product_name</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the name of the product.</td>
            </tr>
            <tr>
              <td>category_id</td>
              <td>NVARCHAR(50)</td>
              <td>Represents a unique identifier for the product's category.</td>
            </tr>
            <tr>
              <td>category</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the broader classification of the product.</td>
            </tr>
            <tr>
              <td>subcategory</td>
              <td>NVARCHAR(50)</td>
              <td>Represents a detailed classification of the product.</td>
            </tr>
            <tr>
              <td>maintainance</td>
              <td>NVARCHAR(50)</td>
              <td>Indicates whether a product requires maintainance or not.</td>
            </tr>
            <tr>
              <td>cost</td>
              <td>INT</td>
              <td>Represents the cost of the product.</td>
            </tr>
            <tr>
              <td>product_line</td>
              <td>NVARCHAR(50)</td>
              <td>Represents the specific product line or series to which the product belongs.</td>
            </tr>
            <tr>
              <td>start_date</td>
              <td>DATE</td>
              <td>Represents the date when the product becomes available for sale.</td>
            </tr>
          </tbody>
        </table>
      </li>
    </ul>
  </li>
  <li>
    <h3>Gold.sales_details</h3>
    <ul>
      <li><strong>Purpose</strong>: Stores the transactional sales data for analytical purposes.</li>
      <li>
        <strong>Columns</strong>:
        <table>
          <thead>
            <tr style="text-align: center;">
              <td>Column Name</td>
              <td>Data Type</td>
              <td>Description</td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>order_number</td>
              <td>NVARCHAR(50)</td>
              <td>A unique alphanumeric identifier for each sales order.</td>
            </tr>
            <tr>
              <td>product_key</td>
              <td>INT</td>
              <td>Surrogate key linking to a product in the dimension table.</td>
            </tr>
            <tr>
              <td>customer_key</td>
              <td>INT</td>
              <td>Surrogate key linking to a customer in the dimension table.</td>
            </tr>
            <tr>
              <td>order_date</td>
              <td>DATE</td>
              <td>Represents the date when the order was placed.</td>
            </tr>
            <tr>
              <td>shipping_date</td>
              <td>DATE</td>
              <td>Represents the date when the order was shipped to the customer.</td>
            </tr>
            <tr>
              <td>due_date</td>
              <td>DATE</td>
              <td>Represents the date when the order payment is due.</td>
            </tr>
            <tr>
              <td>sales_amount</td>
              <td>INT</td>
              <td>Represents the total monetary value of the sale for the line item.</td>
            </tr>
            <tr>
              <td>quantity</td>
              <td>INT</td>
              <td>Represents the number of units of the product ordered for the line item.</td>
            </tr>
            <tr>
              <td>price</td>
              <td>INT</td>
              <td>Represents the price per unit of the product for the line term.</td>
            </tr>
          </tbody>
        </table>
      </li>
    </ul>
  </li>
</ol>
