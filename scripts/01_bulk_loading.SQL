/*

Script Purpose:
  This script loads data into gold schemas
  Uses the BULK INSERT command to load the data from CSV files to gold tables.


*/


BULK INSERT gold.sales_customer
FROM 'C:\Users\viven\Downloads\Bikestore database\sales\customers.csv'
	WITH (
  		FIRSTROW = 2,
      	FIELDTERMINATOR = ',',
		KEEPNULLS,
      	TABLOCK
  	);


BULK INSERT gold.sales_order_items
FROM 'C:\Users\viven\Downloads\Bikestore database\sales\order_items.csv'
    WITH (
		FIRSTROW = 2,
      	FIELDTERMINATOR = ',',
      	TABLOCK
    );


BULK INSERT gold.sales_orders
FROM 'C:\Users\viven\Downloads\Bikestore database\sales\orders.csv'
    WITH (
		FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        TABLOCK
    );


BULK INSERT gold.sales_staffs
FROM 'C:\Users\viven\Downloads\Bikestore database\sales\staffs.csv'
	WITH (
		FIRSTROW = 2,
      	FIELDTERMINATOR = ',',
      	KEEPNULLS,
      	TABLOCK
    );


BULK INSERT gold.sales_stores
FROM 'C:\Users\viven\Downloads\Bikestore database\sales\stores.csv'
    WITH (
		FIRSTROW = 2,
    	FIELDTERMINATOR = ',',
    	KEEPNULLS,
    	TABLOCK
    );


BULK INSERT gold.production_brands
FROM 'C:\Users\viven\Downloads\Bikestore database\production\brands.csv'
    WITH (
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ',',
    	KEEPNULLS,
    	TABLOCK
    );


BULK INSERT gold.production_categories
FROM 'C:\Users\viven\Downloads\Bikestore database\production\categories.csv'
    WITH (
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ',',
    	KEEPNULLS,
    	TABLOCK
    );


BULK INSERT gold.production_products
FROM 'C:\Users\viven\Downloads\Bikestore database\production\products.csv'
    WITH (
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ',',
    	KEEPNULLS,
    	TABLOCK
    );


BULK INSERT gold.production_stocks
FROM 'C:\Users\viven\Downloads\Bikestore database\production\stocks.csv'
    WITH (
    	FIRSTROW = 2,
    	FIELDTERMINATOR = ',',
    	KEEPNULLS,
    	TABLOCK
	  );
