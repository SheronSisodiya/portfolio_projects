--Cleaning data in SQL query

SELECT *
FROM portfolio_project.dbo.nashville_housing


-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM portfolio_project.dbo.nashville_housing

UPDATE nashville_housing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE nashville_housing
Add SaleDateConverted date;

UPDATE nashville_housing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate Property Address Data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolio_project.dbo.nashville_housing a
JOIN portfolio_project.dbo.nashville_housing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is Null

UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM portfolio_project.dbo.nashville_housing a
JOIN portfolio_project.dbo.nashville_housing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


--Breaking out address into individual columns

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS address
FROM nashville_housing

ALTER TABLE nashville_housing
ADD PropertySplitAddress Nvarchar(255);

UPDATE nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE nashville_housing
ADD PropertySplitCity Nvarchar (255);

UPDATE nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM nashville_housing



SELECT OwnerAddress
FROM portfolio_project.dbo.nashville_housing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM portfolio_project.dbo.nashville_housing

ALTER TABLE portfolio_project.dbo.nashville_housing
ADD OwnerSplitAddress Nvarchar(255), OwnerSplitCity Nvarchar(255), OwnerSplitState Nvarchar(255);

UPDATE portfolio_project.dbo.nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

UPDATE portfolio_project.dbo.nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

UPDATE portfolio_project.dbo.nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM portfolio_project.dbo.nashville_housing









--Change 'Y' and 'N' to Yes and No in SoldAsVacant column

SELECT SoldAsVacant
,    CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	     WHEN SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
     END
FROM portfolio_project.dbo.nashville_housing

UPDATE portfolio_project.dbo.nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	     WHEN SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
     END




-- Remove Duplication

WITH RowNumCTE AS(
SELECT*,
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				       UniqueID
					) row_num

FROM portfolio_project.dbo.nashville_housing
)
SELECT *
FROM RowNumCTE
WHERE row_num>1
ORDER BY PropertyAddress













--Delete Unused Column

SELECT *
FROM portfolio_project.dbo.nashville_housing

ALTER TABLE portfolio_project.dbo.nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE portfolio_project.dbo.nashville_housing
DROP COLUMN SaleDate
   





