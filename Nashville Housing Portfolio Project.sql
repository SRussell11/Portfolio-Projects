USE [PortfolioProject]
GO

--Standardize Date Format
SELECT *
  FROM [dbo].[NashvilleHousing$]

  SELECT SaledateConverted, CONVERT(Date, saledate)
  FROM [dbo].[NashvilleHousing$]

Update NashvilleHousing$
SET Saledate=CONVERT(Date, saledate)


ALTER TABLE NashvilleHousing$
Add SaledateConverted Date;

Update NashvilleHousing$
SET SaledateConverted=CONVERT(Date, saledate)

--Populate Property Address data

 SELECT *
 FROM [dbo].[NashvilleHousing$]
 --WHERE Propertyaddress is null
 ORDER BY parcelid

 SELECT a.parcelid, a.propertyaddress, b.parcelid,b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
 FROM [dbo].[NashvilleHousing$]a
 JOIN [dbo].[NashvilleHousing$]b
	on a.parcelid=b.parcelid
	AND a.[UniqueID] <> b.[UniqueID]
	WHERE a.propertyaddress is null
 

 Update a
 SET propertyaddress= ISNULL(a.propertyaddress,b.propertyaddress)
 FROM [dbo].[NashvilleHousing$]a
 JOIN [dbo].[NashvilleHousing$]b
	on a.parcelid=b.parcelid
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.propertyaddress is null

--Breaking out Address into Individual Columns(Address, City, State)


 SELECT propertyaddress
 FROM [dbo].[NashvilleHousing$]
 --WHERE Propertyaddress is null
 --ORDER BY parcelid

 SELECT
 SUBSTRING(Propertyaddress,1, CHARINDEX(',',propertyaddress)-1) as Address
 , SUBSTRING(Propertyaddress, CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as Address

 From PortfolioProject.dbo.NashvilleHousing$


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing$
SET PropertySplitAddress=SUBSTRING(Propertyaddress,1, CHARINDEX(',',propertyaddress)-1)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing$
SET PropertySplitCity=SUBSTRING(Propertyaddress, CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))


SELECT *
 From PortfolioProject.dbo.NashvilleHousing$


 SELECT owneraddress
 From PortfolioProject.dbo.NashvilleHousing$

 SELECT 
 PARSENAME(REPLACE(owneraddress,',','.'),3)
 ,PARSENAME(REPLACE(owneraddress,',','.'),2)
 ,PARSENAME(REPLACE(owneraddress,',','.'),1)
   From PortfolioProject.dbo.NashvilleHousing$


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
Add OwnerAddressSplit Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing$
SET OwnerAddressSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing$
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing$
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
 From PortfolioProject.dbo.NashvilleHousing$



 --Change Y an N to Yes and No in "Sold as Vacant" field

 Select Distinct (SoldAsVacant), Count(SoldAsVacant)
 From PortfolioProject.dbo.NashvilleHousing$
 GROUP BY SoldAsVacant
 Order By 2

 Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant ='N' THEN 'No'
	   ELSE SoldAsVacant
	   END
 From PortfolioProject.dbo.NashvilleHousing$

 UPDATE PortfolioProject.dbo.NashvilleHousing$
 SET SoldAsVacant =CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant ='N' THEN 'No'
	   ELSE SoldAsVacant
	   END


 --Remove Duplicate

 WITH RowNumCTE AS (
SELECT *,
     ROW_NUMBER() OVER (
	 PARTITION BY ParcelID,
				  PropertyAddress,
			      SalePrice,
				  SaleDate,
			      LegalReference
				  ORDER BY
					UniqueID
					)row_num

From PortfolioProject.dbo.NashvilleHousing$
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
--Order by PropertyAddress



 --Delete Unused Columns

SELECT *
From PortfolioProject.dbo.NashvilleHousing$


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing$
DROP COLUMN SaleDate
