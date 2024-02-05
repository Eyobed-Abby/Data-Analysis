select *
from NashvilleHousing

-- standardizing date format
select SaleDate, CONVERT(date, SaleDate)
from NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = CONVERT(Date, SaleDate);


-- populate property address data

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual columns (Address, City, State)


select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
-- order by ParcelID


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));



select *
from NashvilleHousing


select OwnerAddress
from NashvilleHousing

-- using parsename
select 
PARSENAME(replace(OWnerAddress, ',', '.'), 3),
PARSENAME(replace(OWnerAddress, ',', '.'), 2),
PARSENAME(replace(OWnerAddress, ',', '.'), 1)
from NashvilleHousing



alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OWnerAddress, ',', '.'), 3);

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OWnerAddress, ',', '.'), 2);

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OWnerAddress, ',', '.'), 1);


select *
from NashvilleHousing



-- chaning Y and N to yes and no in 'sold as vacant' field
select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant

select distinct(SoldASVacant),
count(SoldAsVacant) over (partition by SoldAsVacant)
from NashvilleHousing



select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end 



--removing duplicates
with rowNumCTE as(
select *, 
ROW_NUMBER()  over(
partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
order by UniqueID
) row_num

from NashvilleHousing
)

--checking delete
select *
from rowNumCTE
where row_num > 1



--delete
--from rowNumCTE
--where row_num > 1




-- removing unused  columns
select *
from NashvilleHousing

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table NashvilleHousing
drop column SaleDate


