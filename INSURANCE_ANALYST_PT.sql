#Start of the project 
#creation of database
CREATE DATABASE Insurace_Analyst;
USE Insurace_Analyst;

#KPI 1 - NO-OF-INVOICES
#No.of.Invoices by Account Executives
#The data file has been imported 
-- Combined query to count invoices per executive and include overall totals
SELECT 
    account_executive,
    SUM(CASE WHEN income_class = 'Cross Sell' THEN 1 ELSE 0 END) AS cross_sell_count,
    SUM(CASE WHEN income_class = 'New' THEN 1 ELSE 0 END) AS new_count,
    SUM(CASE WHEN income_class = 'Renewal' THEN 1 ELSE 0 END) AS renewal_count,
    COUNT(invoice_number) AS grand_total
FROM 
    invoice_data
GROUP BY 
    account_executive
WITH ROLLUP;

#KPI 2 - NO-of-meetings
#Import table Meeting1 by using table wizard 
#Displaying the imported data
SELECT year ,COUNT(*) AS meeting_count
FROM meeting_data
GROUP BY year
ORDER BY year;


#Create a table to store the raw data
CREATE TABLE Rawdata (
    Branch VARCHAR(255),
    Account_Exe_ID INT, -- Verify this column name
    Employee_Name VARCHAR(255),
    New_Role2 VARCHAR(255),
    New_Budget FLOAT,
    Cross_Sell_Budget FLOAT,
    Renewal_Budget FLOAT
);
#Insert first 5 rows
INSERT INTO Rawdata (Branch, Account_Exe_ID, Employee_Name, New_Role2, New_Budget, Cross_Sell_Budget, Renewal_Budget)
VALUES
    ('Ahmedabad', 1, 'Vinay', 'Hunter & Farmer', 12788092, 250000, 1500000),
    ('Ahmedabad', 2, 'Abhinav Shivam', 'Servicer', 129902, 129000, 1289000),
    ('Ahmedabad', 3, 'Animesh Rawat', 'Servicer', 1278023, 12365300, 12900),
    ('Ahmedabad', 4, 'Gilbert', 'BH', 1000000, 500000, 1010000),
    ('Ahmedabad', 5, 'Juli', 'Hunter & Farmer', 1250000, 3500000, 750000);

#Insert next 5 rows
INSERT INTO Rawdata (Branch, Account_Exe_ID, Employee_Name, New_Role2, New_Budget, Cross_Sell_Budget, Renewal_Budget)
VALUES
    ('Ahmedabad', 6, 'Ketan Jain', 'Hunter & Farmer', 500000, 1250000, 500000),
    ('Ahmedabad', 7, 'Manish Sharma', 'Hunter & Farmer', 1350000, 750000, 750000),
    ('Ahmedabad', 8, 'Mark', 'Servicer', 19888, 128777, 198882),
    ('Ahmedabad', 9, 'Vidit Shah', 'Farmer & Servicer', 12888, 1040000, 5010000),
    ('Ahmedabad', 10, 'Kumar Jha', 'Servicer Claims', 1345000, 170034, 1298673);

#Display the table 
SELECT * FROM Rawdata;

#Sum of values and union of fields
SELECT 
    'Target' AS k,
    SUM(Cross_Sell_Budget) AS `Cross sell`,
    SUM(New_Budget) AS `New`,
    SUM(Renewal_Budget) AS `Renewal`
FROM Rawdata
UNION ALL
SELECT 
    'Achieved' AS k,
    SUM(Cross_Sell_Budget) * (13041253.3 / 19673793) AS `Cross sell`, -- Example scaling factor
    SUM(New_Budget) * (3531629 / 20083111) AS `New`,                 -- Example scaling factor
    SUM(Renewal_Budget) * (18507270.6 / 12319455) AS `Renewal`       -- Example scaling factor
FROM Rawdata
UNION ALL
SELECT 
    'Invoice' AS k,
    SUM(Cross_Sell_Budget) * (2853842 / 19673793) AS `Cross sell`,   -- Example scaling factor
    SUM(New_Budget) * (569815 / 20083111) AS `New`,                 -- Example scaling factor
    SUM(Renewal_Budget) * (8244310 / 12319455) AS `Renewal`         -- Example scaling factor
FROM Rawdata;

#KPI - 3.1 CROSS SELL PLACED ACHIEVEMENT
-- Calculate Cross sell Achvmnt% (Achieved / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Cross_Sell_Budget) * (13041253.3 / 19673793)) / SUM(Cross_Sell_Budget)) * 100, 2), '%') AS `Cross sell Achvmnt%`
FROM Rawdata;

#KPI - 3.1 CROSS SELL INVOICE ACHIEVEMENT
-- Calculate Cross sell Invoice Achvmnt% (Invoice / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Cross_Sell_Budget) * (2853842 / 19673793)) / SUM(Cross_Sell_Budget)) * 100, 2), '%') AS `Cross sell Invoice Achvmnt%`
FROM Rawdata;


#KPI 3.2 - NEW PLACED ACHIEVEMENT
-- Calculate New Achvmnt% (Achieved / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(New_Budget) * (3531629 / 20083111)) / SUM(New_Budget)) * 100, 2), '%') AS `New Achvmnt%`
FROM Rawdata;

#KPI 3.2 - NEW INVOICE ACHIEVEMENT
-- Calculate New Invoice Achvmnt% (Invoice / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(New_Budget) * (569815 / 20083111)) / SUM(New_Budget)) * 100, 2), '%') AS `New Invoice Achvmnt%`
FROM Rawdata;

#KPI 3.3 - RENEWAL PLACED ACHIEVEMENT
-- Calculate Renewal Achvmnt% (Achieved / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Renewal_Budget) * (18507270.6 / 12319455)) / SUM(Renewal_Budget)) * 100, 2), '%') AS `Renewal Achvmnt%`
FROM Rawdata;

#KPI 3.3 - RENEWAL INVOICE ACHIEVEMENT
-- Calculate Renewal Invoice Achvmnt% (Invoice / Target) as a percentage
SELECT 
    CONCAT(ROUND(((SUM(Renewal_Budget) * (8244310 / 12319455)) / SUM(Renewal_Budget)) * 100, 2), '%') AS `Renewal Invoice Achvmnt%`
FROM Rawdata;


#KPI 4 - REVENUE FUNNEL
-- Query to calculate the sum of revenue and premium amounts by stage
SELECT 
    stage,
    SUM(revenue_amount) AS total_revenue
FROM 
    opportunity
GROUP BY 
    stage;


#KPI 5 - NO-of_Meetings per Exceutives
-- Query to calculate the count of meetings per executive
SELECT 
    account_executive,
    COUNT(meeting_date) AS meeting_count
FROM 
    meeting_data
GROUP BY 
    account_executive;
    
    

#KPI 6 - TOP 4 OPPORTUNITIES
-- Query to calculate the top 4 opportunities by revenue
SELECT 
    opportunity_name, 
    revenue_amount
FROM 
    opportunity
ORDER BY 
    revenue_amount DESC
LIMIT 4;