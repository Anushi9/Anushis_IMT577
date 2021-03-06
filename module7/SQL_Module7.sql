USE IMT577_DW_ANUSHISETH_MODULE5

/*
 * Fact_ProductSalesTarget  
 */

-- DROP AND CREATE TABLE Fact_ProductSalesTarget

DROP TABLE Fact_ProductSalesTarget;

CREATE TABLE Fact_ProductSalesTarget (
  DimProductID INTEGER CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(ProductID), --Foreign Key
  DimTargetDateID Number (9) CONSTRAINT FK_TargetDateID FOREIGN KEY REFERENCES Dim_Date(Date_Pkey), --Foreign Key
  ProductTargetSalesQuantity INT NOT NULL
);

-- INSERT DATA INTO TABLE Fact_ProductSalesTarget

INSERT INTO Fact_ProductSalesTarget (DimProductID, DimTargetDateID,ProductTargetSalesQuantity)
SELECT q2.PRODUCTID,q1.DATE_PKEY,q2.SALESQUANTITYTARGET FROM 
(SELECT FISCAL_YEAR, min(DATE_PKEY) as DATE_PKEY FROM DIM_DATE  GROUP BY FISCAL_YEAR) q1
INNER JOIN
STAGE_TARGETDATAPRODUCT q2 
ON q1.FISCAL_YEAR = q2.YEAR;

-- SELECT DATA FROM Fact_ProductSalesTarget

SELECT * FROM Fact_ProductSalesTarget;


/*
 *  Fact_SRCSalesTarget
 */

-- UPDATE DIM_RESELLER SET RESELLERNAME='Mississippi Distributors' WHERE DIMRESELLERID=5;
-- UPDATE DIM_CHANNEL SET CHANNELNAME='Online' WHERE DIMCHANNELID=3;


-- DROP AND CREATE TABLE Fact_SRCSalesTarget

DROP TABLE Fact_SRCSalesTarget;

CREATE TABLE Fact_SRCSalesTarget(
   DimStoreID INTEGER CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES Dim_Store(DimStoreID), --Foreign Key
   DimResellerID INTEGER CONSTRAINT FK_DimSResellerID FOREIGN KEY REFERENCES Dim_Reseller(DimResellerID), --Foreign Key
   DimChannelID INTEGER CONSTRAINT FK_DimChannelID FOREIGN KEY REFERENCES Dim_Channel(DimChannelID),--Foreign Key
   DimTargetDateID Number (9) CONSTRAINT FK_TargetDateID FOREIGN KEY REFERENCES Dim_Date(Date_Pkey), --Foreign Key
   SalesTargetAmount FLOAT Not Null
) 

-- INSERT DATA INTO Fact_SRCSalesTarget

INSERT INTO Fact_SRCSalesTarget(DimStoreID, DimResellerID,DimChannelID,DimTargetDateID,SalesTargetAmount)
SELECT IFNULL(q5.DIMSTOREID,1) as DIMSTOREID, IFNULL(q4.DIMRESELLERID,1) as DIMRESELLERID, q3.DIMCHANNELID, q1.DATE_PKEY, q2.TARGETSALESAMOUNT
From (SELECT FISCAL_YEAR, min(DATE_PKEY) as DATE_PKEY FROM DIM_DATE  GROUP BY FISCAL_YEAR) q1
INNER JOIN
STAGE_TARGETDATACHANNELRESELLERANDSTORE q2
ON q1.FISCAL_YEAR = q2.YEAR
INNER JOIN Dim_Channel q3
ON q2.CHANNELNAME=q3.CHANNELNAME
LEFT JOIN Dim_RESELLER q4
ON q2.TARGETNAME=q4.RESELLERNAME
LEFT JOIN Dim_STORE q5
ON q2.TARGETNAME=CONCAT('Store Number ', q5.STORENUMBER)

-- SELECT DATA FROM Fact_SRCSalesTarget

SELECT * FROM Fact_SRCSalesTarget;

/*
 * Fact_SalesActual
 */

-- DROP AND CREATE TABLE Fact_SalesActual

DROP TABLE Fact_SalesActual;

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

-- INSERT DATA INTO TABLE Fact_SalesActual
INSERT INTO  Fact_SalesActual (DimProductID,DimStoreID,DimResellerID,DimCustomerID,DimChannelID,DimSaleDateID,DimLocationID,
                               SourceSalesHeaderID,SourceSalesDetailID,SaleAmount,SaleQuantity,SaleUnitPrice,SaleExtendedCost,SaleTotalProfit)
SELECT q3.PRODUCTID,IFNULL(q4.DIMSTOREID,1) as DIMSTOREID,IFNULL(q5.DIMRESELLERID, 1) as DIMRESELLERID, IFNULL(q6.DIMCUSTOMERID,1) as DIMCUSTOMERID,
        IFNULL(q7.DIMCHANNELID,1) as DIMCHANNELID,q8.DATE_PKEY,IFNULL(q4.DIMLOCATIONID,IFNULL(q5.DIMLOCATIONID,q6.DIMLOCATIONID)) as DIMLOCATIONID,
        q1.SALESHEADERID,q2.SALESDETAILID,q2.SALESAMOUNT,q2.SALESQUANTITY,q3.PRODUCTRETAILPRICE,q3.PRODUCTCOST,q3.PRODUCTRETAILPROFIT*q2.SALESQUANTITY
FROM STAGESALESHEADER q1
INNER JOIN STAGE_SALESDETAIL q2
ON q1.SALESHEADERID=q2.SALESHEADERID
INNER JOIN DIM_PRODUCT q3
ON q2.PRODUCTID=q3.SOURCEPRODUCTID
LEFT JOIN DIM_STORE q4
ON q1.STOREID=q4.STOREID
LEFT JOIN DIM_RESELLER q5
ON q1.RESELLERID=q5.SOURCERESELLERID
LEFT JOIN DIM_CUSTOMER q6
ON q1.CUSTOMERID=q6.CUSTOMERID
LEFT JOIN DIM_CHANNEL q7
ON q1.CHANNELID=q7.SOURCECHANNELID
INNER JOIN DIM_DATE q8
ON q8.DATE=TO_DATE(q1.DATE,'MM/DD/YY');


-- SELECT DATA FROM Fact_SalesActual
SELECT * FROM Fact_SalesActual;
