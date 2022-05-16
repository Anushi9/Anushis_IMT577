USE IMT577_DW_ANUSHISETH_MODULE5

/*

*/


Drop table Fact_ProductSalesTarget;

Create Table Fact_ProductSalesTarget (
  DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(ProductID), --Foreign Key
  DimTargetDateID Number (9) CONSTRAINT FK_TargetDateID FOREIGN KEY REFERENCES Dim_Date(Date_Pkey), --Foreign Key
  ProductTargetSalesQuantity INT NOT NULL
);


//INSERT INTO Fact_ProductSalesTarget (DimProductID, DimTargetDateID,ProductTargetSalesQuantity)
//Values (-1,-1,-1,-1)

INSERT INTO Fact_ProductSalesTarget (DimProductID, DimTargetDateID,ProductTargetSalesQuantity)
SELECT q2.PRODUCTID,q1.DATE_PKEY,q2.SALESQUANTITYTARGET FROM 
(SELECT FISCAL_YEAR, min(DATE_PKEY) as DATE_PKEY FROM DIM_DATE  GROUP BY FISCAL_YEAR) q1
INNER JOIN
STAGE_TARGETDATAPRODUCT q2 
ON q1.FISCAL_YEAR = q2.YEAR;


Select * From Fact_ProductSalesTarget;


/*

*/


CREATE TABLE Fact_SalesActual
(
  DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(ProductID), --Foreign Key
  DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID), --Foreign Key
  DimResellerID INTEGER CONSTRAINT FK_DimSResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID), --Foreign Key 
  DimCustomerID INTEGER CONSTRAINT FK_DimustomerID FOREIGN KEY REFERENCES Dim_Customer(DimCustomerID), --Foreign Key
  DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID),--Foreign Key
  DimSaleDateID Number (9) CONSTRAINT FK_DimSaleDateID FOREIGN KEY REFERENCES Dim_Date(Date_Pkey), --Foreign Key
  DimLocationID INTEGER CONSTRAINT FK_DimLocationID FOREIGN KEY REFERENCES Dim_Location(DimLocationID), --Foreign Key
  SourceSalesHeaderID INTEGER NOT NULL,
  SourceSalesDetailID INTEGER NOT NULL,
  SaleAmount FLOAT NOT NULL,
  SaleQuantity INTEGER NOT NULL,
  SaleUnitPrice FLOAT NOT NULL,
  SaleExtendedCost FLOAT NOT NULL,
  SaleTotalProfit FLOAT NOT NULL
);





 
 Drop table Fact_SalesActual;
 
 Select * From Fact_SalesActual;
 
 INSERT INTO  Fact_SalesActual (DimProductID,DimStoreID,DimResellerID,DimCustomerID,DimChannelID,DimSaleDateID,DimLocationID,SourceSalesHeaderID,SourceSalesDetailID,SaleAmount,SaleQuantity,SaleUnitPrice,
          SaleExtendedCost,SaleTotalProfit)
              
      Values  (-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1);
      
      INSERT INTO  Fact_SalesActual (DimProductID,DimStoreID,DimResellerID,DimCustomerID,DimChannelID,DimSaleDateID,DimLocationID,SourceSalesHeaderID,SourceSalesDetailID,SaleAmount,SaleQuantity,SaleUnitPrice,
          SaleExtendedCost,SaleTotalProfit)
          
          Select Distinct DimProductID,DimStoreID,DimResellerID,DimCustomerID,DimChannelID,DimSaleDateID,DimLocationID,SourceSalesHeaderID,SourceSalesDetailID,SaleAmount,SaleQuantity,SaleUnitPrice,
          SaleExtendedCost,SaleTotalProfit
          
  From Dim_Product
  
  
  
  
  
  Create Table Fact_SRCSalesTarget(
    
   DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID), --Foreign Key
   DimResellerID INTEGER CONSTRAINT FK_DimSResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID), --Foreign Key
   DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID),--Foreign Key
   DimTargetDateID Number (9) CONSTRAINT FK_TargetDateID FOREIGN KEY REFERENCES Dim_Date(Date_Pkey), --Foreign Key
   SalesTargetAmount FLOAT Not Null
) 

Drop table Fact_SRCSalesTarget;

Select * From Fact_SRCSalesTarget

INSERT INTO Fact_SRCSalesTarget(DimStoreID, DimResellerID,DimChannelID,DimTargetDateID, SalesTargetAmount)
Values (-1,-1,-1,-1,-1);

---INSERt INTO Fact_SRCSalesTarget(DimStoreID, DimResellerID,DimChannelID,DimTargetDateID,SalesTargetAmount)
Select q1.DATE_PKEY,q2.CHANNELNAME,q2.TARGETSALESAMOUNT
From (SELECT FISCAL_YEAR, min(DATE_PKEY) as DATE_PKEY FROM DIM_DATE  GROUP BY FISCAL_YEAR) q1
INNER JOIN
STAGE_TARGETDATACHANNELRESELLERANDSTORE q2
ON q1.FISCAL_YEAR = q2.YEAR
INNER JOIN Dim_Channel  













  
//1/1/13 22:12
//
//SELECT CONVERT(date, CREATEDDATE) FROM STAGESALESHEADER LIMIT 1;
//
//
//SELECT PRODUCTID,  TO_DATE ( DATE,'MM/DD/YY') AS TARGET_DATE, SALESQUANTITY FROM STAGE_SALESDETAIL;
//
//
//
//SELECT TO_DATE ( DATE,'MM/DD/YY') AS TARGET_DATE FROM STAGESALESHEADER LIMIT 1000;
// 
//
//select to_date('2012-12-31 23:59:59','YYYY-MM-DD HH24:MI:SS') as DD
//
//
//SELECT TOP 1000 * FROM STAGESALESHEADER;
//
//SELECT DATE_PKEY FROM DIM_DATE ORDER BY DATE_PKEY;





SELECT TO_DATE ( DATE,'MM/DD/YY') AS TARGET_DATE FROM STAGESALESHEADER LIMIT 1000;
    
   
          STAGE_SALESDETAIL

SELECT DISTINCT YEAR FROM STAGE_TARGETDATAPRODUCT;


INSERT Target_Fact
SELECT (productid, salesquantityTarget, 1) FROM STAGE_TARGETDATAPRODUCT WHERE YEAR = 2013;


INSERT INTO Fact_ProductSalesTarget (DimProductID, DimTargetDateID,ProductTargetSalesQuantity)
SELECT q2.PRODUCTID,q1.DATE_PKEY,q2.SALESQUANTITYTARGET FROM 
(SELECT FISCAL_YEAR, min(DATE_PKEY) as DATE_PKEY FROM DIM_DATE  GROUP BY FISCAL_YEAR) q1
INNER JOIN
(SELECT PRODUCTID, PRODUCT, YEAR, SALESQUANTITYTARGET FROM STAGE_TARGETDATAPRODUCT) q2
ON q1.FISCAL_YEAR = q2.YEAR;
