SELECT * FROM PortfolioProject.nashville_housing;

SELECT Sale_Date
FROM PortfolioProject.nashville_housing




-- Standardize Date Format

Select Sale_DateConverted, CONVERT(Date,Sale_Date)
From PortfolioProject.nashville_housing;


Update nashville_Housing
SET Sale_Date = CONVERT(Date,Sale_Date)


ALTER TABLE nashville_Housing
Add Sale_DateConverted Date;

Update nashville_Housing
SET Sale_DateConverted = CONVERT(Date Sale_Date);




-- Populate Property Address data
Select *
From PortfolioProject.nashville_Housing
where Property_A
order by Parcel_ID

SELECT a.Parcel_ID, a.Property_Address, b.Parcel_ID, b.Property_Address, ISNULL(a.Property_Address,b.Property_Address)
From PortfolioProject.nashville_Housing a
JOIN PortfolioProject.nashville_Housing b
	ON a.Parcel_ID = b.Parcel_ID
    AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET Property_Address = ISNULL(a.Property_Address,b.Property_Address)
From PortfolioProject.nashville_Housing a
JOIN PortfolioProject.nashville_Housing b
	on a.Parcel_ID = b.Parcel_ID
	AND a.[Unique_ID ] <> b.[Unique_ID ]
Where a.Property_Address is null






-- Breaking out Address into Individual Columns (Address, City, State)


Select Property_Address
From PortfolioProject.nashville_Housing
Where Property_Address is not null
order by Parcel_ID

SELECT
SUBSTRING(Property_Address, 1, CHARIN(',', Property_Address) -1 ) as Address
, SUBSTRING(Property_Address, CHARIN(',', Property_Address) + 1 , LEN(Property_Address)) as Address
From PortfolioProject.nashville_Housing


ALTER TABLE nashville_Housing
Add PropertySplitAddress Nvarchar(255);

UPDATE nashville_Housing
SET PropertySplitAddress = SUBSTRING(Property_Address, 1, CHARINDEX(',', Property_Address) -1 )


ALTER TABLE nashville_Housing
Add PropertySplitCity Nvarchar(255);

Update nashville_Housing
SET PropertySplitCity = SUBSTRING(Property_Address, CHARINDEX(',', Property_Address) + 1 , LEN(Property_Address))

Select *
From PortfolioProject.nashville_Housing


Select Owner_Address
From PortfolioProject.nashville_Housing


Select
PARSENAME(REPLACE(Owner_Address, ',', '.') , 3)
,PARSENAME(REPLACE(Owner_Address, ',', '.') , 2)
,PARSENAME(REPLACE(Owner_Address, ',', '.') , 1)
From PortfolioProject.nashville_Housing


ALTER TABLE nashville_Housing
Add OwnerSplitAddress Nvarchar(255);

Update nashville_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE nashville_Housing
Add OwnerSplitCity Nvarchar(255);

Update nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE nashville_Housing
Add OwnerSplitState Nvarchar(255);

Update nashville_Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.nashville_Housing





-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(Sold_As_Vacant), Count(Sold_As_Vacant)
From PortfolioProject.nashville_Housing
Group by Sold_As_Vacant
order by 2

Select Sold_As_Vacant
, CASE When Sold_As_Vacant = 'Y' THEN 'Yes'
	   When Sold_As_Vacant = 'N' THEN 'No'
	   ELSE Sold_As_Vacant
	   END
       
From PortfolioProject.nashville_Housing

Update nashville_housing
SET Sold_As_Vacant = CASE When Sold_As_Vacant = 'Y' THEN 'Yes'
	   When Sold_As_Vacant = 'N' THEN 'No'
	   ELSE Sold_As_Vacant
	   END
       


       
       
-- Remove Duplicates
       WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY Parcel_ID,
				 Property_Address,
				 Sale_Price,
				 Sale_Date,
				 Legal_Reference
				 ORDER BY
					Unique_ID
					) row_num

From PortfolioProject.nashville_Housing
--order by Parcel_ID
)
Select *
From RowNumCTE
Where row_num > 1
Order by Property_Address


Select *
From PortfolioProject.nashville_Housing




---- Delete Unused Columns

Select *
From PortfolioProject.nashville_Housing


ALTER TABLE PortfolioProject.nashville_Housing
DROP COLUMN Owner_Address, Tax_District, Property_Address, Sale_Date
